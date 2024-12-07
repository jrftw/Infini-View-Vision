// DeviceDiscoveryManagerApp.swift used for devices other than vision pro
import Foundation
import Network
import Combine
import os

final class DeviceDiscoveryManagerApp: ObservableObject {
    @Published var discoveredDevices: [NWBrowser.Result] = []
    @Published var isSearching: Bool = false

    private let log = Logger(subsystem: "com.infini.view.vision", category: "DeviceDiscoveryManager")
    private var browser: NWBrowser?

    func startDiscovery(serviceType: String = "_myapp._tcp") {
        guard !isSearching else { return }
        isSearching = true
        discoveredDevices.removeAll()

        let parameters = NWParameters()
        parameters.includePeerToPeer = true
        let browser = NWBrowser(for: .bonjour(type: serviceType, domain: nil), using: parameters)
        self.browser = browser

        browser.stateUpdateHandler = { [weak self] newState in
            guard let self = self else { return }
            switch newState {
            case .ready:
                self.log.info("Browser ready.")
            case .failed(let error):
                self.log.error("Browser failed: \(error.localizedDescription)")
                DispatchQueue.main.async {
                    self.isSearching = false
                }
            default:
                break
            }
        }

        browser.browseResultsChangedHandler = { [weak self] results, _ in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.discoveredDevices = Array(results)
                self.isSearching = false
                self.log.info("Device discovery updated with \(results.count) results.")
            }
        }

        browser.start(queue: .global())
    }

    func stopDiscovery() {
        browser?.cancel()
        browser = nil
        isSearching = false
        log.debug("Device discovery stopped.")
    }
}
