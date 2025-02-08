//
//  ContentView.swift
//  Mingming
//
//  Created by Jerico Villaraza on 2/7/25.
//

import SwiftUI

struct ContentView: View {
    @State private var isSplash = true
    
    var body: some View {
        ZStack {
            if isSplash {
                Splash()
            } else {
                NavigationStack {
                    Home()
                }
            }
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                isSplash = false
            }
        }
    }
}

#Preview {
    ContentView()
}
