// DeviceControlViewApp.swift used for devices other than vision pro
import SwiftUI
import RealityKit
import Combine
import os

struct DeviceControlView: View {
    @EnvironmentObject var appModel: AppModel
    @EnvironmentObject var connectionManager: ConnectionManager
    @EnvironmentObject var viewModel: WorkspaceViewModelApp

    var body: some View {
        ZStack {
#if os(visionOS)
            ImmersiveView(content: { content in
                if content.entities.isEmpty, appModel.selectedDevice != nil, connectionManager.isConnected {
                    let anchor = AnchorEntity()
                    anchor.transform.translation = SIMD3<Float>(0,0,-1.5)
                    content.add(anchor)
                    if let entity = try? await Entity.load(named: "Immersive") {
                        content.add(entity)
                    }
                    viewModel.setupScreens(in: anchor, count: 5)
                }
            })
            .ignoresSafeArea()
#else
            Color.black.ignoresSafeArea()
            if appModel.selectedDevice != nil && connectionManager.isConnected {
                VStack(spacing: 20) {
                    Text("Connected to \(appModel.selectedDevice?.rawValue ?? "Device")")
                        .foregroundColor(.white)
                        .padding()
                    Text("Controlling the device screens now.")
                        .foregroundColor(.white)
                        .padding()
                    Spacer()
                }
            } else {
                VStack {
                    Text("No connected device.")
                        .foregroundColor(.white)
                        .padding()
                    Spacer()
                }
            }
#endif
            VStack {
                HStack {
                    if let deviceSelection = appModel.selectedDevice {
                        Text("Controlling: \(deviceSelection.rawValue)")
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
        }
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
