// EyeTrackingManager.swift
import Foundation
import RealityKit
import Combine
import os

class EyeTrackingManager: ObservableObject {
    @Published var currentGazeTarget: Entity?
    private let log = Logger(subsystem: "com.infini.view.vision", category: "EyeTrackingManager")
    
    func updateGazeTarget(entity: Entity?) {
        if currentGazeTarget != entity {
            currentGazeTarget = entity
            log.info("Gaze target updated.")
        }
    }
}
