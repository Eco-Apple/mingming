//
//  WidgetTag.swift
//  Mingming
//
//  Created by Jerico Villaraza on 3/20/25.
//

import Foundation
import SwiftData

struct WidgetTag: Codable, Identifiable {
    let id: UUID
    let name: String
    let habitCount: Int
}
