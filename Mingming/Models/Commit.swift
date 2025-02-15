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
    var date: Date
    
    init(date: Date) {
        self.date = date
    }
}
