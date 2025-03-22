//
//  WidgetHabit.swift
//  Mingming
//
//  Created by Jerico Villaraza on 3/20/25.
//

import Foundation
import SwiftData

struct WidgetHabit: Codable, Identifiable {
    let id: PersistentIdentifier
    let title: String
    let schedules: [Date]
    let commits: [WidgetCommit]
    let tags: [WidgetTag]
}
