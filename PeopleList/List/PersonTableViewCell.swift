//
//  PersonTableViewCell.swift
//  PeopleList
//
//  Created by Ihor Vovk on 5/13/18.
//  Copyright © 2018 Ihor Vovk. All rights reserved.
//

import UIKit

class PersonTableViewCell: UITableViewCell {
    
    override func prepareForReuse() {
    }

    func fill(person: Person) {
        nameLabel.text = person.name
    }

    // MARK: - Implementation
    
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var profileImageView: UIImageView!
    @IBOutlet private weak var activityIndicator: UIActivityIndicatorView!
}
