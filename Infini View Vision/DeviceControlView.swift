//DeviceControlView.swift - used for vision pro

import SwiftUI
import RealityKit
import Combine
import os

struct DeviceControlView: View {
    @EnvironmentObject var appModel: AppModel
    @EnvironmentObject var connectionManager: ConnectionManager
    @EnvironmentObject var viewModel: WorkspaceViewModel

    var body: some View {
        ImmersiveView(content: { content in
            if content.entities.isEmpty, appModel.selectedDevice != nil, connectionManager.isConnected {
                let anchor = AnchorEntity(world: [0,0,-1.5])
                content.add(anchor)
                if let entity = try? await Entity(named: "Immersive", in: Bundle.main) {
                    content.add(entity)
                }
                viewModel.setupScreens(in: anchor, count: 5)
            }
        })
        .ignoresSafeArea()
        .overlay(
            VStack {
                HStack {
                    if let device = appModel.selectedDevice {
                        Text("Controlling: \(device.rawValue)")
                            .padding()
                            .background(Color.black.opacity(0.6))
                            .cornerRadius(8)
                            .foregroundColor(.white)
                    }

                    Button("Disconnect") {
                        connectionManager.disconnect()
                        appModel.selectedDevice = nil
                    }
                    .padding()
                    .background(Color.red.opacity(0.6))
                    .cornerRadius(8)
                    .foregroundColor(.white)

                    Spacer()
                }
                .padding()
                Spacer()
            }
        )
        .gesture(
            DragGesture(minimumDistance: 0)
                .onChanged { gesture in
                    viewModel.handleHandDragChange(translation: gesture.translation)
                }
                .onEnded { _ in
                    viewModel.handleHandDragEnd()
                }
        )
        .gesture(
            MagnificationGesture()
                .onChanged { scale in
                    viewModel.handleMagnificationChange(scale: scale)
                }
                .onEnded { _ in
                    viewModel.handleMagnificationEnd()
                }
        )
        .focusable(true)
        .onChange(of: viewModel.focusedScreen) { _, newValue in
            viewModel.handleFocusChange(target: newValue)
        }
        .onAppear {
            viewModel.startManagers()
        }
    }
}
