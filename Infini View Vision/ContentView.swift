//ContentView.swift - used for vision pro

import SwiftUI
import RealityKit
import Combine
import os

struct ContentView: View {
    @StateObject private var appModel = AppModel()
    @StateObject private var viewModel = WorkspaceViewModel()
    @StateObject private var discoveryManager = DeviceDiscoveryManager()
    @StateObject private var connectionManager = ConnectionManager()
    @StateObject private var pinManager = PinManager()
    @StateObject private var hostManager = HostManager()

    @State private var showingDeviceSelection = false
    @State private var showingHostPin = false
    @State private var showingDirectConnect = false
    @State private var hostMode = false

    var body: some View {
        ZStack {
            if let device = appModel.selectedDevice, connectionManager.isConnected {
                DeviceControlView()
                    .environmentObject(viewModel)
                    .environmentObject(connectionManager)
                    .environmentObject(appModel)
            } else {
                VStack(spacing: 20) {
                    Toggle("Host Mode", isOn: $hostMode)
                        .padding()
                        .onChange(of: hostMode) { _, newValue in
                            if newValue {
                                hostManager.startHosting()
                            } else {
                                hostManager.stopHosting()
                            }
                        }

                    if hostMode {
                        Button {
                            pinManager.generatePin()
                            showingHostPin = true
                        } label: {
                            Text("Show Host PIN")
                                .padding()
                                .background(Color.green.opacity(0.6))
                                .cornerRadius(8)
                                .foregroundColor(.white)
                        }
                    } else {
                        Button {
                            showingDeviceSelection = true
                        } label: {
                            Text("Connect to a Device (Discovery & PIN)")
                                .padding()
                                .background(Color.blue.opacity(0.6))
                                .cornerRadius(8)
                                .foregroundColor(.white)
                        }

                        Button {
                            showingDirectConnect = true
                        } label: {
                            Text("Direct Connect (Host & Port)")
                                .padding()
                                .background(Color.orange.opacity(0.6))
                                .cornerRadius(8)
                                .foregroundColor(.white)
                        }
                    }

                    Spacer()
                }
            }

            StatusBarView()
        }
        .sheet(isPresented: $showingDeviceSelection) {
            DeviceSelectionView()
                .environmentObject(appModel)
                .environmentObject(discoveryManager)
                .environmentObject(connectionManager)
                .environmentObject(pinManager)
        }
        .sheet(isPresented: $showingHostPin) {
            HostPinView()
                .environmentObject(pinManager)
                .environmentObject(hostManager)
        }
        .sheet(isPresented: $showingDirectConnect) {
            DirectConnectView()
                .environmentObject(connectionManager)
        }
        .environmentObject(appModel)
        .environmentObject(viewModel)
        .environmentObject(discoveryManager)
        .environmentObject(connectionManager)
        .environmentObject(pinManager)
        .environmentObject(hostManager)
    }
}
