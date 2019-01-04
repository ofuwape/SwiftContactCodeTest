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
    @objc dynamic var id: String = NSUUID().uuidString
    
    var addresses: List<AddressModel>? = List<AddressModel>()
    var phoneNumbers: List<PhoneNumberModel>? = List<PhoneNumberModel>()
    var emails: List<EmailModel>? = List<EmailModel>()
    
    override static func primaryKey() -> String? {
        return "id"
    }

    func fromContactViewModel(contactVM: ContactViewModel) -> Contact{
        self.firstname = ContactViewModel.trimText(text: contactVM.firstname)
        self.lastname = ContactViewModel.trimText(text: contactVM.lastname)
        self.dateOfBirth = RealmUtils.stringToDate(dateText: contactVM.dOB)
        
        self.emails?.append(objectsIn:  Array(ContactViewModel.cleanList(items:  contactVM.emails)).map { emailItem in
            return EmailModel(emailText: emailItem)
        })
        self.phoneNumbers?.append(objectsIn:  Array(ContactViewModel.cleanList(items: contactVM.phoneNumbers)).map { phoneNumItem in
            return PhoneNumberModel(phoneNumText: phoneNumItem)
        })
        self.addresses?.append(objectsIn:  Array(ContactViewModel.cleanList(items: contactVM.addresses)).map { addItem in
            return AddressModel(addText: addItem)
        })
        self.id = contactVM.primaryKey
        return self
    }
    
}
