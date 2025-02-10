//
//  Item.swift
//  detaile
//
//  Created by Denislav Dimitrov on 10.02.25.
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
