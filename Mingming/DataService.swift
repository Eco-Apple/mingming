//
//  DataService.swift
//  Mingming
//
//  Created by Jerico Villaraza on 2/15/25.
//

import Foundation
import SwiftData

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
    
    func add(habit: Habit) -> Result<Habit, Error> {
        do {
            context.insert(habit)
            debugPrint(habit)
            try context.save()
            
            return .success(habit)
        } catch {
            return .failure(error)
        }
    }
    
    func add(tag: String) -> Result<Tag, Error> {
        do {
            let lowercasedName = tag.lowercased()
            let allTags = try context.fetch(FetchDescriptor<Tag>())
            
            if allTags.contains(where: { $0.name.caseInsensitiveCompare(tag) == .orderedSame }) == false {
                let newTag = Tag(name: tag)
                context.insert(newTag)
                try context.save()
                
                return .success(newTag)
            } else {
                return .failure(TagError.tagExists)
            }
        } catch {
            return .failure(error)
        }
    }
    
    func delete(_ habit: Habit) -> Result<Habit, Error> {
        do {
            context.delete(habit)
            try context.save()
            
            return .success(habit)
        } catch {
            return .failure(error)
        }
    }
}

extension DataService {
    enum TagError: Error {
        case tagExists
    }
}
