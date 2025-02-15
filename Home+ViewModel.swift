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
        var isAddPresented = false
        var isDeletePresented = false
        var isReminderPresented = false
        
        var add = Add.ViewModel()
        
        func onAppear() {
            
        }
        
        func deleteButtonCallback(isDelete: Bool) {
            isDeletePresented = false
        }
        
        func onDelete() {
            isDeletePresented = true
        }
        
        func onAdd() {
            isAddPresented = false
            add.reset()
        }
    }
}
