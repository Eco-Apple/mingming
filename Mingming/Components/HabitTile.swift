//
//  HabitTile.swift
//  Mingming
//
//  Created by Jerico Villaraza on 2/8/25.
//

import SwiftUI

struct HabitTile: View {
    
    var habit: Habit
    var startMonth: Int
    
    var onDelete: (Habit) -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: .zero){
            HStack(alignment: .bottom, spacing: .zero) {
                Text(habit.title)
                    .font(.system(size: 22, weight: .medium))
                    .frame(height: 16)
                
                Spacer()
                
                Text("⏰ \(habit.schedules.first?.formatTime() ?? "")")
                    .font(.system(size: 9, weight: .medium))
                    .frame(height: 9)
            }
            .frame(height: 16)
            .padding(.bottom, 10)
            
            ScrollViewReader { proxy in
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 2) {
                        ForEach(Array(Date.weekAndDaysInAYear(year: 2025).enumerated()), id: \.offset) { index, month in
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
                                                        .fill(habit.commits.isIn(day) ? .do : day.isDateInToday ? .white : .notDo)
                                                        .frame(width: 8, height: 8)
                                                        .overlay(
                                                            Group {
                                                                if day.isDateInToday {
                                                                    RoundedRectangle(cornerRadius: 8)
                                                                        .stroke(habit.commits.isIn(day) ? Color("do") : Color("today-tile-border"), lineWidth: 0.3)
                                                                }
                                                            }
                                                        )
                                                    
                                                    if !day.isDateInToday && !habit.commits.isIn(day) && day.isFirstDayOfTheMonth {
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
                    proxy.scrollTo(startMonth - 1, anchor: .leading)
                }
            }
            
            HStack(spacing: .zero) {
                Button {
                   onDelete(habit)
                } label: {
                    Image(systemName: "trash")
                        .font(.system(size: 12))
                        .padding(.top, 7)
                }
                .buttonStyle(PlainButtonStyle())

                Spacer()
                
                HStack(spacing: 4) {
                    ForEach(habit.tags, id: \.self) { tag in
                        Text("#\(tag.name)")
                            .chip()
                    }
               }
                .padding(.top, 10)
            }
        }
    }
}

#Preview {
    HabitTile(habit: .example, startMonth: 2, onDelete: { _ in })
}
