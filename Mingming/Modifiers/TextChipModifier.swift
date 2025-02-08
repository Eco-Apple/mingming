//
//  TextChipModifier.swift
//  Mingming
//
//  Created by Jerico Villaraza on 2/8/25.
//

import SwiftUI

struct TextChipModifier: ViewModifier {
    
    func body(content: Content) -> some View {
        content
            .frame(height: 9)
            .font(.system(size: 9))
            .padding(.horizontal, 12)
            .padding(.vertical, 7)
            .background(.homeTagBg)
            .cornerRadius(17)
        
    }
}

extension Text {
    func chip() -> some View {
        modifier(TextChipModifier())
    }
}
