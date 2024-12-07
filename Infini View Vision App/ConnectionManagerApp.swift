// ConnectionManagerApp.swift (Shared) used for devices other than vision pro
import Foundation
import Network
import Combine
import os

final class ConnectionManager: ObservableObject {
    @Published var isConnecting = false
    @Published var isConnected = false
    @Published var connectionError: String?

    private let log = Logger(subsystem: "com.infini.view.vision", category: "ConnectionManager")
    var connection: NWConnection?

    func connectToDevice(result: NWBrowser.Result, defaultPort: UInt16 = 12345) {
        guard !isConnecting && !isConnected else { return }
        isConnecting = true
        isConnected = false
        connectionError = nil

        guard case NWEndpoint.service(_, _, _, _) = result.endpoint else {
            isConnecting = false
            connectionError = "Invalid service endpoint."
            return
        }

        let params = NWParameters.tcp
        let newConnection = NWConnection(to: result.endpoint, using: params)
        self.connection = newConnection

        newConnection.stateUpdateHandler = { [weak self] newState in
            guard let self = self else { return }
            DispatchQueue.main.async {
                switch newState {
                case .ready:
                    self.log.info("Connection ready.")
                    self.isConnecting = false
                    self.isConnected = true
                case .failed(let err):
                    self.log.error("Connection failed: \(err.localizedDescription)")
                    self.isConnecting = false
                    self.isConnected = false
                    self.connectionError = err.localizedDescription
                case .waiting(let err):
                    self.log.debug("Connection waiting: \(err.localizedDescription)")
                case .setup, .preparing:
                    break
                case .cancelled:
                    self.log.debug("Connection cancelled.")
                    self.isConnecting = false
                    self.isConnected = false
                @unknown default:
                    self.log.debug("Unknown state.")
                }
            }
        }

        newConnection.start(queue: .global())
    }

    func connectToHost(_ host: String, port: UInt16) {
        guard !isConnecting && !isConnected else { return }
        isConnecting = true
        isConnected = false
        connectionError = nil

        log.info("Attempting direct connection to host: \(host), port: \(port)")

        guard let nwPort = NWEndpoint.Port(rawValue: port) else {
            isConnecting = false
            connectionError = "Invalid port number."
            return
        }

        let nwHost = NWEndpoint.Host(host)
        let params = NWParameters.tcp
        let newConnection = NWConnection(host: nwHost, port: nwPort, using: params)
        self.connection = newConnection

        newConnection.stateUpdateHandler = { [weak self] newState in
            guard let self = self else { return }
            DispatchQueue.main.async {
                switch newState {
                case .ready:
                    self.log.info("Direct connection ready.")
                    self.isConnecting = false
                    self.isConnected = true
                case .failed(let err):
                    self.log.error("Direct connection failed: \(err.localizedDescription)")
                    self.isConnecting = false
                    self.isConnected = false
                    self.connectionError = err.localizedDescription
                case .waiting(let err):
                    self.log.debug("Direct connection waiting: \(err.localizedDescription)")
                case .setup, .preparing:
                    break
                case .cancelled:
                    self.log.debug("Direct connection cancelled.")
                    self.isConnecting = false
                    self.isConnected = false
                @unknown default:
                    self.log.debug("Direct connection unknown state.")
                }
            }
        }

        newConnection.start(queue: .global())
    }

    func disconnect() {
        guard isConnected || isConnecting else { return }
        log.info("Disconnecting.")
        connection?.cancel()
        connection = nil
        isConnected = false
        isConnecting = false
        connectionError = nil
    }

    func sendCommandMessage(_ data: Data) {
        guard isConnected, let connection = connection else { return }
        connection.send(content: data, completion: .contentProcessed({ sendError in
            if let sendError = sendError {
                self.log.error("Send failed: \(sendError.localizedDescription)")
            }
        }))
    }

    func startReceivingHostState(receiver: ClientStateReceiverApp) {
        guard let connection = connection else { return }
        connection.receive(minimumIncompleteLength: 1, maximumLength: 4096) { [weak self] data, _, isComplete, error in
            if let data = data {
                receiver.receiveData(data)
            }
            if isComplete || error != nil {
                self?.log.info("Stopped receiving host state")
                return
            } else {
                self?.startReceivingHostState(receiver: receiver)
            }
        }
    }
}
