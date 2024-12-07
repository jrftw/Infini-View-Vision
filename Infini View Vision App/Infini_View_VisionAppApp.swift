// Modifications to InfiniViewVisionAppApp.swift and InfiniViewVisionApp.swift
// On Vision Pro, use ContentView (original) that references ImmersiveView and ClientControlViewApp.
// On Non-Vision devices, use ContentViewApp and associated *App files.
import SwiftUI
import os

@main
struct InfiniViewVisionAppApp: App {
    @StateObject private var appModel = AppModel()
    var body: some Scene {
        WindowGroup {
            ContentViewApp()
                .environmentObject(appModel)
                .ignoresSafeArea()
        }
    }
}

