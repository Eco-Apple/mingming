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
        SimpleEntry(date: Date(), emoji: "😀")
    }
    
    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(date: Date(), emoji: "😀")
        completion(entry)
    }
    
    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [SimpleEntry] = []
        
        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        let currentDate = Date()
        for hourOffset in 0 ..< 5 {
            let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
            let entry = SimpleEntry(date: entryDate, emoji: "😀")
            entries.append(entry)
        }
        
        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
    
    //    func relevances() async -> WidgetRelevances<Void> {
    //        // Generate a list containing the contexts this widget is relevant in.
    //    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let emoji: String
}

struct HabitCommitsEntryView : View {
    var entry: Provider.Entry
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4){
            Text("Running")
            HStack(spacing: 2) {
                ForEach(Array(Date.weekAndDaysInAYear(year: 2025, startMonth:  1, showNextYear: false, maxMonth: 3).enumerated()), id: \.offset) { index, month in
                    VStack(alignment: .leading, spacing: 7) {
                        HStack(spacing: 2) {
                            ForEach(Array(month.enumerated()), id: \.offset) { index, week in
                                VStack(spacing: 2) {
                                    ForEach(Array(week.enumerated()), id: \.offset) { index, day in
                                        Rectangle()
                                            .fill(Color.red)
                                            .frame(width: 8, height: 8)
                                    }
                                }
                            }
                        }
                        
                        Text("\(Date.shortMonthName(for: index + 1) ?? "" )")
                            .font(.system(size: 10))
                            .frame(height: 7)
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
    SimpleEntry(date: .now, emoji: "😀")
}
