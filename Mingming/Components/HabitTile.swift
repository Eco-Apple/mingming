//
//  HabitTile.swift
//  Mingming
//
//  Created by Jerico Villaraza on 2/8/25.
//

import SwiftUI

struct HabitTile: View {
    @State private var viewModel: ViewModel
    @Binding private var habitCommitDays: [Habit: [Date: Bool]]
    
    init(habit: Habit, startMonth: Int, habitCommits: Binding<[Habit: [Date: Bool]]>, onDelete: @escaping(Habit) -> Void) {
        _viewModel = State(initialValue: .init(habit: habit, startMonth: startMonth, onDelete: onDelete))
        _habitCommitDays = habitCommits
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: .zero){
            HStack(alignment: .bottom, spacing: .zero) {
                Text(viewModel.habit.title)
                    .font(.system(size: 22, weight: .medium))
                    .frame(height: 16)
                
                Spacer()
                
                Text("⏰ \(viewModel.habit.schedules.first?.formatTime() ?? "")")
                    .font(.system(size: 9, weight: .medium))
                    .frame(height: 9)
            }
            .frame(height: 16)
            .padding(.bottom, 10)
            
            ScrollViewReader { proxy in
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 2) {
                        ForEach(Array(viewModel.dates.enumerated()), id: \.offset) { index, month in
                            VStack(alignment: .leading, spacing: 7){
                                Text("\(Date.shortMonthName(for: index + 1) ?? "")")
                                    .font(.system(size: 10))
                                    .frame(height: 7)
                                
                                HStack(spacing: 2){
                                    ForEach(Array(month.enumerated()), id: \.offset) { index, week in
                                        VStack(spacing: 2) {
                                            ForEach(Array(week.enumerated()), id: \.offset) { index, day in
                                                ZStack {
                                                    RoundedRectangle(cornerRadius: day.isDateInToday ? 8 : 2)
                                                        .fill((habitCommitDays[viewModel.habit]?[day] ?? false) ? .do : day.isDateInToday ? .white : .notDo)
                                                        .frame(width: 8, height: 8)
                                                        .overlay(
                                                            Group {
                                                                if day.isDateInToday {
                                                                    RoundedRectangle(cornerRadius: 8)
                                                                        .stroke((habitCommitDays[viewModel.habit]?[day] ?? false) ? Color("do") : Color("today-tile-border"), lineWidth: 0.3)
                                                                }
                                                            }
                                                        )
                                                    
                                                    if !day.isDateInToday && !(habitCommitDays[viewModel.habit]?[day] ?? false) && day.isFirstDayOfTheMonth {
                                                        RoundedRectangle(cornerRadius: 2)
                                                            .fill(.notDo)
                                                            .frame(width: 8, height: 8)
                                                        RoundedRectangle(cornerRadius: 2)
                                                            .fill(.notDo)
                                                            .frame(width: 8, height: 8)
                                                    }
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
                .onAppear {
                    proxy.scrollTo(viewModel.startMonth - 1, anchor: .leading)
                }
            }
            
            HStack(spacing: .zero) {
                Button {
                    viewModel.onDelete(viewModel.habit)
                } label: {
                    Image(systemName: "trash")
                        .font(.system(size: 12))
                        .padding(.top, 7)
                }
                .buttonStyle(PlainButtonStyle())

                Spacer()
                
                HStack(spacing: 4) {
                    ForEach(viewModel.habit.tags, id: \.self) { tag in
                        Text("#\(tag.name)")
                            .chip()
                    }
               }
                .padding(.top, 10)
            }
        }
        .onAppear {
            Task {
                try? await viewModel.setCommits(in: $habitCommitDays)
            }
        }
    }
}

#Preview {
    HabitTile(habit: .example, startMonth: 2, habitCommits: .constant([:]) ,onDelete: { _ in })
}
