//
//  HabitCommits.swift
//  HabitCommits
//
//  Created by Jerico Villaraza on 3/2/25.
//

import WidgetKit
import SwiftUI

struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(habits: [.example], date: Date())
    }
    
    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(habits: [.example], date: Date())
        completion(entry)
    }
    
    
    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        Task { @MainActor in
            let dataService = DataService.shared
            let result: Result<[Habit], Error> = dataService.get()
            
            switch result {
            case .success(let habits):
                var entries: [SimpleEntry] = []
                
                let currentDate = Date()
                for hourOffset in 0 ..< 5 {
                    let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
                    
                    let randomHabits: [Habit]
                    
                    if context.family == .systemLarge {
                        randomHabits = Array(habits.prefix(2))
                    } else {
                        randomHabits = [habits.randomElement() ?? .example]
                    }
                    
                    let entry = SimpleEntry(habits: randomHabits, date: entryDate)
                    entries.append(entry)
                }
                
                let timeline = Timeline(entries: entries, policy: .atEnd)
                completion(timeline)
            case .failure(let error):
                debugPrint(error)
            }
        }
    }
    
    //    func relevances() async -> WidgetRelevances<Void> {
    //        // Generate a list containing the contexts this widget is relevant in.
    //    }
}

struct SimpleEntry: TimelineEntry {
    let habits: [Habit]
    let date: Date
}

struct HabitCommitsEntryView : View {
    @Environment(\.widgetFamily) var widgetFamily
    
    var entry: Provider.Entry
    
    var previousMonthNumber: Int {
        let calendar = Calendar.current
        let currentDate = Date()
        
        let previousMonthDate = calendar.date(byAdding: .month, value: -2, to: currentDate)!
        return calendar.component(.month, from: previousMonthDate)
    }
    
    var maxMonth: Int {
        switch widgetFamily {
        case .systemSmall:
            return 3
        case .systemMedium:
            return 7
        case .systemLarge:
            return 7
        case .systemExtraLarge:
            return 5
        default:
            return 3
        }
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 30){
            ForEach(entry.habits) { habit in
                VStack(alignment: .leading, spacing: 4){
                    HStack(alignment: .center, spacing: 0) {
                        Text(habit.title)
                        
                        Spacer()
                        
                        Text("⏰ \(habit.schedules.first?.formatTime() ?? "")")
                            .font(.system(size: 9, weight: .medium))
                    }
                    HStack {
                        ForEach(habit.tags, id: \.self) { tag in
                            Text("#\(tag.name)")
                                .font(.system(size: 9, weight: .medium))
                        }
                    }
                    .padding(.bottom, 2)
                    
                    HStack(spacing: 2) {
                        ForEach(Array(Date.weekAndDaysInAYear(year: 2025, startMonth:  previousMonthNumber, showNextYear: false, maxMonth: maxMonth).enumerated()), id: \.offset) { index, month in
                            VStack(alignment: .leading, spacing: 7) {
                                HStack(spacing: 2) {
                                    ForEach(Array(month.enumerated()), id: \.offset) { index, week in
                                        VStack(spacing: 2) {
                                            ForEach(Array(week.enumerated()), id: \.offset) { index, day in
                                                Rectangle()
                                                    .fill(day.isIn(habit.commits) ? .do: .notDo)
                                                    .frame(width: 8, height: 8)
                                            }
                                        }
                                    }
                                }
                                
                                Text("\(Date.shortMonthName(for: previousMonthNumber + index) ?? "" )")
                                    .font(.system(size: 10))
                                    .frame(height: 7)
                            }
                        }
                    }
                }
            }
        }
    }
}

struct HabitCommits: Widget {
    let kind: String = "HabitCommits"
    
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            if #available(iOS 17.0, *) {
                HabitCommitsEntryView(entry: entry)
                    .containerBackground(.fill.tertiary, for: .widget)
            } else {
                HabitCommitsEntryView(entry: entry)
                    .padding()
                    .background()
            }
        }
        .configurationDisplayName("My Widget")
        .description("This is an example widget.")
    }
}

#Preview(as: .systemSmall) {
    HabitCommits()
} timeline: {
    SimpleEntry(habits: [.example], date: Date())
}
