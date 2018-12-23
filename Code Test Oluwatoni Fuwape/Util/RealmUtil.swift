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
        
        let dateFormatter = DateFormatter()
        dateFormatter.locale = NSLocale(localeIdentifier: "en_US_POSIX") as Locale
        dateFormatter.dateFormat = "MMMM dd, yyyy"
        dateFormatter.timeZone = NSTimeZone(forSecondsFromGMT: 0) as TimeZone
        
        resetDB()
        let realm = try! Realm()
        realm.beginWrite()
        
        // Add Contact objects in realm for every contacts dictionary in JSON array
        for mContactDict: Any in contactDicts! {
            if let contactDict = mContactDict as? Dictionary<String, String>{
                
                let contact = Contact()
                contact.firstname = contactDict["firstname"]
                contact.lastname = contactDict["lastname"]
                contact.dateOfBirth = dateFormatter.date(from: contactDict["dateOfBirth"] ?? "")
                
                if let addresses = contactDict["addresses"]{
                    contact.addresses?.append(objectsIn: addresses.components(separatedBy: "|"))
                }
                if let phoneNumbers = contactDict["phoneNumbers"]{
                    contact.phoneNumbers?.append(objectsIn: phoneNumbers.components(separatedBy: "|"))
                }
                if let emails = contactDict["emails"]{
                    contact.emails?.append(objectsIn: emails.components(separatedBy: "|"))
                }
                
                realm.add(contact)
                
            }
        }
        try! realm.commitWrite()
        //        // Print all contacts from realm
        //        for contact: Contact? in Cont {
        //            if let aContact = contact {
        //                print("contact persisted to realm: \(aContact)")
        //            }
        //        }
    }
    
    func fetchAll(realmDelegate: RealmUtilDelegate){
        // Multi-threading
        DispatchQueue.global().async {
            autoreleasepool {
                let realm = try! Realm()
                realmDelegate.foundResults(searchResults: realm.objects(Contact.self))
            }
        }
    }
        
    func fetchByQuery(realmDelegate: RealmUtilDelegate, query: String){
        DispatchQueue.global().async {
            autoreleasepool {
                let realm = try! Realm()
                let queryFormat: String = String(format: "firstname contains '%@' OR lastname contains '%@'", query,query)
                let queryPredicate: NSPredicate = NSPredicate(format: queryFormat)

                let results = realm.objects(Contact.self).filter(queryPredicate)
                realmDelegate.foundResults(searchResults: results)
            }
        }
    }
    
}

protocol RealmUtilDelegate: class {
    func foundResults(searchResults: Results<Contact>)
}
