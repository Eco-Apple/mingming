//
//  HabitTile+ViewModel.swift
//  Mingming
//
//  Created by Jerico Villaraza on 3/30/25.
//

import SwiftUI

extension HabitTile {
    @Observable
    class ViewModel {
        var habit: Habit
        var startMonth: Int
        var selectedYear: String
        
        var dates: [[[Date]]]
        var onDelete: (Habit) -> Void
        
        init(habit: Habit, startMonth: Int, selectedYear: String, onDelete: @escaping (Habit) -> Void) {
            self.habit = habit
            self.startMonth = startMonth
            self.selectedYear = selectedYear
            self.onDelete = onDelete
            
            var year = habit.year!.value
            
            if selectedYear != "All" {
                year = Int(selectedYear)!
            }
            
            dates = Date.weekAndDaysInAYear(year: year, startMonth: startMonth)
        }
        
        func setCommits(in commits: Binding<[Habit: [Date: Bool]]>) async throws {
            var habitCommits = await MainActor.run { habit.commits }
            var tempCommits: [Date: Bool] = [:]
            
            for month in dates {
                for week in month {
                    for day in week {
                        tempCommits[day] = await MainActor.run { habitCommits.isIn(day) }
                    }
                }
            }
            
            await MainActor.run {
                commits.wrappedValue[habit] = tempCommits
            }
        }
    }
    
}
