//
//  PersonDataStore.swift
//  OCRcpt
//
//  Created by Kevin Hu on 11/3/18.
//  Copyright © 2018 hu. All rights reserved.
//

import Foundation
import UIKit

class Person {

    static let you: Person = {
        let singleton = Person(name: "You", phone: nil, email: nil, image: nil)
        return singleton
    }()
    
    var name: String!
    var phone: String?
    var email: String?
    var image: UIImage?
    var favorited: Bool
    var selected: Bool
    
    init(name: String!, phone: String?, email: String?, image: UIImage?) {
        if let n = name {
            self.name = n
            if let p = phone {
                self.phone = p
            }
            if let e = email {
                self.email = e
            }
            if let i = image {
                self.image = i
            }
        }
        self.favorited = false
        self.selected = false
    }
}

class PersonDataStore {
    
    static let shared: PersonDataStore = {
        let singleton = PersonDataStore()
        return singleton
    }()
    
    var allPersons = [Person]()
    var favoritedPersons: [Person] {
        return allPersons.filter({ (person) -> Bool in
            return person.favorited
        })
    }
    var nonfavoritedPersons: [Person] {
        return allPersons.filter({ (person) -> Bool in
            return !person.favorited
        })
    }
    
    func fetch() {
        // From Contacts or from encoder. For now, just dummy data.
        allPersons.append(Person(name: "Alex", phone: "5555555555", email: nil, image: nil))
        allPersons.append(Person(name: "Bob", phone: "555123456", email: nil, image: nil))
        allPersons.append(Person(name: "Candice", phone: nil, email: "name@email.com", image: nil))
        allPersons.append(Person(name: "Dennis", phone: nil, email: nil, image: nil))
        allPersons[0].favorited = true
    }
}
