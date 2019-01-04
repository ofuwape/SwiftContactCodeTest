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
        do{
            let realm = try Realm()
            // Save your object
            realm.beginWrite()
            realm.add(mContact)
        try realm.commitWrite()
        }catch{
            print("saveContact error")
        }
    }
    
    // Import Data
    func seedDB(){
        do{
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
            let realm = try Realm()
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
            try realm.commitWrite()
        }catch{
            print("seedDB contact")
        }
    }
    
    static func stringToDate(dateText: String) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM dd, yyyy"
        return dateFormatter.date(from: dateText) ?? Date()
    }
    
    func fetchAll(realmDelegate: RealmUtilDelegate){
        // Multi-threading
        DispatchQueue.global().async {
            autoreleasepool {
                do{
                    let realm = try Realm()
                    realmDelegate.foundResults(searchResults: Array(realm.objects(Contact.self).sorted(byKeyPath: "firstname", ascending: true)))
                }catch{
                    print("fetchAll error")
                }
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
                
                do{
                    let realm = try Realm()
                    
                    let nameQuery: String = String(format: "firstname contains[cd] '%@' OR lastname contains[cd] '%@'", mQuery,mQuery)
                    let nameResults = self.getResultsForQuery(realm: realm, queryPredicate: nameQuery)
                   
                    let emailQuery: String = String(format: "any emails.text contains[cd] '%@'", mQuery)
                    let emailResults = self.getResultsForQuery(realm: realm, queryPredicate: emailQuery)
                    
                    let addQuery: String = String(format: "any addresses.text contains[cd] '%@'", mQuery)
                    let addResults = self.getResultsForQuery(realm: realm, queryPredicate: addQuery)
                    
                    let phoneNumQuery: String = String(format: "any phoneNumbers.text contains[cd] '%@'", mQuery)
                    let phoneNumResults = self.getResultsForQuery(realm: realm, queryPredicate: phoneNumQuery)
                    
                    
                    realmDelegate.foundResults(query: mQuery, nameResults: Array(nameResults), addressResults: Array(addResults), phoneNumResults: Array(phoneNumResults), emailResults: Array(emailResults))
                }catch{
                    print("fetchByQuery error")
                }
            }
        }
    }
    
    func getResultsForQuery(realm: Realm, queryPredicate: String) -> Results<Contact>{
        let queryPredicate: NSPredicate = NSPredicate(format: queryPredicate)
        return realm.objects(Contact.self).filter(queryPredicate).sorted(byKeyPath: "firstname", ascending: true)
    }
    
    func fechItem(id: String, delegate: RealmUtilSingleFetchDelegate){
        DispatchQueue.global().async {
            autoreleasepool {
                do{
                    let realm = try Realm()
                    let contact = realm.object(ofType: Contact.self, forPrimaryKey: id)
                    delegate.foundItem(contact: contact)
                }catch{
                    print("fechItem error")
                }
            }
        }
    }
    
    func deleteItem(id: String, delegate: RealmUtilSaveDeleteDelegate){
        DispatchQueue.global().async {
            autoreleasepool {
                do{
                    let realm = try Realm()
                    if let contact = realm.object(ofType: Contact.self, forPrimaryKey: id){
                        realm.beginWrite()
                        realm.delete(contact)
                        try realm.commitWrite()
                        delegate.deleteComplete()
                    }
                }catch{
                    print("deleteItem error")
                }
            }
        }
    }
    
    func saveItem(contactVM: ContactViewModel, delegate: RealmUtilSaveDeleteDelegate, isNew: Bool){
        DispatchQueue.global().async {
            autoreleasepool {
                do{
                    var contact: Contact = Contact()
                    contact = contact.fromContactViewModel(contactVM: contactVM)
                    let realm = try Realm()
                    realm.beginWrite()
                    if !isNew, let contactFound = realm.object(ofType: Contact.self, forPrimaryKey: contactVM.primaryKey){
                        contactFound.firstname = contact.firstname
                        contactFound.lastname = contact.lastname
                        contactFound.dateOfBirth = contact.dateOfBirth
                        
                        contactFound.emails?.removeAll()
                        contactFound.emails?.append(objectsIn:  Array(contactVM.emails.filter{ !$0.isEmpty } ).map { emailItem in
                            return EmailModel(emailText: emailItem)
                        })
                        
                        contactFound.phoneNumbers?.removeAll()
                        contactFound.phoneNumbers?.append(objectsIn:  Array(contactVM.phoneNumbers.filter{ !$0.isEmpty } ).map { phoneItem in
                            return PhoneNumberModel(phoneNumText: phoneItem)
                        })
                        
                        contactFound.addresses?.removeAll()
                        contactFound.addresses?.append(objectsIn:  Array(contactVM.addresses.filter{ !$0.isEmpty } ).map { addItem in
                            return AddressModel(addText: addItem)
                        })
                        realm.add(contactFound)
                    }else{
                        realm.add(contact)
                    }
                    try realm.commitWrite()
                }catch{
                    print("Error saveItem")
                }
                delegate.saveComplete()
            }
        }
    }
    
}

protocol RealmUtilDelegate: class {
    func foundResults(searchResults: [Contact])
    func foundResults(query: String, nameResults: [Contact], addressResults: [Contact], phoneNumResults: [Contact], emailResults: [Contact])
}

protocol RealmUtilSaveDeleteDelegate: class {
    func deleteComplete()
    func saveComplete()
}

protocol RealmUtilSingleFetchDelegate: class {
    func foundItem(contact: Contact?)
}
