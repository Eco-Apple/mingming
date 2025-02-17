//
//  Home+ViewModel.swift
//  Mingming
//
//  Created by Jerico Villaraza on 2/9/25.
//

import SwiftUI

extension Home {
    
    @Observable
    class ViewModel {
        var tags: [Tag] = []
        var habits: [Habit] = []
        
        var isAddPresented = false
        var isDeletePresented = false
        var isReminderPresented = false
        
        var add: Add.ViewModel
        var habitToDelete: Habit?
        
        var dataService: DataService
        
        init(dataService: DataService) {
            self.dataService = dataService
            self.add = Add.ViewModel(dataService: dataService)
        }
        
        func onAppear() {
            let habitResult: Result<[Habit], Error> = self.dataService.get()
            
            switch habitResult {
            case .success(let habits):
                self.habits = habits
            case .failure(let error):
                fatalError(error.localizedDescription)
            }
            
            let tagResult: Result<[Tag], Error> = self.dataService.get()
            
            switch tagResult {
            case .success(let tags):
                self.tags = tags
            case .failure(let error):
                fatalError(error.localizedDescription)
            }
            
        }
        
        func deleteButtonCallback(isDelete: Bool) {
            guard let habit = habitToDelete else { return }
            
            if isDelete {
                let result = dataService.delete(habit)
                
                switch result {
                case .success(let habit):
                    habits.removeAll { $0 == habit }
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
        
        func onAdd() {
            let tags = add.tags.toTags()
            let result = dataService.add(habit: .init(title: add.title, schedules: [add.selectedTime], tags: tags, commits: []))
            
            switch result {
            case .success(let data):
                habits.append(data)
                storeTags(tags)
            case .failure(let error):
                fatalError(error.localizedDescription)
            }
            isAddPresented = false
            add.reset()
        }
        
        private func storeTags(_ tags: [String]) {
            for tag in tags {
                let modifiedTag = tag.replacingOccurrences(of: "#", with: "")
                
                let result = dataService.add(tag: modifiedTag)
                
                switch result {
                case .success(let tag):
                    self.tags.append(tag)
                case .failure(let error):
                    if error as! DataService.TagError == DataService.TagError.tagExists {
                        print("Tag already exists!")
                    } else {
                        fatalError(error.localizedDescription)
                    }
                }
            }
        }
    }
}
