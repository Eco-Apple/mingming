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
        
        func reset() {
            title = ""
            tags = ""
            time = ""
        }
    }
}
