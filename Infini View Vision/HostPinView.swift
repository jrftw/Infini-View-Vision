//
//  HostPinView.swift
//  Infini View Vision
//
//  Created by Kevin Doyle Jr. on 12/7/24.
//


import SwiftUI

struct HostPinView: View {
    @EnvironmentObject var pinManager: PinManager

    var body: some View {
        VStack {
            Text("Your PIN")
                .font(.title2)
                .padding(.top, 40)

            if let pin = pinManager.currentPin {
                Text(pin)
                    .font(.system(size: 40, weight: .bold))
                    .padding()
            } else {
                Text("Generating PIN...")
                    .padding()
                    .onAppear {
                        pinManager.generatePin()
                    }
            }

            Spacer()
        }
        .padding()
    }
}