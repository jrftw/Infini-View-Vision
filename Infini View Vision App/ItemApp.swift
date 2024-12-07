//
//  Item.swift used for devices other than vision pro
//  Infini View Vision App
//
//  Created by Kevin Doyle Jr. on 12/7/24.
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}
