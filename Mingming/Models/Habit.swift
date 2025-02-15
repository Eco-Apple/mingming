//
//  Habit.swift
//  Mingming
//
//  Created by Jerico Villaraza on 2/15/25.
//

import Foundation
import SwiftData

@Model
class Habit {
    private(set) var title: String
    @Relationship(deleteRule: .cascade) private(set) var commits: [Commit]
    private(set) var tags: [String]
    
    private(set) var createdAt: Date
    private(set) var updatedAt: Date
    
    init(title: String, tags: [String], commits: [Commit]) {
        self.title = title
        self.commits = commits
        self.tags = tags
        
        self.createdAt = .now
        self.updatedAt = .now
    }
}
