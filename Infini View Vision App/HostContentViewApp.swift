//
//  HostContentViewApp.swift used for devices other than vision pro
//  Infini View Vision
//
//  Created by Kevin Doyle Jr. on 12/7/24.
//


// HostContentViewApp.swift (Host UI using RemoteControlHandler)
import SwiftUI

struct HostContentViewApp: View {
    @ObservedObject var remoteHandler: RemoteControlHandler

    var body: some View {
        ScrollView {
            VStack(spacing: 50) {
                ForEach(0..<20, id: \.self) { index in
                    Text("Item \(index)")
                        .font(.title)
                        .foregroundColor(.white)
                }
            }
            .offset(y: -remoteHandler.contentOffset)
            .scaleEffect(remoteHandler.zoomLevel)
        }
        .background(Color.black.ignoresSafeArea())
    }
}
