//
//  DataService.swift
//  Mingming
//
//  Created by Jerico Villaraza on 2/15/25.
//

import SwiftData

class DataService {
    private let container: ModelContainer
    private let context: ModelContext
    
    @MainActor
    static let shared = DataService()
    
    @MainActor
    private init() {
        container = try! ModelContainer(for: Habit.self, Commit.self, configurations: ModelConfiguration(isStoredInMemoryOnly: false))
        context = container.mainContext
    }
    
    func getHabits() -> Result<[Habit], Error> {
        do {
            let descriptor = FetchDescriptor<Habit>()
            
            let habits = try context.fetch(descriptor)
            
            return .success(habits)
        } catch {
            return .failure(error)
        }
    }
    
    func add(habit: Habit) -> Result<Habit, Error>{
        do {
            context.insert(habit)
            debugPrint(habit)
            try context.save()
            
            return .success(habit)
        } catch {
            return .failure(error)
        }
    }
}
