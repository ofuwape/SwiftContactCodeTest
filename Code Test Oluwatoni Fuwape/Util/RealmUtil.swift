//
//  RealmUtil.swift
//  Code Test Oluwatoni Fuwape
//
//  Created by Toni Fuwape on 12/21/18.
//  Copyright © 2018 Oluwatoni Fuwape. All rights reserved.
//

import Foundation
import RealmSwift

class RealmUtils{
    
    // Resets Realm DB
    func resetDB() {
//        print(Realm.Configuration.defaultConfiguration.fileURL!)
        do {
            try FileManager.default.removeItem(at: Realm.Configuration.defaultConfiguration.fileURL!)
        } catch {}
    }
    
    //  Write to Realm
    func saveContact(mContact: Contact) {
        let realm = try! Realm()
        // Save your object
        realm.beginWrite()
        realm.add(mContact)
        try! realm.commitWrite()
    }
    
    // Import Data
    func seedDB(){
        // Import JSON
        var contactDicts: [Any]?
        if let path = Bundle.main.path(forResource: "contacts", ofType: "json") {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                let jsonResult = try JSONSerialization.jsonObject(with: data, options: .mutableLeaves)
                if let mContactDicts = jsonResult as? [Any] {
                    contactDicts = mContactDicts
                }
            } catch {
                // handle error
            }
        }

        resetDB()
        let realm = try! Realm()
        realm.beginWrite()
        
        // Add Contact objects in realm for every contacts dictionary in JSON array
        for mContactDict: Any in contactDicts! {
            if let contactDict = mContactDict as? Dictionary<String, String>{
                
                let contact = Contact()
                contact.firstname = contactDict["firstname"]
                contact.lastname = contactDict["lastname"]
                contact.dateOfBirth = RealmUtils.stringToDate(dateText: contactDict["dateOfBirth"] ?? "")
                
                if let addresses = contactDict["addresses"]{
                    for add in addresses.components(separatedBy: "|"){
                        let addModel: AddressModel  = AddressModel()
                        addModel.text = add
                      contact.addresses?.append(addModel)
                    }
                }
                
                if let phoneNumbers = contactDict["phoneNumbers"]{
                    for phoneNum in phoneNumbers.components(separatedBy: "|"){
                        let phoneNumModel: PhoneNumberModel  = PhoneNumberModel()
                        phoneNumModel.text = phoneNum
                        contact.phoneNumbers?.append(phoneNumModel)
                    }
                }
                if let emails = contactDict["emails"]{
                    for email in emails.components(separatedBy: "|"){
                        let emailModel: EmailModel  = EmailModel()
                        emailModel.text = email
                        contact.emails?.append(emailModel)
                    }
                }
                
                realm.add(contact)
                
            }
        }
        try! realm.commitWrite()
    }
    
    static func stringToDate(dateText: String) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = NSLocale(localeIdentifier: "en_US_POSIX") as Locale
        dateFormatter.dateFormat = "MMMM dd, yyyy"
        dateFormatter.timeZone = NSTimeZone(forSecondsFromGMT: 0) as TimeZone
        return dateFormatter.date(from: dateText) ?? Date()
    }
    
    func fetchAll(realmDelegate: RealmUtilDelegate){
        // Multi-threading
        DispatchQueue.global().async {
            autoreleasepool {
                let realm = try! Realm()
                realmDelegate.foundResults(searchResults: realm.objects(Contact.self).sorted(byKeyPath: "firstname", ascending: true))
            }
        }
    }
    
    // Removes non alphanumeric input and trims spaces
    func formatQuery(query: String)-> String{
        let unsafeChars = NSCharacterSet.alphanumerics.inverted
        return query.components(separatedBy: unsafeChars).joined(separator:"").trimmingCharacters(in: .whitespacesAndNewlines)
    }
        
    func fetchByQuery(realmDelegate: RealmUtilDelegate, query: String){
        let mQuery: String = formatQuery(query: query)
        DispatchQueue.global().async {
            autoreleasepool {
                let realm = try! Realm()
                
                let nameQuery: String = String(format: "firstname contains[cd] '%@' OR lastname contains[cd] '%@'", mQuery,mQuery)
                let nameResults = self.getResultsForQuery(realm: realm, queryPredicate: nameQuery)
               
                let emailQuery: String = String(format: "any emails.text contains[cd] '%@'", mQuery)
                let emailResults = self.getResultsForQuery(realm: realm, queryPredicate: emailQuery)
                
                let addQuery: String = String(format: "any addresses.text contains[cd] '%@'", mQuery)
                let addResults = self.getResultsForQuery(realm: realm, queryPredicate: addQuery)
                
                let phoneNumQuery: String = String(format: "any phoneNumbers.text contains[cd] '%@'", mQuery)
                let phoneNumResults = self.getResultsForQuery(realm: realm, queryPredicate: phoneNumQuery)
                
                
                realmDelegate.foundResults(query: mQuery, nameResults: nameResults, addressResults: addResults, phoneNumResults: phoneNumResults, emailResults: emailResults)
            }
        }
    }
    
    func getResultsForQuery(realm: Realm, queryPredicate: String) -> Results<Contact>{
        let queryPredicate: NSPredicate = NSPredicate(format: queryPredicate)
        return realm.objects(Contact.self).filter(queryPredicate).sorted(byKeyPath: "firstname", ascending: true)
    }
    
}

protocol RealmUtilDelegate: class {
    func foundResults(searchResults: Results<Contact>)
    func foundResults(query: String, nameResults: Results<Contact>, addressResults: Results<Contact>, phoneNumResults: Results<Contact>, emailResults: Results<Contact>)
}
