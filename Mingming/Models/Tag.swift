//
//  Tag.swift
//  Mingming
//
//  Created by Jerico Villaraza on 2/16/25.
//

import Foundation
import SwiftData

@Model
class Tag {
    @Attribute(.unique) var name: String
    
    var createdAt: Date?
    var updatedAt: Date?
    
    init(name: String) {
        self.name = name
        
        self.createdAt = .now
        self.updatedAt = .now
    }
}
