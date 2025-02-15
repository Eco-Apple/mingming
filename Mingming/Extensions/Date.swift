//
//  Date.swift
//  Mingming
//
//  Created by Jerico Villaraza on 2/8/25.
//

import Foundation

extension Date {
    func formatTime() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "h:mma"
        formatter.amSymbol = "AM"
        formatter.pmSymbol = "PM"
        return formatter.string(from: self)
    }
    
    static func weekAndDaysInAYear(year: Int, startMonth: Int = 1) -> [[[Date]]] {
        var result: [[[Date]]] = []
        var savePreviousLastWeek: [Date] = []
        
        for month in startMonth...12 {
            var weeks = weekAndDaysInMonth(year: year, month: month)
            
            if weeks.first! == savePreviousLastWeek {
                weeks.removeFirst()
            }
            
            result.append(weeks)
            savePreviousLastWeek = weeks.last!
        }
        
        
        for month in startMonth...8 {
            var weeks = weekAndDaysInMonth(year: year + 1, month: month)
            
            if weeks.first! == savePreviousLastWeek {
                weeks.removeFirst()
            }
            
            result.append(weeks)
            savePreviousLastWeek = weeks.last!
        }
        
        return result
    }
    
    static func weekAndDaysInMonth(year: Int, month: Int) -> [[Date]]{
        let calendar = Calendar.current
        
        guard let firstDayOfMonth = calendar.date(from: DateComponents(year: year, month: month)), let range = calendar.range(of: .day, in: .month, for: firstDayOfMonth) else {
            return []
        }
        
        var result: [[Date]] = []
        var currentWeek: [Date] = []
        
        for day in range {
            let date = calendar.date(from: DateComponents(year: year, month: month, day: day))!
            let weekday = calendar.component(.weekday, from: date)
            
            if currentWeek.isEmpty {
                let prevMonthDays = weekday - 1
                if prevMonthDays > 0 {
                    for i in stride(from: prevMonthDays, to: 0, by: -1) {
                        if let prevDate = calendar.date(byAdding: .day, value: -i, to: date) {
                            currentWeek.append(prevDate)
                        }
                    }
                }
            }
            
            currentWeek.append(date)
            
            if currentWeek.count == 7 {
                result.append(currentWeek)
                currentWeek = []
            }
        }
        
        if !currentWeek.isEmpty {
            let remainingDays = 7 - currentWeek.count
            if let lastDate = currentWeek.last {
                for i in 1...remainingDays {
                    if let nextDate = calendar.date(byAdding: .day, value: i, to: lastDate) {
                        currentWeek.append(nextDate)
                    }
                }
            }
            result.append(currentWeek)
        }
        
        return result
    }
    
    static func shortMonthName(for number: Int) -> String? {
        let num = (number % 12 == 0) ? 12 : number % 12
        
        guard (1...12).contains(num) else { return nil }
        
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM"
        
        let components = DateComponents(calendar: Calendar.current, month: num)
        return components.date.flatMap { formatter.string(from: $0) }
    }
    
    func isIn(_ dates: [Date], sameDay: Bool = true) -> Bool {
        if sameDay {
            dates.contains { Calendar.current.isDate($0, inSameDayAs: self)}
        } else {
            dates.contains(self)
        }
    }
}
