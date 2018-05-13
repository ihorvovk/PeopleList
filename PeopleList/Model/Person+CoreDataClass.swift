//
//  Person+CoreDataClass.swift
//  PeopleList
//
//  Created by Ihor Vovk on 5/13/18.
//  Copyright © 2018 Ihor Vovk. All rights reserved.
//
//

import Foundation
import CoreData

@objc(Person)
public class Person: NSManagedObject {

    var profileImageURL: URL? {
        return URL(string: String(format: "http://download.glide.me/pre-login-avatars/avatars_cartoon_animals_%02d.png", number))
    }
}
