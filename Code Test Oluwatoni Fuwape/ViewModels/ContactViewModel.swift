//
//  ContactViewModel.swift
//  Code Test Oluwatoni Fuwape
//
//  Created by Toni Fuwape on 12/22/18.
//  Copyright © 2018 Oluwatoni Fuwape. All rights reserved.
//

import Foundation
import RealmSwift

struct ContactViewModel {
    
    var firstname: String?
    var lastname: String?
    var fullName: String
    
    var hasMatchedDetail: Bool = false
    var matchedDetail: String = ""
    
    var addresses: List<AddressModel>? = List<AddressModel>()
    var phoneNumbers: List<PhoneNumberModel>? = List<PhoneNumberModel>()
    var emails: List<EmailModel>? = List<EmailModel>()
    
}

extension ContactViewModel {
    
    init(contact :Contact) {
        self.firstname = contact.firstname
        self.lastname = contact.lastname
        self.addresses = contact.addresses
        self.phoneNumbers = contact.phoneNumbers
        self.emails = contact.emails
        self.fullName = String(format: "%@ %@",contact.firstname ?? "",contact.lastname ?? "")
    }
    
    init(contact :Contact, query: String, foundAddress: Bool, foundPhoneNumber: Bool, foundEmail: Bool) {
        self.init(contact: contact)
        setUpMatchedDetail(query: query, foundAddress: foundAddress,foundPhoneNumber: foundPhoneNumber, foundEmail: foundEmail)
    
    }
    
    fileprivate mutating func setUpMatchedDetail(query: String, foundAddress: Bool, foundPhoneNumber: Bool, foundEmail: Bool){
        
        if foundEmail, let emails = self.emails {
            for email: EmailModel in emails{
                if email.text.range(of:query) != nil {
                    self.matchedDetail = email.text
                    self.hasMatchedDetail = true
                    return
                }
            }
        }
        
        if foundPhoneNumber, let phoneNumbers = self.phoneNumbers {
            for phoneNum: PhoneNumberModel in phoneNumbers{
                if phoneNum.text.range(of:query) != nil {
                    self.matchedDetail = phoneNum.text
                    self.hasMatchedDetail = true
                    return
                }
            }
        }
        
        if foundAddress, let addresses = self.addresses {
            for add: AddressModel in addresses{
                if add.text.range(of:query) != nil {
                    self.matchedDetail = add.text
                    self.hasMatchedDetail = true
                    return
                }
            }
        }
    }
    
    
}
