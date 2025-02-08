//
//  Home.swift
//  Mingming
//
//  Created by Jerico Villaraza on 2/7/25.
//

import SwiftUI

struct Home: View {
    var body: some View {
        VStack(spacing: .zero) {
            ScrollView {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(alignment: .center, spacing: 4.0) {
                        FilterButton("All", isActive: true)
                            .padding(.leading, (UIScreen.main.bounds.width * 0.5) + 6)
                        
                        FilterButton("Daily Habits", isActive: false)
                        
                        FilterButton("Routine", isActive: false)
                    }
                    .padding(0.5)
                }
                .padding(.top, 12)
                
                VStack(alignment: .leading, spacing: 14) {
                    HabitTile(startMonth: 2)
                    HabitTile(startMonth: 2)
                }
                .padding(.horizontal, 12)
            }
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(alignment: .center, spacing: 4.0) {
                    FilterButton("2025", isActive: false)
                    FilterButton("All", isActive: true)
                }
                .padding(0.5)
            }
            .padding(.leading, 12)
        }
        .background(.clear)
        .customToolbar {
            HStack(alignment: .bottom, spacing: .zero) {
                Image(.toolbarLogo)
                
                Text("Mingming")
                    .font(.custom("ClickerScript-Regular", size: 22))
                    .frame(height: 18)
                    .padding(.leading, 5)
                    .padding(.bottom, 3)
                
                Spacer()
                
                Button {
                    
                } label: {
                    Image(systemName: "plus")
                        .font(.system(size: 20, weight: .medium))
                }
                .buttonStyle(PlainButtonStyle())
            }
            .padding(.horizontal, 12)
        }
    }
}

#Preview {
    Home()
}
