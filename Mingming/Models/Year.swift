//
//  Year.swift
//  Mingming
//
//  Created by Jerico Villaraza on 3/9/25.
//

import SwiftData
import SwiftUI

@Model
class Year {
    @Attribute(.unique) var value: Int
    private(set) var habitCount: Int
    
    private(set) var createdAt: Date
    private(set) var updatedAt: Date
    
    var stringValue: String {
        String(value)
    }
    
    func increaseHabitCount() {
        habitCount += 1
    }
    
    func decreaseHabitCount() {
        habitCount -= 1
    }
    
    init(value: Int) {
        self.value = value
        self.habitCount = 1
        
        self.createdAt = .today
        self.updatedAt = .today
    }
}
