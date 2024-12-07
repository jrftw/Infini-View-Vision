// ImmersiveViewApp.swift used for devices other than vision pro
import SwiftUI

struct ImmersiveViewApp: View {
    var body: some View {
        Text("ImmersiveView not available on this platform.")
            .padding()
            .foregroundColor(.white)
            .background(Color.gray.opacity(0.6))
            .cornerRadius(10)
    }
}
