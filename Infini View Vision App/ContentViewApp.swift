// ContentViewApp.swift (Non-visionOS)
import SwiftUI
import Combine
import os

struct ContentViewApp: View {
    @StateObject private var appModel = AppModel()
    @StateObject private var viewModel = WorkspaceViewModelApp()
    @StateObject private var discoveryManager = DeviceDiscoveryManagerApp()
    @StateObject private var connectionManager = ConnectionManager()
    @StateObject private var pinManagerApp = PinManagerApp()
    @StateObject private var hostManagerApp = HostManagerApp()
    @StateObject private var stateReceiver = ClientStateReceiverApp()

    @State private var showingDeviceSelection = false
    @State private var showingHostPin = false
    @State private var showingDirectConnect = false
    @State private var hostMode = false

    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()

            VStack(spacing: 30) {
                Spacer()
                Text("""
To use this app:
1. If you want to host, turn on "Host Mode" and then show the host PIN.
2. If you want to connect as a client, choose "Connect to a Device (Discovery & PIN)" and select a host.
3. To connect directly by IP and port, use "Direct Connect (Host & Port)".
""")
                .foregroundColor(.white)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 20)

                Button("Connect to a Device (Discovery & PIN)") {
                    showingDeviceSelection = true
                }
                .padding()
                .background(Color.blue.opacity(0.6))
                .cornerRadius(8)
                .foregroundColor(.white)

                Button("Direct Connect (Host & Port)") {
                    showingDirectConnect = true
                }
                .padding()
                .background(Color.orange.opacity(0.6))
                .cornerRadius(8)
                .foregroundColor(.white)

                Toggle("Host Mode", isOn: $hostMode)
                    .padding()
                    .background(Color.white.opacity(0.1))
                    .cornerRadius(8)
                    .foregroundColor(.white)
                    .onChange(of: hostMode) { _, newValue in
                        if newValue {
                            hostManagerApp.startHosting()
                        } else {
                            hostManagerApp.stopHosting()
                        }
                    }

                if hostMode {
                    Button("Show Host PIN") {
                        pinManagerApp.generatePin()
                        showingHostPin = true
                    }
                    .padding()
                    .background(Color.green.opacity(0.6))
                    .cornerRadius(8)
                    .foregroundColor(.white)

                    StatusBarViewApp()
                        .position(x: UIScreen.main.bounds.width / 2, y: 50)
                }

                Spacer()
            }
            .padding(.horizontal, 20)

            if connectionManager.isConnecting {
                VStack {
                    Text("Connecting...")
                        .foregroundColor(.white)
                        .padding()

                    if let err = connectionManager.connectionError {
                        Text("Error: \(err)")
                            .foregroundColor(.red)
                            .padding()
                    }
                    Spacer()
                }
            } else if connectionManager.isConnected {
                ClientMirroredViewApp(stateReceiver: stateReceiver)
                    .onAppear {
                        connectionManager.startReceivingHostState(receiver: stateReceiver)
                    }
            }
        }
        .sheet(isPresented: $showingDeviceSelection) {
            DeviceSelectionViewApp()
                .environmentObject(appModel)
                .environmentObject(discoveryManager)
                .environmentObject(connectionManager)
                .environmentObject(pinManagerApp)
        }
        .sheet(isPresented: $showingHostPin) {
            HostPinViewApp()
                .environmentObject(pinManagerApp)
                .environmentObject(hostManagerApp)
        }
        .sheet(isPresented: $showingDirectConnect) {
            DirectConnectViewApp()
                .environmentObject(connectionManager)
        }
        .environmentObject(appModel)
        .environmentObject(viewModel)
        .environmentObject(discoveryManager)
        .environmentObject(connectionManager)
        .environmentObject(pinManagerApp)
        .environmentObject(hostManagerApp)
    }
}
