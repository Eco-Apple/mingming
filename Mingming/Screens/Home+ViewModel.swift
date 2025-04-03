//
//  Home+ViewModel.swift
//  Mingming
//
//  Created by Jerico Villaraza on 2/9/25.
//

import SwiftUI
import WidgetKit

extension Home {
    
    @Observable
    class ViewModel {
        var tags: [Tag] = []
        var habits: [Habit] = []
        
        var isAddPresented = false
        var isDeletePresented = false
        
        var isReminderPresented = false
        var habitsToRemind: [Habit] = []
        
        var add: Add.ViewModel
        var habitToDelete: Habit?
        
        var dataService: DataService
        
        var years: [Year] = []
        
        var selectedYear: String = "All"
        var selectedTagNames: [String] = ["All"]
        
        var isLoading: Bool = false
        
        var habitCommitDays: [Habit: [Date: Bool]] = [:]
        
        init(dataService: DataService) {
            self.dataService = dataService
            self.add = Add.ViewModel(dataService: dataService)
        }
        
        func onAppear() {
            fetchHabits()
        }
        
        func selectYear(_ year: String) {
            selectedYear = year
            
            Task {
                await filterHabits()
            }
        }
        
        func selectTagName(_ name: String) {
            guard name != "All" else {
                selectedTagNames = ["All"]
                
                Task {
                    await filterHabits()
                }
                
                return
            }
            
            if selectedTagNames.contains("All") {
                selectedTagNames = []
            }
            
            if selectedTagNames.contains(name) {
                selectedTagNames.removeAll { $0 == name }
            } else {
                selectedTagNames.append(name)
            }
            
            if selectedTagNames.isEmpty {
                selectedTagNames = ["All"]
            }
            
            Task {
                await filterHabits()
            }
        }
        
        func deleteButtonCallback(isDelete: Bool) {
            guard let habit = habitToDelete else { return }
            
            if isDelete {
                let result = dataService.delete(habit)
                
                switch result {
                case .success(let (habit, tags, year)):
                    habits.removeAll { $0 == habit }
                    self.tags.removeAll { tags.contains($0) }
                    self.years.removeAll { $0 == year }
                    
                    WidgetCenter.shared.reloadAllTimelines()
                case .failure(let error):
                    fatalError(error.localizedDescription)
                }
            }
            
            isDeletePresented = false
        }
        
        func onDelete(habit: Habit) {
            habitToDelete = habit
            isDeletePresented = true
        }
        
        func onAdd() async {
            isLoading = true
            
            let result = await dataService.add(habit: .init(title: add.title, schedules: [add.selectedTime], tags: add.tags.toTags(), commits: []))
            
            switch result {
            case .success(let (habits, tags, year)):
                self.habits.append(habits)
                self.tags.append(contentsOf: tags)
                
                if let year {
                    self.years.append(year)
                }
                
                checkReminder()
                WidgetCenter.shared.reloadAllTimelines()
            case .failure(let error):
                debugPrint(error.localizedDescription)
            }
            
            isLoading = false
        }
        
        func onRemoveReminder(habit: Habit, commit: Commit, status: CommitStatus) {
            habitsToRemind.removeAll { $0 == habit }
            
            if habitsToRemind.isEmpty {
                isReminderPresented = false
            }
            
            let calendar = Calendar.current
            
            let status = status == .completed ? true : false
            
            habitCommitDays[habit]?[calendar.startOfDay(for: commit.date)] = status
        }
        
        private func filterHabits() async {
            do {
                isLoading = true
                let habits: [Habit] = try self.dataService.get(tagNames: selectedTagNames, year: Int(selectedYear))
                
                self.habits = habits
                isLoading = false
            } catch {
                debugPrint(error.localizedDescription)
            }
        }
        
