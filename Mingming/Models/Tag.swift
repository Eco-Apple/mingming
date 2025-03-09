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
    
    private(set) var createdAt: Date
    private(set) var updatedAt: Date
    
    func increaseHabitCount() {
        habitCount += 1
    }
    
    func decreaseHabitCount() {
        habitCount -= 1
    }
    
    init(name: String) {
        self.name = name
        self.habitCount = 1
        
        self.createdAt = .today
        self.updatedAt = .today
    }
}
