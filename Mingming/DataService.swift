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
        container = try! ModelContainer(for: Habit.self, Commit.self, Tag.self, Year.self, configurations: ModelConfiguration(isStoredInMemoryOnly: false))
        context = container.mainContext
    }
    
    func save() {
        do {
            try context.save()
        } catch {
            debugPrint(error.localizedDescription)
        }
    }
    
    func get(tagNames: [String] = [], year: Int? = nil) throws -> [Habit] {
        do {
            let calendar = Calendar.current
            let startOfYear = calendar.date(from: DateComponents(year: year, month: 1, day: 1))!
            let endOfYear = calendar.date(byAdding: DateComponents(year: 1, second: -1), to: startOfYear)!
            
            let predicate: Predicate<Habit>? = #Predicate { habit in
                (tagNames.isEmpty || tagNames.contains("All") || habit.tags.contains { tag in tagNames.contains(tag.name) }) && (year == nil || habit.createdAt >= startOfYear && habit.createdAt <= endOfYear)
            }
            
            let descriptor = FetchDescriptor<Habit>(predicate: predicate, sortBy: [SortDescriptor(\Habit.listOrder)])
            
            let habits = try context.fetch(descriptor)
            
            return habits
        } catch {
            throw error
        }
    }
    
    func get<T: PersistentModel>() throws -> [T] {
        do {
            let descriptor = FetchDescriptor<T>()
            
            let results = try context.fetch(descriptor)
            
            return results
        } catch {
            throw error
        }
    }
    
    func add(habit: Habit) async -> Result<(Habit, [Tag], Year?), Error> {
        do {
            let granted = try await UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge])
            
            guard granted else {
                return .failure(NSError(domain: "NotificationPermission", code: 1, userInfo: [NSLocalizedDescriptionKey: "User denied notification permission."]))
            }
            
            let tags = addTagFilter(habit)
            let year = addYearFilter(habit)
            
            context.insert(habit)
            try context.save()
            
            NotificationHelper.addNotification(id: String(describing: habit.id), title: habit.title, body: habit.combineTags, date: habit.schedule, repeats: true)
            
            #if DEBUG
            habit.generateRandomCommits(dataService: self) // TODO: remove this if, already optimized.
            #endif
            
            return .success((habit, tags, year))
            
            
        } catch {
            return .failure(error)
        }
    }
    
    func add(year: Year) -> Result<Year, Error> {
        do {
            let allYears = try context.fetch(FetchDescriptor<Year>())
            
            if let year = allYears.first(where: { $0.value == year.value }) {
                return .failure(YearExist(year: year))
            } else {
                context.insert(year)
                try context.save()
                
                return .success(year)
            }
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
    
    func delete(_ habit: Habit) -> Result<(Habit, [Tag], Year), Error> {
        do {
            
            let tags = deleteTagFilter(habit)
            let year = deleteYearFilter(habit)
            
            context.delete(habit)
            try context.save()
            
            NotificationHelper.deleteNotification(id: String(describing: habit.id))
            
            return .success((habit, tags, year))
        } catch {
            return .failure(error)
        }
    }
    
    func delete<T: PersistentModel>(_ data: T) -> Result<T, Error> {
        do {
            context.delete(data)
            try context.save()
            
            return .success(data)
        } catch {
            return .failure(error)
        }
    }
    
    private func deleteYearFilter(_ habit: Habit) -> Year {
        var resultYear = habit.year!
        
        if resultYear.habitCount <= 1 {
            let result: Result<Year, Error> = delete(resultYear)
            
            switch result {
            case .success(let year):
                resultYear = year
                debugPrint("Successfully deleted year")
            case .failure(let error):
                debugPrint(error.localizedDescription)
            }
        } else {
            resultYear.decreaseHabitCount()
        }
        
        return resultYear
    }
    
    private func deleteTagFilter(_ habit: Habit) -> [Tag] {
        var deletedTags = [Tag]()
        
        for tag in habit.tags {
            if tag.habitCount <= 1 {
                let result: Result<Tag, Error> = delete(tag)
                
                switch result {
                case .success(let tag):
                    deletedTags.append(tag)
                case .failure(let error):
                    debugPrint(error.localizedDescription)
                }
            } else {
                tag.decreaseHabitCount()
            }
        }
        
        return deletedTags
    }
    
    private func addTagFilter(_ habit: Habit) -> [Tag] {
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
                    debugPrint(error.localizedDescription)
                }
            }
        }
        
        habit.set(tags: allTags, dataService: self)
        
        return newTags
    }
    
    private func addYearFilter(_ habit: Habit) -> Year? {
        var resultYear: Year?
        var newYear: Year = Year(value: habit.createdAt.year)
        let result = add(year: newYear)
        
        switch result {
        case .success(let year):
            debugPrint("Successfully added year as filter")
            newYear = year
            resultYear = year
        case .failure(let error):
            if let error = error as? DataService.YearExist {
                error.year.increaseHabitCount()
                newYear = error.year
                resultYear = nil
            } else {
                debugPrint(error.localizedDescription)
            }
        }
        
        habit.set(year: newYear, dataService: self)
        
        return resultYear
    }
}

extension DataService {
    struct TagExist: Error {
        let tag: Tag
    }
    
    struct YearExist: Error {
        let year: Year
    }
}
