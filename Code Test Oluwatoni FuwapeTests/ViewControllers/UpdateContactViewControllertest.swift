//
//  UpdateContactViewControllertest.swift
//  Code Test Oluwatoni FuwapeTests
//
//  Created by Toni Fuwape on 12/28/18.
//  Copyright © 2018 Oluwatoni Fuwape. All rights reserved.
//

import XCTest
import RealmSwift
@testable import Code_Test_Oluwatoni_Fuwape

class UpdateContactViewControllertest: XCTestCase {

    var updateVC: UpdateContactViewController?

    override func setUp() {
        updateVC = UpdateContactViewController()
        updateVC?.contactVM = ContactViewModel()
        _ = updateVC?.view // To call viewDidLoad
        updateVC?.updateContactView?.updateContactTableView.reloadData()
    }

    func testDefaultProperties() {
        XCTAssertNotNil(updateVC?.updateContactView)
        XCTAssertNotNil(updateVC?.updateContactView?.updateContactTableView)
        XCTAssertNotNil(updateVC?.contactModel)
        XCTAssertNotNil(updateVC?.initialContactVM)
        XCTAssertTrue(updateVC?.numOfSections == 6)
        XCTAssertTrue(updateVC?.cellIdentifier == "UpdateCell")
        XCTAssertTrue(updateVC?.deleteCellIdentifier == "DeleteCell")
        XCTAssertNotNil(updateVC?.realmUtil)
        XCTAssertNotNil(updateVC?.datePicker)
    }
    
    func testViewValues(){
        updateVC?.contactVM.firstname = "firstname"
        updateVC?.contactVM.lastname = "lastame"
        updateVC?.contactVM.fullName = "firstname lastame"
        updateVC?.contactVM.dOB = ContactViewModel.dateToString(date: Date())
        updateVC?.contactVM.emails = ["e@e.com"]
        updateVC?.contactVM.phoneNumbers = ["1110002929"]
        updateVC?.contactVM.addresses = ["ok ok ok"]
        updateVC?.updateContactView?.updateContactTableView.reloadData()
        
        let cellFirstName = updateVC?.updateContactView?.updateContactTableView.cellForRow(at: IndexPath(row: 0, section: UpdateSectionType.Name.rawValue)) as? UpdateCellView
        XCTAssertNotNil(cellFirstName)
        XCTAssertTrue(cellFirstName?.textField.text == updateVC?.contactVM.firstname)
        
        let cellLastName = updateVC?.updateContactView?.updateContactTableView.cellForRow(at: IndexPath(row: 1, section: UpdateSectionType.Name.rawValue)) as? UpdateCellView
        XCTAssertNotNil(cellLastName)
        XCTAssertTrue(cellLastName?.textField.text == updateVC?.contactVM.lastname)
        
        let cellPhone = updateVC?.updateContactView?.updateContactTableView.cellForRow(at: IndexPath(row: 0, section: UpdateSectionType.PhoneNum.rawValue)) as? UpdateCellView
        XCTAssertNotNil(cellPhone)
        XCTAssertTrue(cellPhone?.textField.text == updateVC?.contactVM.phoneNumbers[0])
        
        let cellEmail = updateVC?.updateContactView?.updateContactTableView.cellForRow(at: IndexPath(row: 0, section: UpdateSectionType.Email.rawValue)) as? UpdateCellView
        XCTAssertNotNil(cellEmail)
        XCTAssertTrue(cellEmail?.textField.text == updateVC?.contactVM.emails[0])
        
        let cellAddress = updateVC?.updateContactView?.updateContactTableView.cellForRow(at: IndexPath(row: 0, section: UpdateSectionType.Address.rawValue)) as? UpdateCellView
        XCTAssertNotNil(cellAddress)
        XCTAssertTrue(cellAddress?.textField.text == updateVC?.contactVM.addresses[0])
        
    }
    
}
