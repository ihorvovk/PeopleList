//
//  PeopleListViewController.swift
//  PeopleList
//
//  Created by Ihor Vovk on 5/13/18.
//  Copyright © 2018 Ihor Vovk. All rights reserved.
//

import UIKit
import CoreData

class PeopleListViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let fetchRequest: NSFetchRequest<Person> = Person.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "number", ascending: true)]
        
        fetchResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: PeopleManager.shared.persistentContainer.viewContext, sectionNameKeyPath: nil, cacheName: nil)
        fetchResultsController.delegate = self
        
        try? fetchResultsController.performFetch()
        tableView.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "personEditing", let personEditingViewController = segue.destination as? PersonEditingViewController, let selectedIndexPath = tableView.indexPathForSelectedRow {
            let person = fetchResultsController.object(at: selectedIndexPath)
            personEditingViewController.setup(person: person)
        }
    }
    
    // MARK: - Implementation
    
    @IBOutlet fileprivate weak var tableView: UITableView!
    
    fileprivate var fetchResultsController: NSFetchedResultsController<Person>!
}

extension PeopleListViewController: NSFetchedResultsControllerDelegate {
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.reloadData()
    }
}

extension PeopleListViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fetchResultsController.fetchedObjects?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let person = fetchResultsController.object(at: indexPath)
        
        let result = tableView.dequeueReusableCell(withIdentifier: "person", for: indexPath) as! PersonTableViewCell
        result.fill(person: person)
        
        return result
    }
}

extension PeopleListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
