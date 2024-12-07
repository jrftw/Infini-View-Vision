// InfiniViewVisionApp.swift
import SwiftUI
import os

@main
struct InfiniViewVisionApp: App {
    @StateObject private var appModel = AppModel()
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(appModel)
                .ignoresSafeArea()
        }
    }
}
