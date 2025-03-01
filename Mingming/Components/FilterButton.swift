//
//  FilterButton.swift
//  Mingming
//
//  Created by Jerico Villaraza on 2/8/25.
//

import SwiftUI

struct FilterButton: View {
    var text: String
    var isActive: Bool
    
    var onTap: () -> Void
    
    init(_ text: String, isActive: Bool, onTap: @escaping () -> Void) {
        self.text = text
        self.isActive = isActive
        self.onTap = onTap
    }
    
    var body: some View {
        if isActive {
            Button(action: onTap){
                Text(text)
                    .foregroundStyle(.white)
                    .font(.system(size: 11, weight: .medium))
                    .frame(height: 10, alignment: .center)
                    .padding(.vertical, 10)
                    .padding(.horizontal, 12)
                    .background(
                        RoundedRectangle(cornerRadius: 10)
                            .fill(.black)
                    )
                    .overlay {
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(.black, lineWidth: 0.5)
                    }
            }
            .buttonStyle(PlainButtonStyle())
        } else {
            Button(action: onTap) {
                Text(text)
                    .foregroundStyle(.black)
                    .font(.system(size: 11, weight: .medium))
                    .frame(height: 10, alignment: .center)
            }
            .buttonStyle(PlainButtonStyle())
            .padding(.vertical, 9.5)
            .padding(.horizontal, 12)
            .overlay {
                RoundedRectangle(cornerRadius: 10)
                    .stroke(.black, lineWidth: 0.5)
            }
        }
    }
}
#Preview {
    FilterButton("All", isActive: true, onTap: {})
}
