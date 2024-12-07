//
//  StatusBarView.swift
//  Infini View Vision
//
//  Created by Kevin Doyle Jr. on 12/7/24.
//


import SwiftUI

struct StatusBarView: View {
    @State private var offset: CGSize = .zero
    @State private var batteryLevel: Int = 85 // Placeholder battery level
    @State private var dateTime: String = ""

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
        .onAppear(perform: updateDateTime)
        .onReceive(Timer.publish(every: 60, on: .main, in: .common).autoconnect()) { _ in
            updateDateTime()
        }
    }

    private func updateDateTime() {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/dd/yyyy HH:mm"
        dateTime = formatter.string(from: Date())
    }
}