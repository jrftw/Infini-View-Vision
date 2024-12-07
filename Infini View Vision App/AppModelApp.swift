// AppModelApp.swift (Shared non-visionOS)
import SwiftUI
import Combine
import os

@MainActor
class AppModel: ObservableObject {
    enum ImmersiveSpaceState {
        case closed
        case inTransition
        case open
    }
    @Published var immersiveSpaceState = ImmersiveSpaceState.closed

    enum ConnectedDevice: String, CaseIterable {
        case macbook = "MacBook"
    }
    @Published var selectedDevice: ConnectedDevice?
}
