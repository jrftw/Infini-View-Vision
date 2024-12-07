//
//  RemoteCommand.swift used for vision pro
//  Infini View Vision
//
//  Created by Kevin Doyle Jr. on 12/7/24.
//


// RemoteControlHandlerApp.swift (Host-only logic)
import Foundation
import Combine
import RealityKit
import os

enum RemoteCommand: String, Codable {
    case scrollDown
    case zoom
}

struct RemoteMessage: Codable {
    let action: RemoteCommand
    let value: Double?
}
