//
//  TextFieldModifier.swift
//  Mingming
//
//  Created by Jerico Villaraza on 2/9/25.
//

import SwiftUI

struct TextFieldModifier: ViewModifier {
    var label: String
    
    func body(content: Content) -> some View {
        VStack(alignment: .leading, spacing: 7){
            Text(label)
                .frame(height: 8)
                .font(.system(size: 12))
                .foregroundStyle(.addFieldLabelFont)
            
            content
                .frame(height: 9)
                .font(.system(size: 14))
                .padding(.leading, 10)
                .padding(.vertical, 8)
                .background(.addFieldBackground)
                .clipShape(
                    RoundedCorners(radius: 5, corners: [.topLeft, .bottomLeft, .bottomRight])
                )
                .overlay(
                    RoundedCorners(radius: 5, corners: [.topLeft, .bottomLeft, .bottomRight])
                        .stroke(.addFieldStoke, lineWidth: 0.5)
                )
        }
    }
}

extension View {
    func customize(label: String) -> some View {
        modifier(TextFieldModifier(label: label))
    }
}
