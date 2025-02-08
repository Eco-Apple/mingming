//
//  HabitTile.swift
//  Mingming
//
//  Created by Jerico Villaraza on 2/8/25.
//

import SwiftUI

struct HabitTile: View {
    var startMonth: Int
    var dates: [Date] = [.now]
    
    var body: some View {
        VStack(alignment: .leading, spacing: .zero){
            HStack(alignment: .bottom, spacing: .zero) {
                Text("Run")
                    .font(.system(size: 22, weight: .medium))
                    .frame(height: 16)
                
                Spacer()
                
                Text("⏰ 5:30 PM")
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
                                                Rectangle()
                                                    .fill(day.isIn(dates) ? .do : .notDo)
                                                    .frame(width: 8, height: 8)
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
                .onAppear {
                    proxy.scrollTo(startMonth - 1, anchor: .leading) // Change `1` to the index of the month you want
                }
            }
            
            HStack(spacing: .zero) {
                Button {
                    
                } label: {
                    Image(systemName: "trash")
                        .font(.system(size: 12))
                        .padding(.top, 7)
                }
                .buttonStyle(PlainButtonStyle())

                Spacer()
                
                HStack(spacing: 4) {
                    Text("#HealthyLifeStyle")
                        .chip()
                    Text("#DailyHabits")
                        .chip()
                }
                .padding(.top, 10)
            }
        }
    }
}

#Preview {
    HabitTile(startMonth: 2)
}
