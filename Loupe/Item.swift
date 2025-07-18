//
//  Item.swift
//  Loupe
//
//  Created by Jill Allan on 18/07/2025.
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
