//
//  WidgetHabit.swift
//  Mingming
//
//  Created by Jerico Villaraza on 3/20/25.
//

import Foundation
import SwiftData

struct WidgetHabit: Codable, Identifiable {
    let id: UUID
    let title: String
    let year: WidgetYear
    let schedules: [Date]
    let commits: [WidgetCommit]
    let tags: [WidgetTag]
}

extension WidgetHabit {
    static var example = WidgetHabit(id: UUID(), title: "Sample Habit", year: WidgetYear(id: UUID(), value: Date.today.year), schedules: [.today], commits: [], tags: [WidgetTag(id: UUID(), name: "Tag", habitCount: 0)])
}
