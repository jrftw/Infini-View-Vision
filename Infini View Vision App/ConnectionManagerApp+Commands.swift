//
//  ConnectionManagerApp+Commands.swift
//  Infini View Vision
//
//  Created by Kevin Doyle Jr. on 12/7/24.
//

import Foundation

extension ConnectionManager {
    func sendRemoteCommand(_ action: RemoteCommand, value: Double? = nil) {
        let message = RemoteMessage(action: action, value: value)
        guard let data = try? JSONEncoder().encode(message) else { return }
        sendCommandMessage(data)
    }
}
