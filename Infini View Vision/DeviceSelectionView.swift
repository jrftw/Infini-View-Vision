// DeviceSelectionView.swift
import SwiftUI
import Network

struct DeviceSelectionView: View {
    @EnvironmentObject var appModel: AppModel
    @EnvironmentObject var discoveryManager: DeviceDiscoveryManager
    @EnvironmentObject var connectionManager: ConnectionManager
    @EnvironmentObject var pinManager: PinManager

    @State private var selectedResult: NWBrowser.Result?
    @State private var showConnectingAlert = false
    @State private var showPinEntry = false
    @State private var enteredPin = ""

    var body: some View {
        VStack {
            Text("Connect to a Device")
                .font(.title2)
                .padding()

            if discoveryManager.isSearching {
                ProgressView("Searching for devices...")
                    .padding()
            } else {
                if discoveryManager.discoveredDevices.isEmpty {
                    Text("No devices found.")
                        .padding()
                } else {
                    ForEach(discoveryManager.discoveredDevices, id: \.self) { result in
                        Button(action: {
                            selectedResult = result
                            showPinEntry = true
                        }) {
                            Text(deviceName(for: result))
                                .padding()
                                .background(Color.blue.opacity(0.6))
                                .cornerRadius(8)
                                .foregroundColor(.white)
                        }
                    }
                }
            }

            Button(action: {
                discoveryManager.startDiscovery(serviceType: "_myapp._tcp")
            }) {
                Text("Refresh")
                    .padding()
                    .background(Color.blue.opacity(0.6))
                    .cornerRadius(8)
                    .foregroundColor(.white)
            }

            Spacer()
        }
        .onAppear {
            discoveryManager.startDiscovery(serviceType: "_myapp._tcp")
        }
        .sheet(isPresented: $showPinEntry) {
            VStack {
                Text("Enter PIN from host device")
                    .font(.title2)
                    .padding()

                TextField("PIN", text: $enteredPin)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .keyboardType(.numberPad)
                    .padding()

                Button(action: {
                    if pinManager.verifyPin(enteredPin) {
                        guard let result = selectedResult else { return }
                        // Call directly on connectionManager, no `$` prefix
                        connectionManager.connectToDevice(result: result)
                        showPinEntry = false
                    } else {
                        connectionManager.connectionError = "Incorrect PIN."
                        showPinEntry = false
                        showConnectingAlert = true
                    }
                }) {
                    Text("Connect")
                        .padding()
                        .background(Color.blue.opacity(0.6))
                        .cornerRadius(8)
                        .foregroundColor(.white)
                }

                Spacer()
            }
            .padding()
        }
        .alert(isPresented: $showConnectingAlert) {
            if connectionManager.isConnecting {
                Alert(title: Text("Connecting..."), message: Text("Attempting to connect..."), dismissButton: .default(Text("OK")))
            } else if let error = connectionManager.connectionError {
                Alert(title: Text("Connection Failed"), message: Text(error), dismissButton: .default(Text("OK")))
            } else if connectionManager.isConnected {
                Alert(title: Text("Connected"), message: Text("Successfully connected."), dismissButton: .default(Text("OK")))
            } else {
                Alert(title: Text("Unknown State"), message: Text("Unable to determine connection state"), dismissButton: .default(Text("OK")))
            }
        }
        .onChange(of: connectionManager.isConnecting) { _, newValue in
            if newValue {
                showConnectingAlert = true
            }
        }
        .onChange(of: connectionManager.isConnected) { _, newValue in
            if newValue {
                showConnectingAlert = true
                appModel.selectedDevice = .macbook
            }
        }
        .onChange(of: connectionManager.connectionError) { _, newValue in
            if newValue != nil {
                showConnectingAlert = true
            }
        }
    }

    private func deviceName(for result: NWBrowser.Result) -> String {
        if case let NWEndpoint.service(name: name, type: _, domain: _, interface: _) = result.endpoint {
            return name
        }
        return "Unknown Device"
    }
}
