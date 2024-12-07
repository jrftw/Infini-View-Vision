// HandTrackingManagerApp.swift used for devices other than vision pro
import Foundation
import RealityKit
import Combine
import os

class HandTrackingManager: ObservableObject {
    @Published var currentTransform: Transform?
    private let log = Logger(subsystem: "com.infini.view.vision", category: "HandTrackingManager")
    private var timer: AnyCancellable?

    init() {
        startTracking()
    }

    private func startTracking() {
        timer = Timer.publish(every: 0.2, on: .main, in: .common).autoconnect()
            .sink { _ in
                self.log.debug("Hand tracking active.")
            }
    }
}
