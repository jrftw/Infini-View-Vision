// ClientControlView.swift (Vision Pro Client)
import SwiftUI

struct ClientControlView: View {
    @EnvironmentObject var connectionManager: ConnectionManager
    @StateObject private var stateReceiver = ClientStateReceiver()

    var body: some View {
        ZStack {
            if connectionManager.isConnecting {
                Color.black.ignoresSafeArea()
                VStack {
                    Text("Connecting...")
                        .foregroundColor(.white)
                        .padding()
                    if let error = connectionManager.connectionError {
                        Text("Error: \(error)")
                            .foregroundColor(.red)
                            .padding()
                    }
                    Spacer()
                }
            } else if connectionManager.isConnected {
                ClientMirroredView(stateReceiver: stateReceiver)
                    .ignoresSafeArea()
                    .onAppear {
                        connectionManager.startReceivingHostState(receiver: stateReceiver)
                    }

                VStack {
                    Spacer()
                    HStack(spacing: 20) {
                        Button("Scroll Down") {
                            connectionManager.sendRemoteCommand(.scrollDown)
                        }
                        .padding()
                        .background(Color.blue.opacity(0.6))
                        .cornerRadius(8)
                        .foregroundColor(.white)

                        Button("Zoom to 2.0x") {
                            connectionManager.sendRemoteCommand(.zoom, value: 2.0)
                        }
                        .padding()
                        .background(Color.orange.opacity(0.6))
                        .cornerRadius(8)
                        .foregroundColor(.white)
                    }
                    .padding(.bottom, 40)
                }
            } else {
                Color.black.ignoresSafeArea()
                VStack {
                    Text("Not connected.")
                        .foregroundColor(.white)
                        .padding()
                    Spacer()
                }
            }
        }
    }
}
