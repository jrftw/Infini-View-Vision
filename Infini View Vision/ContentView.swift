// ContentView.swift
import SwiftUI
import RealityKit
import Combine
import os

struct ContentView: View {
    @EnvironmentObject var appModel: AppModel
    @StateObject private var viewModel = WorkspaceViewModel()
    @StateObject private var discoveryManager = DeviceDiscoveryManager()
    @StateObject private var connectionManager = ConnectionManager()
    @StateObject private var pinManager = PinManager()

    @State private var showingDeviceSelection = false
    @State private var showingHostPin = false
    @State private var showingDirectConnect = false

    var body: some View {
        ZStack {
            if appModel.selectedDevice != nil && connectionManager.isConnected {
                DeviceControlView()
                    .environmentObject(viewModel)
                    .environmentObject(connectionManager)
                    .environmentObject(appModel)
            } else {
                VStack(spacing: 20) {
                    Button(action: {
                        showingDeviceSelection = true
                    }) {
                        Text("Connect to a Device (Discovery & PIN)")
                            .padding()
                            .background(Color.blue.opacity(0.6))
                            .cornerRadius(8)
                            .foregroundColor(.white)
                    }

                    Button(action: {
                        pinManager.generatePin()
                        showingHostPin = true
                    }) {
                        Text("Show Host PIN")
                            .padding()
                            .background(Color.green.opacity(0.6))
                            .cornerRadius(8)
                            .foregroundColor(.white)
                    }

                    Button(action: {
                        showingDirectConnect = true
                    }) {
                        Text("Direct Connect (Host & Port)")
                            .padding()
                            .background(Color.orange.opacity(0.6))
                            .cornerRadius(8)
                            .foregroundColor(.white)
                    }
                }
            }

            // Status Bar overlaid on top
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
        }
        .sheet(isPresented: $showingDirectConnect) {
            DirectConnectView()
                .environmentObject(connectionManager)
        }
    }
}
