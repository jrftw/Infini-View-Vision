// HostManagerApp.swift (Non-visionOS)
import Foundation
import Network
import Combine
import os

final class HostManagerApp: ObservableObject {
    @Published var isHosting = false
    @Published var serviceName: String = ""
    @Published var serviceType: String = "_myapp._tcp"
    @Published var isReady = false
    @Published var connectionAccepted = false

    private let log = Logger(subsystem: "com.infini.view.vision", category: "HostManagerApp")
    private var listener: NWListener?
    private var hostConnection: NWConnection?
    private var stateTimer: AnyCancellable?

    func startHosting() {
        guard !isHosting else { return }
        isHosting = true
        serviceName = "Host-\(UUID().uuidString.prefix(8))"

        let params = NWParameters.tcp
        do {
            listener = try NWListener(using: params)
        } catch {
            log.error("Failed to create NWListener: \(error.localizedDescription)")
            isHosting = false
            return
        }

        listener?.service = NWListener.Service(name: serviceName, type: serviceType)
        listener?.stateUpdateHandler = { [weak self] newState in
            guard let self = self else { return }
            DispatchQueue.main.async {
                switch newState {
                case .ready:
                    self.log.info("Host Listener Ready. Service: \(self.serviceName)")
                    self.isReady = true
                case .failed(let err):
                    self.log.error("Listener failed: \(err.localizedDescription)")
                    self.isHosting = false
                default:
                    break
                }
            }
        }

        listener?.newConnectionHandler = { [weak self] connection in
            guard let self = self else { return }
            self.log.info("Host accepted a new connection.")
            self.hostConnection = connection
            connection.start(queue: .global())
            self.receiveDataFromConnection(connection)
            DispatchQueue.main.async {
                self.connectionAccepted = true
                self.startSendingUIState()
            }
        }

        listener?.start(queue: .global())
    }

    func stopHosting() {
        listener?.cancel()
        listener = nil
        hostConnection?.cancel()
        hostConnection = nil
        stateTimer?.cancel()
        stateTimer = nil
        isHosting = false
        isReady = false
        connectionAccepted = false
    }

    private func receiveDataFromConnection(_ connection: NWConnection) {
        connection.receive(minimumIncompleteLength: 1, maximumLength: 4096) { [weak self] data, _, isComplete, error in
            guard let self = self else { return }
            if let data = data {
                self.handleClientCommand(data)
            }
            if isComplete {
                self.log.info("Connection ended by client.")
                self.hostConnection?.cancel()
                self.stopSendingUIState()
            } else if error == nil {
                self.receiveDataFromConnection(connection)
            } else {
                self.log.error("Receive error: \(error?.localizedDescription ?? "unknown error")")
                self.hostConnection?.cancel()
                self.stopSendingUIState()
            }
        }
    }

    private func handleClientCommand(_ data: Data) {}

    func startSendingUIState() {
        guard let connection = hostConnection else { return }
        stateTimer = Timer.publish(every: 1.0, on: .main, in: .common).autoconnect()
            .sink { [weak self] _ in
                self?.sendUIState(connection: connection)
            }
    }

    func stopSendingUIState() {
        stateTimer?.cancel()
        stateTimer = nil
    }

    private func sendUIState(connection: NWConnection) {
        guard let remoteHandler = HostUIState.shared.remoteHandler else { return }
        let state = HostUIStateMessage(offset: remoteHandler.contentOffset, zoom: remoteHandler.zoomLevel)
        guard let data = try? JSONEncoder().encode(state) else { return }
        connection.send(content: data, completion: .contentProcessed { sendError in
            if let err = sendError {
                self.log.error("Failed to send state: \(err.localizedDescription)")
            }
        })
    }
}

struct HostUIStateMessage: Codable {
    let offset: Double
    let zoom: Double
}

final class HostUIState {
    static let shared = HostUIState()
    var remoteHandler: RemoteControlHandler?
    private init() {}
}
