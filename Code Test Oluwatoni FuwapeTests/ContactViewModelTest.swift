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
    var contactVM: ContactViewModel?
    
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
        XCTAssertEqual(contactVM?.firstname, firstname, "Test firstname")
        XCTAssertEqual(contactVM?.lastname, lastname, "Test lastname")
        XCTAssertEqual(contactVM?.fullName, fullname, "Test fullname")
        XCTAssertEqual(contactVM?.hasMatchedDetail, false, "Detail message")
    }

    func testDetailEmail() {
        contactVM = ContactViewModel(contact: contactModel, query: "em.com", foundAddress: false, foundPhoneNumber: false, foundEmail: true)
        XCTAssertEqual(contactVM?.firstname, firstname, "Test firstname")
        XCTAssertEqual(contactVM?.lastname, lastname, "Test lastname")
        XCTAssertEqual(contactVM?.fullName, fullname, "Test fullname")
        XCTAssertEqual(contactVM?.hasMatchedDetail, true, "Found Email Detail message")
        XCTAssertEqual(contactVM?.matchedDetail.string, email, "Email Detail message")
    }
    
    func testDetailPhoneNum() {
        contactVM = ContactViewModel(contact: contactModel, query: "204", foundAddress: false, foundPhoneNumber: true, foundEmail: false)
        XCTAssertEqual(contactVM?.firstname, firstname, "Test firstname")
        XCTAssertEqual(contactVM?.lastname, lastname, "Test lastname")
        XCTAssertEqual(contactVM?.fullName, fullname, "Test fullname")
        XCTAssertEqual(contactVM?.hasMatchedDetail, true, "Found PhoneNum detail message")
        XCTAssertEqual(contactVM?.matchedDetail.string, phoneNum, "PhoneNum Detail message")
    }

    func testDetailAddress() {
        contactVM = ContactViewModel(contact: contactModel, query: "e", foundAddress: true, foundPhoneNumber: false, foundEmail: false)
        XCTAssertEqual(contactVM?.firstname, firstname, "Test firstname")
        XCTAssertEqual(contactVM?.lastname, lastname, "Test lastname")
        XCTAssertEqual(contactVM?.fullName, fullname, "Test fullname")
        XCTAssertEqual(contactVM?.hasMatchedDetail, true, "Found Address detail message")
        XCTAssertEqual(contactVM?.matchedDetail.string, add, "Address Detail message")
    }
}
