// HostPinViewApp.swift (Non-visionOS)
import SwiftUI

struct HostPinViewApp: View {
    @EnvironmentObject var pinManagerApp: PinManagerApp
    @EnvironmentObject var hostManagerApp: HostManagerApp

    var body: some View {
        VStack {
            Text("Your PIN")
                .font(.title2)
                .padding(.top, 40)

            if let pin = pinManagerApp.currentPin {
                Text(pin)
                    .font(.system(size: 40, weight: .bold))
                    .padding()
            } else {
                Text("Generating PIN...")
                    .padding()
                    .onAppear {
                        pinManagerApp.generatePin()
                    }
            }

            if hostManagerApp.isHosting {
                if hostManagerApp.isReady {
                    Text("Service: \(hostManagerApp.serviceName) is advertised.")
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
