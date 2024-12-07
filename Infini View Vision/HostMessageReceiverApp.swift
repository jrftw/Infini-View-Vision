//
//  HostMessageReceiverApp.swift
//  Infini View Vision
//
//  Created by Kevin Doyle Jr. on 12/7/24.
//

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
