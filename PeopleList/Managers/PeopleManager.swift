//
//  PeopleManager.swift
//  PeopleList
//
//  Created by Ihor Vovk on 5/13/18.
//  Copyright © 2018 Ihor Vovk. All rights reserved.
//

import Foundation
import CoreData

class PeopleManager {
    
    static let shared = PeopleManager()
    
    let persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "PeopleList")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        
        return container
    }()
    
    func saveViewContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    func fillDatabaseWithPeople(completion: @escaping () -> Void) {
        persistentContainer.performBackgroundTask { context in
            for (index, name) in self.peopleNames.enumerated() {
                let person = Person(context: context)
                person.name = name
                person.number = Int64(index + 1)
            }
            
            do {
                try context.save()
            } catch {
                print("Failed to fill database with people")
            }
            
            DispatchQueue.main.async {
                completion()
            }
        }
    }
    
    // MARK: - Implementation
    
    private let peopleNames = ["Adam", "Henry", "Jeremy", "Kyle", "Mark", "Douglas", "Marion", "Jade", "Madison", "Robert", "Peyton", "Rodney", "Lucas", "Sam", "Eugene", "Laurie", "Jason", "Edward", "Toby", "Johnny"]
}
