//
//  PersonEditingViewController.swift
//  PeopleList
//
//  Created by Ihor Vovk on 5/13/18.
//  Copyright © 2018 Ihor Vovk. All rights reserved.
//

import UIKit

class PersonEditingViewController: UIViewController {
    
    func setup(person: Person) {
        self.person = person
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        nameTextField.text = person.name
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if let name = nameTextField.text, name != person.name {
            person.name = name
            PeopleManager.shared.saveViewContext()
        }
    }
    
    // MARK: - Implementation
    
    @IBOutlet private weak var nameTextField: UITextField!
    
    private var person: Person!
}
