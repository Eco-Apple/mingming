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
        var habits: [Habit] = []
        
        var isAddPresented = false
        var isDeletePresented = false
        var isReminderPresented = false
        
        var add: Add.ViewModel
        
        var dataService: DataService
        
        init(dataService: DataService) {
            self.dataService = dataService
            self.add = Add.ViewModel(dataService: dataService)
        }
        
        func onAppear() {
            let result = dataService.getHabits()
            
            switch result {
            case .success(let habits):
                self.habits = habits
            case .failure(let error):
                fatalError(error.localizedDescription)
            }
            
        }
        
        func deleteButtonCallback(isDelete: Bool) {
            isDeletePresented = false
        }
        
        func onDelete() {
            isDeletePresented = true
        }
        
        func onAdd() {
            let result = dataService.add(habit: .init(title: add.title, schedules: [add.selectedTime], tags: add.tags.toTags(), commits: []))
            
            switch result {
            case .success(let data):
                print(data)
            case .failure(let error):
                fatalError(error.localizedDescription)
            }
            isAddPresented = false
            add.reset()
        }
    }
}
