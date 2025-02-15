//
//  CustomAlert.swift
//  Mingming
//
//  Created by Jerico Villaraza on 2/9/25.
//

import SwiftUI

struct CustomAlertModifier<AlertContent: View>: ViewModifier {
    @Binding var isPresented: Bool
    @Binding var isOverlayShow: Bool
    
    let alertContent: () -> AlertContent
    
    func body(content: Content) -> some View {
        ZStack {
            content
            
            if isPresented {
                Color
                    .overlay
                    .ignoresSafeArea()
                    .opacity(isOverlayShow ? 1 : 0)
                
                alertContent()
            }
        }
    }
}

extension View {
    func customAlert<Content: View>(isPresented: Binding<Bool>, isOverlayShow: Binding<Bool> = .constant(true), @ViewBuilder content: @escaping () -> Content) -> some View {
        return modifier(CustomAlertModifier(isPresented: isPresented, isOverlayShow: isOverlayShow, alertContent: content))
    }
}
