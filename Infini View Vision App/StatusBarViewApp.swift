// StatusBarViewApp.swift (Non-visionOS)
// This example uses UIDevice’s battery monitoring for iOS and visionOS.
// On macOS, battery APIs are not directly available without private APIs.
// For macOS, we will omit battery level or provide a placeholder.
// Always ensure battery monitoring is enabled only where supported.

import SwiftUI
import os

struct StatusBarViewApp: View {
    @State private var offset: CGSize = .zero
    @State private var batteryLevel: Int = 100
    @State private var dateTime: String = ""
    private let log = Logger(subsystem: "com.infini.view.vision", category: "StatusBarViewApp")

    var body: some View {
        HStack(spacing: 20) {
            Text(dateTime)
                .font(.footnote)
            #if os(iOS) || os(visionOS)
            Text("Battery: \(batteryLevel)%")
                .font(.footnote)
            #else
            Text("Battery: N/A")
                .font(.footnote)
            #endif
        }
        .padding(8)
        .background(Color.black.opacity(0.8))
        .cornerRadius(10)
        .foregroundColor(.white)
        .offset(offset)
        .gesture(
            DragGesture()
                .onChanged { gesture in
                    offset = gesture.translation
                }
        )
        .onAppear {
            updateDateTime()
            #if os(iOS) || os(visionOS)
            enableBatteryMonitoring()
            updateBatteryLevel()
            #endif
        }
        .onReceive(Timer.publish(every: 60, on: .main, in: .common).autoconnect()) { _ in
            updateDateTime()
            #if os(iOS) || os(visionOS)
            updateBatteryLevel()
            #endif
        }
    }

    private func updateDateTime() {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/dd/yyyy HH:mm"
        dateTime = formatter.string(from: Date())
    }

    #if os(iOS) || os(visionOS)
    private func enableBatteryMonitoring() {
        UIDevice.current.isBatteryMonitoringEnabled = true
    }

    private func updateBatteryLevel() {
        let level = UIDevice.current.batteryLevel
        if level < 0.0 {
            log.debug("Battery level unavailable.")
            batteryLevel = 100
        } else {
            batteryLevel = Int(level * 100)
        }
    }
    #endif
}
