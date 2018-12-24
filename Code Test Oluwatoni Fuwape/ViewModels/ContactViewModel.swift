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
    
    var firstname: String? = ""
    var lastname: String? = ""
    var dOB: String = ""
    var fullName: String = ""
    
    var hasMatchedDetail: Bool = false
    var matchedDetail: NSMutableAttributedString = NSMutableAttributedString()
    
    var addresses: [String]? = []
    var phoneNumbers: [String]? = []
    var emails: [String]? = []
    
}

extension ContactViewModel {
    
    init(contact :Contact) {
        self.firstname = contact.firstname
        self.lastname = contact.lastname
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM dd, yyyy"
        if let date = contact.dateOfBirth{
          self.dOB = dateFormatter.string(from: date)
        }
        
        let addressItems: [AddressModel] = Array(contact.addresses ?? List())
        self.addresses = addressItems.map { addressItem in
            return addressItem.text
        }
        
        let phoneNumItems: [PhoneNumberModel] = Array(contact.phoneNumbers ?? List())
        self.phoneNumbers = phoneNumItems.map { phoneNumItem in
            return phoneNumItem.text
        }
        
        let emailItems: [EmailModel] = Array(contact.emails ?? List())
        self.emails = emailItems.map { emailItem in
            return emailItem.text
        }
        
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
            for email: String in emails{
                if email.lowercased().range(of:query) != nil {
                    self.matchedDetail = getAttributedDetail(query: query, detailText: email.lowercased())
                    self.hasMatchedDetail = true
                    return
                }
            }
        }
        
        if foundPhoneNumber, let phoneNumbers = self.phoneNumbers {
            for phoneNum: String in phoneNumbers{
                if phoneNum.lowercased().range(of:query) != nil {
                    self.matchedDetail = getAttributedDetail(query: query, detailText: phoneNum.lowercased())
                    self.hasMatchedDetail = true
                    return
                }
            }
        }
        
        if foundAddress, let addresses = self.addresses {
            for add: String in addresses{
                if add.lowercased().range(of:query) != nil {
                    self.matchedDetail = getAttributedDetail(query: query, detailText: add.lowercased())
                    self.hasMatchedDetail = true
                    return
                }
            }
        }
    }
    
    
}
