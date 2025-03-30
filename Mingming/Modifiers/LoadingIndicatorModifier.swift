//
//  LoadingIndicatorModifier.swift
//  Mingming
//
//  Created by Jerico Villaraza on 3/29/25.
//

import SwiftUI

struct LoadingIndicatorModifier: ViewModifier {
    let isPresented: Bool
    
    func body(content: Content) -> some View {
        ZStack {
            content
                .disabled(isPresented)
                .blur(radius: isPresented ? 2 : 0)
            
            if isPresented {
                ZStack {
                    Color.black.opacity(0.3)
                        .ignoresSafeArea()
                    
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle())
                        .scaleEffect(1.5)
                        .padding(20)
                        .background(
                            RoundedRectangle(cornerRadius: 10)
                                .fill(Color(UIColor.systemGray6))
                                .shadow(radius: 5)
                        )
                }
            }
        }
    }
}

extension View {
    func loadingIndicator(isPresented: Bool) -> some View {
        modifier(LoadingIndicatorModifier(isPresented: isPresented))
    }
}
