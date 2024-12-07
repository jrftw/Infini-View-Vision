// DirectConnectView.swift used for vision pro
import SwiftUI

struct DirectConnectView: View {
    @EnvironmentObject var connectionManager: ConnectionManager
    @State private var host: String = ""
    @State private var port: String = ""
    @State private var showAlert = false

    var body: some View {
        VStack(spacing: 20) {
            Text("Direct Connect")
                .font(.title2)
                .padding(.top, 40)

            TextField("Host (e.g. 192.168.1.100)", text: $host)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.horizontal)

            TextField("Port (e.g. 12345)", text: $port)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .keyboardType(.numberPad)
                .padding(.horizontal)

            Button {
                guard let portNum = UInt16(port) else {
                    showAlert = true
                    return
                }
                connectionManager.connectToHost(host, port: portNum)
            } label: {
                Text("Connect")
                    .padding()
                    .background(Color.blue.opacity(0.7))
                    .cornerRadius(8)
                    .foregroundColor(.white)
            }

            if connectionManager.isConnecting {
                ProgressView("Connecting...")
                    .padding()
            }

            Spacer()
        }
        .alert(isPresented: $showAlert) {
            Alert(title: Text("Invalid Input"), message: Text("Please enter a valid host and port."), dismissButton: .default(Text("OK")))
        }
        .onChange(of: connectionManager.connectionError) { _, newValue in
            if newValue != nil {
                showAlert = true
            }
        }
    }
}
