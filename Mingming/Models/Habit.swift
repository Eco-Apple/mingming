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
    @Relationship(deleteRule: .cascade) private(set) var commits: [Commit]
    
    private(set) var tags: [Tag]
    private(set) var year: Year?
    private(set) var schedules: [Date]
    
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
        
        self.schedules = schedules
        self.tags = tags
        self.commits = commits
        
        self.createdAt = .today
        self.updatedAt = .today
        self.listOrder = 0
    }
    
    func add(commit: Commit, dataService: DataService) {
        commits.append(commit)
        dataService.save()
    }
    
    func set(tags: [Tag], dataService: DataService) {
        self.tags = tags
        dataService.save()
    }
    
    func set(year: Year, dataService: DataService) {
        self.year = year
        dataService.save()
    }
    
    static func == (lhs: Habit, rhs: Habit) -> Bool {
        lhs.id == rhs.id
    }
}

extension Habit {
    static var example = Habit(title: "Drink water", schedules: [.today], tags: [Tag(name: "Exercise")], commits: [])
}
