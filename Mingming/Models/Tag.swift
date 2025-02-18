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
    private(set) var habitCount: Int
    
    var createdAt: Date?
    var updatedAt: Date?
    
    func increaseHabitCount() {
        habitCount += 1
    }
    
    func decreaseHabitCount() {
        habitCount -= 1
    }
    
    init(name: String) {
        self.name = name
        self.habitCount = 1
        
        self.createdAt = .now
        self.updatedAt = .now
    }
}
