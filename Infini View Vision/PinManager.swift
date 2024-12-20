//PinManager.swift - used for vision pro

import Foundation
import os

class PinManager: ObservableObject {
    @Published var currentPin: String?
    private let log = Logger(subsystem: "com.infini.view.vision", category: "PinManager")

    func generatePin() {
        let pin = String(format: "%04d", Int.random(in: 0...9999))
        currentPin = pin
        log.info("Generated PIN: \(pin)")
    }

    func verifyPin(_ pin: String) -> Bool {
        return pin == currentPin
    }
}
