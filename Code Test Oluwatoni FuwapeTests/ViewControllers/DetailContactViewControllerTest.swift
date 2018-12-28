//
//  DetailContactViewControllerTest.swift
//  Code Test Oluwatoni FuwapeTests
//
//  Created by Toni Fuwape on 12/28/18.
//  Copyright © 2018 Oluwatoni Fuwape. All rights reserved.
//

import XCTest
import RealmSwift
@testable import Code_Test_Oluwatoni_Fuwape

class DetailContactViewControllerTest: XCTestCase {

    var detailVC: DetailContactViewController?
    
    override func setUp() {
        detailVC = DetailContactViewController()
        detailVC?.contactVM = ContactViewModel()
        _ = detailVC?.view // To call viewDidLoad
        detailVC?.detailContactView?.detailTableView.reloadData()
    }

    func testDefaultProperties() {
        XCTAssertNotNil(detailVC?.detailContactView)
        XCTAssertNotNil(detailVC?.detailContactView?.detailTableView)
        XCTAssertNotNil(detailVC?.contactVM)
        XCTAssertTrue(detailVC?.cellIdentifier == "DetailCell")
        XCTAssertTrue(detailVC?.numOfSections == 4)
        XCTAssertNotNil(detailVC?.realmUtil)
        XCTAssertNotNil(detailVC?.navigationItem.rightBarButtonItem)
        
        XCTAssertTrue(detailVC?.detailContactView?.detailTableView.numberOfSections == 4)
    }
    
    func testViewValues(){
        detailVC?.contactVM?.firstname = "firstname"
        detailVC?.contactVM?.lastname = "lastame"
        detailVC?.contactVM?.fullName = "firstname lastame"
        detailVC?.contactVM?.dOB = ContactViewModel.dateToString(date: Date())
        detailVC?.contactVM?.emails = ["e@e.com"]
        detailVC?.contactVM?.phoneNumbers = ["1110002929"]
        detailVC?.contactVM?.addresses = ["ok ok ok"]
        detailVC?.detailContactView?.detailTableView.reloadData()
        detailVC?.configureData()
        
        XCTAssertTrue(detailVC?.detailContactView?.fullNameLabel.text == "firstname lastame")
        
        let cellPhone = detailVC?.detailContactView?.detailTableView.cellForRow(at: IndexPath(row: 0, section: SectionType.PhoneNum.rawValue))
        XCTAssertNotNil(cellPhone)
        XCTAssertTrue(cellPhone?.textLabel?.text == detailVC?.contactVM?.phoneNumbers[0])
        
        let cellEmail = detailVC?.detailContactView?.detailTableView.cellForRow(at: IndexPath(row: 0, section: SectionType.Email.rawValue))
        XCTAssertNotNil(cellEmail)
        XCTAssertTrue(cellEmail?.textLabel?.text == detailVC?.contactVM?.emails[0])
        
        let cellAddress = detailVC?.detailContactView?.detailTableView.cellForRow(at: IndexPath(row: 0, section: SectionType.Address.rawValue))
        XCTAssertNotNil(cellAddress)
        XCTAssertTrue(cellAddress?.textLabel?.text == detailVC?.contactVM?.addresses[0])
        
        detailVC?.foundItem(contact: Contact())
        detailVC?.configureData()
        XCTAssertTrue(detailVC?.detailContactView?.fullNameLabel.text == " ")

    }

}
