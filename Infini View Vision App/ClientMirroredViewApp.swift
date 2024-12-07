//
//  ClientMirroredViewApp.swift
//  Infini View Vision
//
//  Created by Kevin Doyle Jr. on 12/7/24.
//


import SwiftUI

struct ClientMirroredViewApp: View {
    @ObservedObject var stateReceiver: ClientStateReceiverApp

    var body: some View {
        ScrollView {
            VStack(spacing: 50) {
                ForEach(0..<20, id: \.self) { index in
                    Text("Item \(index)")
                        .font(.title)
                        .foregroundColor(.white)
                }
            }
            .offset(y: -stateReceiver.hostOffset)
            .scaleEffect(stateReceiver.hostZoom)
        }
        .background(Color.black.ignoresSafeArea())
    }
}