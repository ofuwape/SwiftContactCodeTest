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
    
    var firstname: String = ""
    var lastname: String = ""
    var dOB: String = ""
    var fullName: String = ""
    
    var hasMatchedDetail: Bool = false
    var matchedDetail: NSMutableAttributedString = NSMutableAttributedString()
    
    var addresses: [String] = []
    var phoneNumbers: [String] = []
    var emails: [String] = []
    var primaryKey: String = ""
    
}

extension ContactViewModel {
    
    init(contact :Contact) {
        self.firstname = contact.firstname ?? ""
        self.lastname = contact.lastname ?? ""
        self.fullName = String(format: "%@ %@",contact.firstname ?? "",contact.lastname ?? "")

        self.primaryKey = contact.id
        
        self.dOB = ContactViewModel.dateToString(date: contact.dateOfBirth)
        
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
    }
    
    init(contact :Contact, query: String, foundAddress: Bool, foundPhoneNumber: Bool, foundEmail: Bool) {
        self.init(contact: contact)
        setUpMatchedDetail(query: query, foundAddress: foundAddress,foundPhoneNumber: foundPhoneNumber, foundEmail: foundEmail)
    }
    
    static func dateToString(date: Date?) -> String{
        let mDate: Date = date ?? Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM dd, yyyy"
        return dateFormatter.string(from: mDate)
    }
    
    func hasRequiredData()-> Bool{
        let filteredEmails = ContactViewModel.cleanList(items: self.emails)
        let filteredPhoneNums = ContactViewModel.cleanList(items: self.phoneNumbers)
        return !ContactViewModel.trimText(text: firstname).isEmpty && !ContactViewModel.trimText(text: lastname).isEmpty && !filteredEmails.isEmpty && !filteredPhoneNums.isEmpty && !dOB.isEmpty
    }
    
    func isSame(newContactVM: ContactViewModel)-> Bool{
        return newContactVM.firstname == self.firstname
            && newContactVM.lastname == self.lastname
            && newContactVM.dOB == self.dOB
            && ContactViewModel.sameLists(itemsI: self.emails, itemsII: newContactVM.emails)
            && ContactViewModel.sameLists(itemsI: self.phoneNumbers, itemsII: newContactVM.phoneNumbers)
            && ContactViewModel.sameLists(itemsI: self.addresses, itemsII: newContactVM.addresses)
    }
    
    // Compares two lists of strings list
    static func sameLists(itemsI: [String], itemsII: [String]) -> Bool {
        return cleanList(items: itemsI) == cleanList(items: itemsII)
    }
    
    // Remove empty values from strings list
    static func cleanList(items: [String]) -> [String]{
        var itemsUpdate =  items.map(ContactViewModel.trimText)
        itemsUpdate = items.filter{ !$0.isEmpty }
        return itemsUpdate
    }
    
    // Remove whitespace and lines from text
    static func trimText(text: String) -> String{
        return text.trimmingCharacters(in: .whitespacesAndNewlines)
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
        
        if foundEmail {
            for email: String in emails{
                if email.lowercased().range(of:query) != nil {
                    self.matchedDetail = getAttributedDetail(query: query, detailText: email.lowercased())
                    self.hasMatchedDetail = true
                    return
                }
            }
        }
        
        if foundPhoneNumber {
            for phoneNum: String in phoneNumbers{
                if phoneNum.lowercased().range(of:query) != nil {
                    self.matchedDetail = getAttributedDetail(query: query, detailText: phoneNum.lowercased())
                    self.hasMatchedDetail = true
                    return
                }
            }
        }
        
        if foundAddress {
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
