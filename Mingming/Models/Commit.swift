//
//  Commit.swift
//  Mingming
//
//  Created by Jerico Villaraza on 2/15/25.
//

import Foundation
import SwiftData

@Model
class Commit {
    private(set) var status: CommitStatus
    private(set) var date: Date
    
    private var createdAt: Date
    private var updatedAt: Date
    
    func update(status: CommitStatus) {
        self.status = status
        updatedAt = .today
    }
    
    init(date: Date, status: CommitStatus) {
        self.status = status
        self.date = date
        
        self.createdAt = .today
        self.updatedAt = .today
    }
}

enum CommitStatus: Codable, Equatable {
    case completed
    case skippedManually
    case forgotten
    case later(Date)
}
