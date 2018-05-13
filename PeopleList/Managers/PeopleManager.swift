//
//  PeopleManager.swift
//  PeopleList
//
//  Created by Ihor Vovk on 5/13/18.
//  Copyright © 2018 Ihor Vovk. All rights reserved.
//

import Foundation
import CoreData
import UIKit

class PeopleManager: NSObject {
    
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
    
    func loadProfileImage(url: URL, completion: @escaping (UIImage?) -> Void) -> URLSessionTask? {
        if let cachedImage = imagesCache.object(forKey: url as NSURL) {
            completion(cachedImage)
            return nil
        }
        
        let task = imageDownloadingSession.downloadTask(with: url)
        loadingTaskCompletions[task.taskIdentifier] = completion
        
        task.resume()
        return task
    }
    
    func cancelLoadingProfileImage(task: URLSessionTask) {
        task.cancel()
        loadingTaskCompletions.removeValue(forKey: task.taskIdentifier)
    }
    
    // MARK: - Implementation
    
    lazy var peopleNames = ["Adam", "Henry", "Jeremy", "Kyle", "Mark", "Douglas", "Marion", "Jade", "Madison", "Robert", "Peyton", "Rodney", "Lucas", "Sam", "Eugene", "Laurie", "Jason", "Edward", "Toby", "Johnny"]
    lazy var imageDownloadingSession: URLSession = {
        let configuration = URLSessionConfiguration.background(withIdentifier: "com.ihor.m.vovk.PeopleList.imageDownloading")
        configuration.httpMaximumConnectionsPerHost = 1
        configuration.httpShouldUsePipelining = true
        configuration.isDiscretionary = true
        
        return URLSession(configuration: configuration, delegate: self, delegateQueue: nil)
    }()
    
    fileprivate var loadingTaskCompletions: [Int: (UIImage?) -> Void] = [:]
    fileprivate let imagesCache = NSCache<NSURL, UIImage>()
}

extension PeopleManager: URLSessionDelegate {
    
    func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        if let error = error, let completion = loadingTaskCompletions[task.taskIdentifier] {
            print("Failed to load profile image for url - \(task.originalRequest?.url?.absoluteString ?? ""). Error - \(error.localizedDescription)")
            DispatchQueue.main.async {
                completion(nil)
                self.loadingTaskCompletions.removeValue(forKey: task.taskIdentifier)
            }
        }
    }
}

extension PeopleManager: URLSessionDownloadDelegate {
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        if let data = try? Data(contentsOf: location), let image = UIImage(data: data), let completion = loadingTaskCompletions[downloadTask.taskIdentifier] {
            DispatchQueue.main.async {
                completion(image)

                self.loadingTaskCompletions.removeValue(forKey: downloadTask.taskIdentifier)
                if let url = downloadTask.originalRequest?.url {
                    self.imagesCache.setObject(image, forKey: url as NSURL)
                }
            }
        }
    }
}
