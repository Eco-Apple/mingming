//
//  Commit.swift
//  Mingming
//
//  Created by Jerico Villaraza on 2/15/25.
//

import Foundation
import SwiftData

enum CommitStatus: Codable, Equatable {
    case completed
    case skippedManually
    case forgotten
    case later(Date)
}

@Model
class Commit {
    private(set) var status: CommitStatus
    private(set) var date: Date
    
    private var createdAt: Date
    private var updatedAt: Date
    
    init(date: Date, status: CommitStatus) {
        self.status = status
        self.date = date
        
        self.createdAt = .today
        self.updatedAt = .today
    }
    
    func update(status: CommitStatus, dataService: DataService) {
        self.status = status
        updatedAt = .today
        dataService.save()
    }
}

extension [Commit] {
    func isIn(_ date: Date) -> Bool {
        return self.contains { $0.status == .completed && Calendar.current.isDate($0.date, inSameDayAs: date)}
    }
}

extension CommitStatus {
    var asWidgetCommitStatus: WidgetCommitStatus {
        switch self {
        case .completed:
            return .completed
        case .skippedManually:
            return .skippedManually
        case .forgotten:
            return .forgotten
        case .later(let date):
            return .later(date)
        }
    }
}
