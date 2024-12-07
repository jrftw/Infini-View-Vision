//
//  ClientMirroredView.swift
//  Infini View Vision
//
//  Created by Kevin Doyle Jr. on 12/7/24.
//


// On the client side (Vision Pro), we can show a mirrored UI in a ClientMirroredView.
// This view uses the ClientStateReceiver to adjust offset and zoom to match the host’s UI.

import SwiftUI

struct ClientMirroredView: View {
    @ObservedObject var stateReceiver: ClientStateReceiver

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
