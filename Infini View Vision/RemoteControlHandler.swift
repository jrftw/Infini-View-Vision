//
//  RemoteControlHandler.swift
//  Infini View Vision
//
//  Created by Kevin Doyle Jr. on 12/7/24.
//


import Foundation
import Combine
import RealityKit
import os

final class RemoteControlHandler: ObservableObject {
    @Published var contentOffset: Double = 0.0
    @Published var zoomLevel: Double = 1.0

    func handleMessage(_ data: Data) {
        guard let message = try? JSONDecoder().decode(RemoteMessage.self, from: data) else { return }
        switch message.action {
        case .scrollDown:
            contentOffset += 50.0
        case .zoom:
            if let val = message.value {
                zoomLevel = val
            }
        }
    }
}