//
//  Reminder+ViewModel.swift
//  Mingming
//
//  Created by Jerico Villaraza on 3/8/25.
//

import SwiftUI
import WidgetKit

extension Reminder {
    
    @Observable
    class ViewModel {
        var dataService: DataService
        var habit: Habit
        var applyShadow: Bool
        var onRemove: (Commit, CommitStatus) -> Void
        
        init(dataService: DataService, habit: Habit, applyShadow: Bool = false, onRemove: @escaping (Commit, CommitStatus) -> Void) {
            self.dataService = dataService
            self.habit = habit
            self.applyShadow = applyShadow
            self.onRemove = onRemove
        }
        
        func done() {
            updateCommit(with: .completed)
            WidgetCenter.shared.reloadAllTimelines()
        }
            
        func skipped() {
            updateCommit(with: .skippedManually)
        }
        
        func later() {
            let laterDate = Calendar.current.date(byAdding: .minute, value: 10, to: .today)!
            updateCommit(with: .later(laterDate))
            NotificationHelper.addNotification(id: "\(String(describing: habit.id))_late", title: habit.title, body: habit.combineTags, date: laterDate)
        }
        
        private func updateCommit(with status: CommitStatus) {
            if let lastCommit = habit.commits.last, lastCommit.date.startOfDay == Date.today.startOfDay {
                lastCommit.update(status: status, dataService: dataService)
                
                onRemove(lastCommit, status)
            } else {
                let commit = Commit(date: .today, status: status)
                
                habit.add(commit: commit, dataService: dataService)
                onRemove(commit, status)
            }
            
        }
        
    }
}
