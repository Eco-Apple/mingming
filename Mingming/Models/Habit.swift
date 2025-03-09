//
//  Habit.swift
//  Mingming
//
//  Created by Jerico Villaraza on 2/15/25.
//

import Foundation
import SwiftData

@Model
class Habit: Equatable {
    private(set) var title: String
    @Relationship(deleteRule: .cascade) var commits: [Commit]
    
    var tags: [Tag]
    var year: Year
    var schedules: [Date]
    
    private(set) var createdAt: Date
    private(set) var updatedAt: Date
    
    var listOrder: Int
    
    var combineTags: String {
        tags.map(\.self).map{"#\($0.name)"}.joined(separator: ", ")
    }
    
    var schedule: Date {
        schedules.first!
    }
    
    init(title: String, schedules: [Date], tags: [Tag], commits: [Commit]) {
        self.title = title
        self.commits = commits
        self.tags = tags
        self.schedules = schedules
        
        self.createdAt = .today
        self.updatedAt = .today
        self.listOrder = 0
        
        self.year = Year(value: Date.today.year)
    }
    
    static func == (lhs: Habit, rhs: Habit) -> Bool {
        lhs.id == rhs.id
    }
}

extension Habit {
    static var example = Habit(title: "Drink water", schedules: [.today], tags: [Tag(name: "Exercise")], commits: [])
}
