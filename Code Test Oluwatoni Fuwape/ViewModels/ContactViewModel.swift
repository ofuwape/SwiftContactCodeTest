//
//  ContactViewModel.swift
//  Code Test Oluwatoni Fuwape
//
//  Created by Toni Fuwape on 12/22/18.
//  Copyright © 2018 Oluwatoni Fuwape. All rights reserved.
//

import Foundation

struct ContactViewModel {
    
    var firstname: String?
    var lastname: String?
    var fullName: String
    
}

extension ContactViewModel {
    
    init(contact :Contact) {
        self.firstname = contact.firstname
        self.lastname = contact.lastname
        self.fullName = String(format: "%@ %@",contact.firstname ?? "",contact.lastname ?? "")
    }
}
