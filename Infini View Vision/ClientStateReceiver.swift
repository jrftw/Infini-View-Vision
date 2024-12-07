//
//  ClientStateReceiver.swift
//  Infini View Vision
//
//  Created by Kevin Doyle Jr. on 12/7/24.
//


// On the client side (Vision Pro), we now must receive host state updates and mirror the UI.
// We'll assume the client also sets up a receiver. The ConnectionManager on the client side
// will receive host states (HostUIStateMessage) and update the client UI accordingly.

import Foundation
import Combine
import os

final class ClientStateReceiver: ObservableObject {
    @Published var hostOffset: Double = 0.0
    @Published var hostZoom: Double = 1.0
    private let log = Logger(subsystem: "com.infini.view.vision", category: "ClientStateReceiver")

    func receiveData(_ data: Data) {
        if let state = try? JSONDecoder().decode(HostUIStateMessage.self, from: data) {
            hostOffset = state.offset
            hostZoom = state.zoom
            log.info("Client mirrored host offset: \(state.offset), zoom: \(state.zoom)")
        }
    }
}
