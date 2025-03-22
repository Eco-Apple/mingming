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

extension Habit {
    func generateRandomCommits(dataService: DataService) {
        let calendar = Calendar.current
        let today = Date()
        let startDate = calendar.date(byAdding: .month, value: -3, to: today)!
        
        var currentDate = startDate
        var commitsToAdd: [Commit] = []
        
        while currentDate <= today {
            // 70% chance to have a "streak week"
            if Bool.random(probability: 0.7) {
                // Commit every day for 7 to 14 days
                let streakLength = Int.random(in: 7...14)
                for _ in 0..<streakLength {
                    if currentDate > today { break }
                    commitsToAdd.append(Commit(date: currentDate, status: CommitStatus.random()))
                    currentDate = calendar.date(byAdding: .day, value: 1, to: currentDate)!
                }
            } else {
                // 3 to 7 days without commits
                let skipDays = Int.random(in: 3...7)
                currentDate = calendar.date(byAdding: .day, value: skipDays, to: currentDate)!
            }
        }
        
        // Assign commits
        self.commits.append(contentsOf: commitsToAdd)
        dataService.save()
    }
}

extension Bool {
    /// Probability: 0.0 to 1.0 (e.g. 0.7 = 70% chance of true)
    static func random(probability: Double) -> Bool {
        return Double.random(in: 0...1) < probability
    }
}

extension CommitStatus {
    static func random() -> CommitStatus {
        let random = Int.random(in: 0..<100)
        switch random {
        case 0..<70:
            return .completed // 70% chance
        case 70..<85:
            return .skippedManually
        case 85..<95:
            return .forgotten
        default:
            // Random "later" date within 1 week
            let futureDate = Calendar.current.date(byAdding: .day, value: Int.random(in: 1...7), to: .today)!
            return .later(futureDate)
        }
    }
}
