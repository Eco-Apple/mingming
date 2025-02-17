//
//  Add+ViewModel.swift
//  Mingming
//
//  Created by Jerico Villaraza on 2/9/25.
//

import SwiftUI

extension Add {
    @Observable
    class ViewModel {
        var title: String = ""
        var tags: String = ""
        var time: String = ""
        
        var showTimePicker: Bool = false
        var selectedTime: Date = Date()
        
        var dataService: DataService
        
        var isShown: Bool = false
        
        init(dataService: DataService) {
            self.dataService = dataService
        }
        
        func reset() {
            title = ""
            tags = ""
            time = ""
        }
    }
}
