//
//  CoreDataService.swift
//  ShakeMe
//
//  Created by Eduard Galchenko on 8/15/19.
//  Copyright © 2019 Eduard Galchenko. All rights reserved.
//

import CoreData

public class CoreDataService {
    
    public static let shared = CoreDataService()
    
    // Data
    public var backgroundContext: NSManagedObjectContext!
    
    private init() {
        createContainer { container in
            self.backgroundContext = container.newBackgroundContext()
        }
    }
    
    func fetchAllAnswers() -> [CustomAnswer] {
        let fetchRequest =
            NSFetchRequest<NSFetchRequestResult>(entityName: "CustomAnswer")
        
        do {
            guard let answers = try backgroundContext.fetch(fetchRequest) as? [CustomAnswer] else { return [] }
            return answers
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
        
        return []
    }
    
    public func save(_ text: String) {
        guard let context = backgroundContext else { return }
        guard let answer = NSEntityDescription.insertNewObject(forEntityName: "CustomAnswer", into: context) as? CustomAnswer else { return }
        answer.answerText = text
        
        do {
            try context.save()
        } catch {
            print(error)
        }
    }
    
    func deleteAnswer(answer: NSManagedObject) {
        guard let context = backgroundContext else { return }
        context.delete(answer)
        
        do {
            try context.save()
        } catch let error as NSError {
            print("Error While Deleting Note: \(error.userInfo)")
        }
    }
    
    private func createContainer(completion: @escaping
        (NSPersistentContainer) -> ()) { let container = NSPersistentContainer(name:
        "DataModel")
        container.loadPersistentStores(completionHandler: { _,
            error in
            guard error == nil else {
                fatalError("Failed to load store")
            }
            DispatchQueue.main.async { completion(container) }
        })
    }
    
}