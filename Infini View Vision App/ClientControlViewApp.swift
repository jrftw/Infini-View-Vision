//
//  ClientControlViewApp.swift
//  Infini View Vision
//
//  Created by Kevin Doyle Jr. on 12/7/24.
//


// ClientControlViewApp.swift (Vision Pro Client)
import SwiftUI

struct ClientControlViewApp: View {
    @EnvironmentObject var connectionManager: ConnectionManager
    @StateObject private var stateReceiver = ClientStateReceiverApp()

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
                ClientMirroredViewApp(stateReceiver: stateReceiver)
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
