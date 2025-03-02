//
//  Date.swift
//  Mingming
//
//  Created by Jerico Villaraza on 2/8/25.
//

import Foundation

extension Date {
    
    var tomorrow: Date {
        return Calendar.current.date(byAdding: .day, value: 1, to: self) ?? self
    }
    
    func formatTime() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "h:mma"
        formatter.amSymbol = "AM"
        formatter.pmSymbol = "PM"
        return formatter.string(from: self)
    }
    
    func isIn(_ commits: [Commit], sameDay: Bool = true) -> Bool {
        if sameDay {
            return commits.contains { Calendar.current.isDate($0.date, inSameDayAs: self)}
        } else {
            return commits.contains { $0.date == self }
        }
    }
}
