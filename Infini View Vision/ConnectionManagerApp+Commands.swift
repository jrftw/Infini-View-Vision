// ConnectionManagerApp+Commands.swift (Client sending commands) used for vision pro
import Foundation

extension ConnectionManager {
    func sendRemoteCommand(_ action: RemoteCommand, value: Double? = nil) {
        let message = RemoteMessage(action: action, value: value)
        guard let data = try? JSONEncoder().encode(message) else { return }
        sendCommandMessage(data)
    }
}
