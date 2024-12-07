// ImmersiveView.swift
import SwiftUI
import RealityKit
import os

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
