import SwiftUI
import os

@main
struct InfiniViewVision: App {
    @StateObject private var appModel = AppModel()
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(appModel)
                .ignoresSafeArea()
        }
    }
}
