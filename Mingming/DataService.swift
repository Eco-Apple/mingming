//
//  DataService.swift
//  Mingming
//
//  Created by Jerico Villaraza on 2/15/25.
//

import Foundation
import SwiftData
import UserNotifications

class DataService {
    private let container: ModelContainer
    private let context: ModelContext
    
    @MainActor
    static let shared = DataService()
    
    @MainActor
    private init() {
        container = try! ModelContainer(for: Habit.self, Commit.self, Tag.self, configurations: ModelConfiguration(isStoredInMemoryOnly: false))
        context = container.mainContext
    }
    
    func get() -> Result<[Habit], Error> {
        do {
            let descriptor = FetchDescriptor<Habit>(sortBy: [SortDescriptor(\Habit.listOrder)])
            
            let habits = try context.fetch(descriptor)
            
            return .success(habits)
        } catch {
            return .failure(error)
        }
    }
    
    func get() -> Result<[Tag], Error> {
        do {
            let descriptor = FetchDescriptor<Tag>()
            
            let tags = try context.fetch(descriptor)
            
            return .success(tags)
        } catch {
            return .failure(error)
        }
    }
    
    func add(habit: Habit) async -> Result<(Habit, [Tag]), Error> {
        do {
            let granted = try await UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge])
            
            guard granted else {
                return .failure(NSError(domain: "NotificationPermission", code: 1, userInfo: [NSLocalizedDescriptionKey: "User denied notification permission."]))
            }
            
            var newTags = [Tag]()
            var allTags = [Tag]()
            
            for tag in habit.tags {
                let result = add(tag: tag)
                
                switch result {
                case .success(let tag):
                    newTags.append(tag)
                    allTags.append(tag)
                case .failure(let error):
                    if let error = error as? DataService.TagExist {
                        if !allTags.contains(where: { $0 == error.tag }) {
                            error.tag.increaseHabitCount()
                            allTags.append(error.tag)
                        }
                    } else {
                        fatalError(error.localizedDescription)
                    }
                }
            }
            
            habit.tags = allTags
            
            context.insert(habit)
            try context.save()
            
            addReminder(habit)
            
            return .success((habit, newTags))
            
            
        } catch {
            return .failure(error)
        }
    }
    
    func add(tag: Tag) -> Result<Tag, Error> {
        do {
            let allTags = try context.fetch(FetchDescriptor<Tag>())
            
            if let tag = allTags.first(where: {  $0.name.caseInsensitiveCompare(tag.name) == .orderedSame }) {
                return .failure(TagExist(tag: tag))
            } else {
                context.insert(tag)
                try context.save()
                
                return .success(tag)
            }
        } catch {
            return .failure(error)
        }
    }
    
    func delete(_ habit: Habit) -> Result<(Habit, [Tag]), Error> {
        do {
            var deletedTags = [Tag]()
            
            for tag in habit.tags {
                if tag.habitCount <= 1 {
                    let result = delete(tag)
                    switch result {
                    case .success(let tag):
                        deletedTags.append(tag)
                    case .failure(let error):
                        fatalError(error.localizedDescription)
                    }
                } else {
                    tag.decreaseHabitCount()
                }
            }
            
            context.delete(habit)
            try context.save()
            
            deleteReminder(habit)
            
            return .success((habit, deletedTags))
        } catch {
            return .failure(error)
        }
    }
    
    func delete(_ tag: Tag) -> Result<Tag, Error> {
        do {
            context.delete(tag)
            try context.save()
            
            return .success(tag)
        } catch {
            return .failure(error)
        }
    }
    
    private func addReminder(_ habit: Habit) {
        let content = UNMutableNotificationContent()
        content.title = habit.title
        content.body = habit.combineTags
        content.sound = .default
        
        let calendar = Calendar.current
        var dateComponents = DateComponents()
        dateComponents.hour = calendar.component(.hour, from: habit.schedule)
        dateComponents.minute = calendar.component(.minute, from: habit.schedule)
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        let request = UNNotificationRequest(identifier: String(describing: habit.id), content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                debugPrint("Error scheduling notifications: \(error)")
            } else {
                self.getAllPendingNotifications()
            }
        }
    }
    
    private func deleteReminder(_ habit: Habit) {
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [String(describing: habit.id)])
        getAllPendingNotifications()
    }
    
    private func getAllPendingNotifications() {
        UNUserNotificationCenter.current().getPendingNotificationRequests { requests in
            debugPrint("Pending Notifications")
            for request in requests {
                debugPrint("=========================")
                debugPrint("ID: ", request.identifier)
                debugPrint("Title: ", request.content.title)
            }
        }
    }
}

extension DataService {
    struct TagExist: Error {
        let tag: Tag
    }
}
