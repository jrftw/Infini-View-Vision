// ImmersiveView.swift used for vision pro
import SwiftUI

#if os(visionOS)
import RealityKit

struct ImmersiveView: View {
    let makeClosure: (RealityViewContent) async -> Void

    init(content: @escaping (RealityViewContent) async -> Void) {
        self.makeClosure = content
    }

    var body: some View {
        RealityView { content in
            await makeClosure(content)
        }
    }
}
#else
struct ImmersiveViewApp: View {
    var body: some View {
        Text("ImmersiveView not available on this platform.")
            .padding()
            .foregroundColor(.white)
            .background(Color.gray.opacity(0.6))
            .cornerRadius(10)
    }
}
#endif