        private func fetchHabits() {
            do {
                isLoading = true
                
                let tags: [Tag] = try self.dataService.get()
                self.tags = tags
                
                let years: [Year] = try self.dataService.get()
                self.years = years
                
                let habits: [Habit] = try self.dataService.get()
                
                for habit in habits {
                    habitCommitDays[habit] = [:]
                }
                
                self.habits = habits
                
                checkReminder()
                checkForgottenHabits(habits: habits)
                
                isLoading = false
            } catch {
                debugPrint(error.localizedDescription)
            }
        }
        
        private func checkReminder() {
            for habit in habits {
                if let lastCommit = habit.commits.last {
                    if lastCommit.date.startOfDay < Date.today.startOfDay {
                        checkTime(habit.schedule) {
                            self.showReminder(habit)
                        }
                    } else if lastCommit.date.startOfDay == Date.today.startOfDay {
                        switch lastCommit.status {
                        case .later(let date):
                            checkTime(date) {
                                self.showReminder(habit)
                            }
                        case .completed:
                            break
                        case .skippedManually:
                            break
                        case .forgotten:
                            break
                        }
                    }
                } else {
                    checkTime(habit.schedule) {
                        self.showReminder(habit)
                    }
                }
            }
        }
        
        private func checkTime(_ date: Date, completion: @escaping () -> Void) {
            let time = date.time
            let todayTime = Date.today.time
            
            if todayTime.hour! > time.hour! {
                completion()
            } else if todayTime.hour! == time.hour! {
                if todayTime.minute! >= time.minute! {
                    completion()
                }
            }
        }
        
        private func showReminder(_ habit: Habit) {
            if isReminderPresented != true {
                isReminderPresented = true
            }
            
            habitsToRemind.append(habit)
        }
        
        private func checkForgottenHabits(habits: [Habit]) {
            for habit in habits {
                debugPrintCommits(habit)
                if let lastCommit = habit.commits.last {
                    if case .later(let date) = lastCommit.status {
                        if let daysBetween = date.startOfDay.daysBetween(this: .today.startOfDay), daysBetween > 0 {
                            lastCommit.update(status: .forgotten, dataService: dataService)
                        }
                    }
                    
                    if let daysBetween = lastCommit.date.startOfDay.daysBetween(this: .today), daysBetween > 1 {
                        let lastCommitDate = lastCommit.date
                        
                        for index in 1...(daysBetween - 1) {
                            if let newDate = lastCommitDate.startOfDay.addDay(index) {
                                habit.add(commit: Commit(date: newDate, status: .forgotten), dataService: dataService)
                            }
                        }
                    }
                }
            }
            
            prepareWidgetData(habits: habits)
        }
        
        private func debugPrintCommits(_ habit: Habit) {
            debugPrint(habit.title)
            debugPrint("Today: \(Date.today.localTimeZone)")
            debugPrint("Total commits: \(habit.commits.count)")
//            debugPrint("\(habit.commits.first?.date.localTimeZone) :: \(habit.commits.last?.date.localTimeZone)")
            //            for commit in habit.commits {
            //                debugPrint("==========")
            //                debugPrint(commit.date.localTimeZone)
            //                debugPrint(commit.status)
            //            }
        }
        
        private func prepareWidgetData(habits: [Habit]) {
            let habitSummaries = habits.map { habit in
                let widgetCommit = habit.commits.map { commit in
                    WidgetCommit(id: commit.id, date: commit.date, status: commit.status.asWidgetCommitStatus)
                }
                
                let widgetTag = habit.tags.map { tag in
                    WidgetTag(id: tag.id, name: tag.name, habitCount: tag.habitCount)
                }
                
                let widgetYear = WidgetYear(id: habit.year!.id, value: habit.year!.value)
                
                return WidgetHabit(id: habit.id, title: habit.title, year: widgetYear, schedules: habit.schedules, commits: widgetCommit, tags: widgetTag)
            }
            
            if let data = try? JSONEncoder().encode(habitSummaries) {
                let defaults = UserDefaults(suiteName: "group.ecovillaraza.Mingming")!
                defaults.set(data, forKey: "habitWidgetData")
            }
        }
    }
}
