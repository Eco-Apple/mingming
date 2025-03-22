//
//  WidgetTag.swift
//  Mingming
//
//  Created by Jerico Villaraza on 3/20/25.
//

import Foundation
import SwiftData

struct WidgetTag: Codable, Identifiable {
    let id: PersistentIdentifier
    let name: String
    let habitCount: Int
}
