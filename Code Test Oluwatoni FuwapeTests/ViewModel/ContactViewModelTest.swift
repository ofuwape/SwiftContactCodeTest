//
//  ContactViewModelTest.swift
//  Code Test Oluwatoni FuwapeTests
//
//  Created by Toni Fuwape on 12/24/18.
//  Copyright © 2018 Oluwatoni Fuwape. All rights reserved.
//

import XCTest
import RealmSwift
@testable import Code_Test_Oluwatoni_Fuwape

class ContactViewModelTest: XCTestCase {

    var contactModel: Contact = Contact()
    var contactVM: ContactViewModel = ContactViewModel()
    
    let firstname: String = "first"
    let lastname: String = "last"
    var fullname: String = ""
    let email: String = "em@em.com"
    let phoneNum: String = "2048074457"
    let add: String = "20 Naso Street. W Avenue"
    let date: Date =  Date()
    
    override func setUp() {
        fullname = String(format: "%@ %@",firstname,lastname)
        contactModel.firstname = firstname
        contactModel.lastname = lastname
        contactModel.dateOfBirth = Date()
        
        let emailModel: EmailModel = EmailModel(emailText: email)
        contactModel.emails?.append(emailModel)
        
        let addModel: AddressModel = AddressModel(addText: add)
        contactModel.addresses?.append(addModel)
        
        let phoneNumModel: PhoneNumberModel = PhoneNumberModel(phoneNumText: phoneNum)
        contactModel.phoneNumbers?.append(phoneNumModel)
    
    }

    override func tearDown() {
        // no-op
    }

    func testDefaultViewModel() {
        contactVM = ContactViewModel(contact: contactModel)
        XCTAssertEqual(contactVM.firstname, firstname, "Test firstname")
        XCTAssertEqual(contactVM.lastname, lastname, "Test lastname")
        XCTAssertEqual(contactVM.fullName, fullname, "Test fullname")
        XCTAssertEqual(contactVM.hasMatchedDetail, false, "Detail message")
    }

    func testDetailEmail() {
        contactVM = ContactViewModel(contact: contactModel, query: "em.com", foundAddress: false, foundPhoneNumber: false, foundEmail: true)
        XCTAssertEqual(contactVM.firstname, firstname, "Test firstname")
        XCTAssertEqual(contactVM.lastname, lastname, "Test lastname")
        XCTAssertEqual(contactVM.fullName, fullname, "Test fullname")
        XCTAssertEqual(contactVM.hasMatchedDetail, true, "Found Email Detail message")
        XCTAssertEqual(contactVM.matchedDetail.string, email, "Email Detail message")
    }
    
    func testDetailPhoneNum() {
        contactVM = ContactViewModel(contact: contactModel, query: "204", foundAddress: false, foundPhoneNumber: true, foundEmail: false)
        XCTAssertEqual(contactVM.firstname, firstname, "Test firstname")
        XCTAssertEqual(contactVM.lastname, lastname, "Test lastname")
        XCTAssertEqual(contactVM.fullName, fullname, "Test fullname")
        XCTAssertEqual(contactVM.hasMatchedDetail, true, "Found PhoneNum detail message")
        XCTAssertEqual(contactVM.matchedDetail.string, phoneNum, "PhoneNum Detail message")
    }

    func testDetailAddress() {
        contactVM = ContactViewModel(contact: contactModel, query: "e", foundAddress: true, foundPhoneNumber: false, foundEmail: false)
        XCTAssertEqual(contactVM.firstname, firstname, "Test firstname")
        XCTAssertEqual(contactVM.lastname, lastname, "Test lastname")
        XCTAssertEqual(contactVM.fullName, fullname, "Test fullname")
        XCTAssertEqual(contactVM.hasMatchedDetail, true, "Found Address detail message")
        XCTAssertEqual(contactVM.matchedDetail.string, add.lowercased(), "Address Detail message")
    }
    
    func testSameModels(){
        contactVM = ContactViewModel(contact: contactModel)
        XCTAssertTrue(contactVM.isSame(newContactVM: contactVM))
        XCTAssertFalse(contactVM.isSame(newContactVM: ContactViewModel(contact: Contact())))
        
        var contactVMEmail = contactVM
        contactVMEmail.emails.append("b@bb.com")
        XCTAssertFalse(contactVM.isSame(newContactVM: contactVMEmail))
        
        var contactVMAdd = contactVM
        contactVMAdd.addresses.append("F Street")
        XCTAssertFalse(contactVM.isSame(newContactVM: contactVMAdd))
        
        var contactVMPhone = contactVM
        contactVMPhone.phoneNumbers.append("4564909989")
        XCTAssertFalse(contactVM.isSame(newContactVM: contactVMPhone))
        
        var contactVMDOB = contactVM
        contactVMDOB.dOB = ""
        XCTAssertFalse(contactVM.isSame(newContactVM: contactVMDOB))
    }
    
    func testVMHasRequiredFields(){
        contactVM = ContactViewModel(contact: contactModel)
        XCTAssertTrue(contactVM.hasRequiredData())
        
        contactVM.addresses = []
        XCTAssertTrue(contactVM.hasRequiredData())
        
        contactVM = ContactViewModel(contact: contactModel)
        contactVM.emails = []
        XCTAssertFalse(contactVM.hasRequiredData())
        
        contactVM = ContactViewModel(contact: contactModel)
        contactVM.phoneNumbers = []
        XCTAssertFalse(contactVM.hasRequiredData())
        
        contactVM = ContactViewModel(contact: contactModel)
        contactVM.firstname = ""
        XCTAssertFalse(contactVM.hasRequiredData())
        
        contactVM = ContactViewModel(contact: contactModel)
        contactVM.lastname = ""
        XCTAssertFalse(contactVM.hasRequiredData())
        
        contactVM = ContactViewModel(contact: contactModel)
        contactVM.dOB = ""
        XCTAssertFalse(contactVM.hasRequiredData())
    }
    
    func testToContact(){
        contactVM = ContactViewModel(contact: contactModel)
        var newContact: Contact = Contact()
        newContact = newContact.fromContactViewModel(contactVM: contactVM)
        XCTAssertTrue(contactModel.firstname == newContact.firstname)
        XCTAssertTrue(contactModel.lastname == newContact.lastname)
    }
    
}
