import SwiftUI
import os

struct StatusBarView: View {
    @State private var offset: CGSize = .zero
    @State private var batteryLevel: Int = 100
    @State private var dateTime: String = ""
    private let log = Logger(subsystem: "com.infini.view.vision", category: "StatusBarView")

    var body: some View {
        HStack(spacing: 20) {
            Text(dateTime)
                .font(.footnote)
            Text("Battery: \(batteryLevel)%")
                .font(.footnote)
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
            enableBatteryMonitoring()
            updateDateTime()
            updateBatteryLevel()
        }
        .onReceive(Timer.publish(every: 60, on: .main, in: .common).autoconnect()) { _ in
            updateDateTime()
            updateBatteryLevel()
        }
    }

    private func updateDateTime() {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/dd/yyyy HH:mm"
        dateTime = formatter.string(from: Date())
    }

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
}
