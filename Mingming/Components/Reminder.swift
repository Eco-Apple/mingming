//
//  Reminder.swift
//  Mingming
//
//  Created by Jerico Villaraza on 2/14/25.
//

import SwiftUI

struct Reminder: View {
    @State var viewModel: ViewModel
    
    init(habit: Habit, applyShadow: Bool, onRemove: @escaping (Commit, CommitStatus) -> Void) {
        _viewModel = State(initialValue: .init(dataService: .shared, habit: habit, applyShadow: applyShadow, onRemove: onRemove))
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: .zero) {
            Spacer()
            
            VStack(alignment: .leading, spacing: .zero) {
                (Text("⏰ ")
                 + Text(viewModel.habit.title))
                    .font(.system(size: 18, weight: .medium))
                    .frame(height: 15, alignment: .center)
                
                HStack(alignment: .bottom, spacing: .zero) {
                    ForEach(viewModel.habit.tags, id: \.self) { tag in
                        Text("#\(tag.name)")
                            .chip(size: .medium)
                    }
                }
                .padding(.top, 16)
                
                HStack(alignment: .center, spacing: .zero) {
                    Button(action: viewModel.done){
                        Text("✔️ Done")
                            .font(.system(size: 16, weight: .medium))
                    }
                    .buttonStyle(PlainButtonStyle())
                    .frame(maxWidth: .infinity)
                    
                    Button(action: viewModel.skipped) {
                        Text("❌ Skipped")
                            .font(.system(size: 16, weight: .medium))
                    }
                    .buttonStyle(PlainButtonStyle())
                    .frame(maxWidth: .infinity)
                    
                    Button(action: viewModel.later) {
                        Text("⏳Later")
                            .font(.system(size: 16, weight: .medium))
                    }
                    .buttonStyle(PlainButtonStyle())
                    .frame(maxWidth: .infinity)
                }
                .frame(height: 13)
                .padding(.top, 18)
            }
            .padding(.top, 21)
            .padding(.bottom, 13)
            .padding(.horizontal, 17)
            .background(.white)
            .cornerRadius(15)
            .shadow(color: !viewModel.applyShadow ? .clear : .black.opacity(0.25), radius: 6.3, x: 0, y: 0)
            .padding(.bottom, 10)
            .padding(.horizontal, 12)
        }
    }
}

#Preview {
    Reminder(habit: .example, applyShadow: false) { _,_ in
        
    }
}
