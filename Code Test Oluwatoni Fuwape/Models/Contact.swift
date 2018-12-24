//
//  Contact.swift
//  Code Test Oluwatoni Fuwape
//
//  Created by Toni Fuwape on 12/18/18.
//  Copyright © 2018 Oluwatoni Fuwape. All rights reserved.
//

import Foundation
import RealmSwift

class Contact: Object{
    @objc dynamic var firstname: String? = ""
    @objc dynamic var lastname: String? = ""
    @objc dynamic var dateOfBirth: Date? = nil
    var addresses: List<AddressModel>? = List<AddressModel>()
    var phoneNumbers: List<PhoneNumberModel>? = List<PhoneNumberModel>()
    var emails: List<EmailModel>? = List<EmailModel>()
    
}
