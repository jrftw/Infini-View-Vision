//workspaceViewModel.swift - used for vision pro

import Foundation
import RealityKit
import Combine
import SwiftUI
import os

class WorkspaceViewModel: ObservableObject {
    @Published var screens: [Entity] = []
    @Published var focusedScreen: Entity?
    @Published var currentScale: CGFloat = 1.0

    private let log = Logger(subsystem: "com.infini.view.vision", category: "WorkspaceViewModel")
    private var cancellables = Set<AnyCancellable>()

    private let handTracking = HandTrackingManager()
    private let eyeTracking = EyeTrackingManager()
    private var currentDragOffset: CGSize = .zero

    func setupScreens(in anchor: AnchorEntity, count: Int) {
        for i in 0..<count {
            let screen = createScreenEntity()
            screen.transform.translation = SIMD3<Float>(Float(i)*0.6 - 1.2, 0, 0)
            anchor.addChild(screen)
            screens.append(screen)
        }
        log.info("Screens setup completed for device.")
    }

    private func createScreenEntity() -> ModelEntity {
        let mesh = MeshResource.generatePlane(width: 0.5, height: 0.3)
        let material = SimpleMaterial(color: .gray, roughness: 0.5, isMetallic: false)
        let model = ModelEntity(mesh: mesh, materials: [material])
        model.generateCollisionShapes(recursive: true)
        return model
    }

    func startManagers() {
        eyeTracking.$currentGazeTarget
            .receive(on: RunLoop.main)
            .sink { [weak self] target in
                self?.focusedScreen = target
            }
            .store(in: &cancellables)

        handTracking.$currentTransform
            .receive(on: RunLoop.main)
            .sink { [weak self] transform in
                guard let self = self, let focused = self.focusedScreen, let transform = transform else { return }
                focused.transform = transform
            }
            .store(in: &cancellables)

        log.info("Managers started.")
    }

    func handleGazeRaycastHit(hitEntity: Entity?) {
        if let entity = hitEntity, screens.contains(entity) {
            eyeTracking.updateGazeTarget(entity: entity)
        } else {
            eyeTracking.updateGazeTarget(entity: nil)
        }
    }

    func handleFocusChange(target: Entity?) {
        for screen in screens {
            if let model = screen as? ModelEntity {
                if screen == target {
                    model.model?.materials = [SimpleMaterial(color: .blue, roughness: 0.5, isMetallic: false)]
                } else {
                    model.model?.materials = [SimpleMaterial(color: .gray, roughness: 0.5, isMetallic: false)]
                }
            }
        }
        log.info("Focus changed.")
    }

    func handleHandDragChange(translation: CGSize) {
        guard let focused = focusedScreen else { return }
        currentDragOffset = translation
        let newX = Float(translation.width * 0.001)
        let newY = Float(-translation.height * 0.001)
        var t = focused.transform
        t.translation += SIMD3<Float>(newX, newY, 0)
        focused.transform = t
        log.info("Dragging focused screen.")
    }

    func handleHandDragEnd() {
        currentDragOffset = .zero
        log.info("Drag ended.")
    }

    func handleMagnificationChange(scale: CGFloat) {
        currentScale = scale
        guard let focused = focusedScreen else { return }
        var t = focused.transform
        t.scale = SIMD3<Float>(Float(scale), Float(scale), 1)
        focused.transform = t
        log.info("Magnifying focused screen.")
    }

    func handleMagnificationEnd() {
        guard let focused = focusedScreen else { return }
        var t = focused.transform
        t.scale = SIMD3<Float>(Float(currentScale), Float(currentScale), 1)
        focused.transform = t
        currentScale = 1.0
        log.info("Magnification ended.")
    }
}
