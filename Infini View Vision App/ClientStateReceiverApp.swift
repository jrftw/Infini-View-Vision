//
//  ClientStateReceiverApp.swift
//  Infini View Vision
//
//  Created by Kevin Doyle Jr. on 12/7/24.
//


import Foundation
import Combine
import os

final class ClientStateReceiverApp: ObservableObject {
    @Published var hostOffset: Double = 0.0
    @Published var hostZoom: Double = 1.0
    private let log = Logger(subsystem: "com.infini.view.vision", category: "ClientStateReceiverApp")

    func receiveData(_ data: Data) {
        if let state = try? JSONDecoder().decode(HostUIStateMessage.self, from: data) {
            hostOffset = state.offset
            hostZoom = state.zoom
            log.info("Client mirrored host offset: \(state.offset), zoom: \(state.zoom)")
        }
    }
}