//
//  WidgetCommit.swift
//  Mingming
//
//  Created by Jerico Villaraza on 3/20/25.
//

import Foundation
import SwiftData

enum WidgetCommitStatus: Codable, Equatable {
    case completed
    case skippedManually
    case forgotten
    case later(Date)
}

struct WidgetCommit: Codable, Identifiable {
    let id: PersistentIdentifier
    let date: Date
    let status: WidgetCommitStatus
}

extension [WidgetCommit] {
    func isIn(_ date: Date) -> Bool {
        return self.contains { $0.status == .completed && Calendar.current.isDate($0.date, inSameDayAs: date)}
    }
}
