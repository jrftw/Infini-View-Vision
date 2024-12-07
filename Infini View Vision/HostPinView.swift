// HostPinView.swift used for vision pro
import SwiftUI

struct HostPinView: View {
    @EnvironmentObject var pinManager: PinManager
    @EnvironmentObject var hostManager: HostManager

    var body: some View {
        VStack {
            Text("Your PIN")
                .font(.title2)
                .padding(.top, 40)

            if let pin = pinManager.currentPin {
                Text(pin)
                    .font(.system(size: 40, weight: .bold))
                    .padding()
            } else {
                Text("Generating PIN...")
                    .padding()
                    .onAppear {
                        pinManager.generatePin()
                    }
            }

            if hostManager.isHosting {
                if hostManager.isReady {
                    Text("Service: \(hostManager.serviceName) is advertised.")
                } else {
                    Text("Starting host listener...")
                }
            } else {
                Text("Not hosting yet...")
            }

            Spacer()
        }
        .padding()
    }
}
