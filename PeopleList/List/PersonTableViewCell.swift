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
        if let imageLoadingTask = imageLoadingTask {
            PeopleManager.shared.cancelLoadingProfileImage(task: imageLoadingTask)
        }
        
        imageLoadingTask = nil
        activityIndicator.stopAnimating()
    }

    func fill(person: Person) {
        nameLabel.text = person.name
        profileImageView.image = nil
        
        if let profileImageURL = person.profileImageURL {
            activityIndicator.startAnimating()
            imageLoadingTask = PeopleManager.shared.loadProfileImage(url: profileImageURL) { [weak self] image in
                self?.profileImageView.image = image
                self?.activityIndicator.stopAnimating()
                self?.imageLoadingTask = nil
            }
        }
    }

    // MARK: - Implementation
    
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var profileImageView: UIImageView!
    @IBOutlet private weak var activityIndicator: UIActivityIndicatorView!
    
    var imageLoadingTask: URLSessionTask?
}
