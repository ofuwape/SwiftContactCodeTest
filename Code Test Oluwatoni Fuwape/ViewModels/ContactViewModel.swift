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
    var matchedDetail: NSMutableAttributedString = NSMutableAttributedString()
    
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
    
    fileprivate func getAttributedDetail(query: String, detailText: String) -> NSMutableAttributedString{
        let attrStr = NSMutableAttributedString(string: detailText)
        let inputLength = attrStr.string.count
        let searchString = query
        let searchLength = searchString.count
        var range = NSRange(location: 0, length: attrStr.length)
        
        while (range.location != NSNotFound) {
            range = (attrStr.string as NSString).range(of: searchString, options: [], range: range)
            if (range.location != NSNotFound) {
                attrStr.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.black, range: NSRange(location: range.location, length: searchLength))
                range = NSRange(location: range.location + range.length, length: inputLength - (range.location + range.length))
            }
        }
        return attrStr
    }
    
    fileprivate mutating func setUpMatchedDetail(query: String, foundAddress: Bool, foundPhoneNumber: Bool, foundEmail: Bool){
        
        if foundEmail, let emails = self.emails {
            for email: EmailModel in emails{
                if email.text.range(of:query) != nil {
                    self.matchedDetail = getAttributedDetail(query: query, detailText: email.text)
                    self.hasMatchedDetail = true
                    return
                }
            }
        }
        
        if foundPhoneNumber, let phoneNumbers = self.phoneNumbers {
            for phoneNum: PhoneNumberModel in phoneNumbers{
                if phoneNum.text.range(of:query) != nil {
                    self.matchedDetail = getAttributedDetail(query: query, detailText: phoneNum.text)
                    self.hasMatchedDetail = true
                    return
                }
            }
        }
        
        if foundAddress, let addresses = self.addresses {
            for add: AddressModel in addresses{
                if add.text.range(of:query) != nil {
                    self.matchedDetail = getAttributedDetail(query: query, detailText: add.text)
                    self.hasMatchedDetail = true
                    return
                }
            }
        }
    }
    
    
}
