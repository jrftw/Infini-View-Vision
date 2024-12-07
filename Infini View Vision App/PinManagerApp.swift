// PinManagerApp.swift (Non-visionOS)
import Foundation
import os

class PinManagerApp: ObservableObject {
    @Published var currentPin: String?
    private let log = Logger(subsystem: "com.infini.view.vision", category: "PinManagerApp")

    func generatePin() {
        let pin = String(format: "%04d", Int.random(in: 0...9999))
        currentPin = pin
        log.info("Generated PIN: \(pin)")
    }

    func verifyPin(_ pin: String) -> Bool {
        return pin == currentPin
    }
}
