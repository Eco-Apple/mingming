//
//  Reminder+ViewModel.swift
//  Mingming
//
//  Created by Jerico Villaraza on 3/8/25.
//

import SwiftUI

extension Reminder {
    
    @Observable
    class ViewModel {
        var dataService: DataService
        var habit: Habit
        var onRemove: () -> Void
        
        init(dataService: DataService, habit: Habit, onRemove: @escaping () -> Void) {
            self.dataService = dataService
            self.habit = habit
            self.onRemove = onRemove
        }
        
        func done() {
            updateCommit(with: .completed)
        }
        
        func skipped() {
            updateCommit(with: .skippedManually)
        }
        
        func later() {
            let laterDate = Calendar.current.date(byAdding: .hour, value: 1, to: .now)!
            updateCommit(with: .later(laterDate))
        }
        
        private func updateCommit(with status: CommitStatus) {
            if let lastCommit = habit.commits.last, lastCommit.date.startOfDay != Date.now.startOfDay {
                lastCommit.update(status: status)
            } else {
                habit.commits.append(Commit(date: .now, status: status))
            }
            
            onRemove()
        }
        
    }
}
