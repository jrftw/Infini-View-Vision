// HostMessageReceiverApp.swift used for devices other than vision pro
import Foundation

class HostMessageReceiverApp {
    var remoteHandler: RemoteControlHandler

    init(remoteHandler: RemoteControlHandler) {
        self.remoteHandler = remoteHandler
    }

    func receiveData(_ data: Data) {
        remoteHandler.handleMessage(data)
    }
}
