//
//  TextChipModifier.swift
//  Mingming
//
//  Created by Jerico Villaraza on 2/8/25.
//

import SwiftUI

enum ChipSize {
    case small, medium
}

struct TextChipModifier: ViewModifier {
    let size: ChipSize
    
    func body(content: Content) -> some View {
        content
            .frame(height: 9)
            .font(.system(size: fontSize()))
            .padding(.horizontal, 12)
            .padding(.vertical, 7)
            .background(.homeTagBg)
            .cornerRadius(17)
        
    }
    
    func fontSize() -> CGFloat {
        switch size {
        case .medium:
            return 11
        case .small:
            return 9
        }
    }
}

extension Text {
    func chip(size: ChipSize = .small) -> some View {
        modifier(TextChipModifier(size: size))
    }
}
