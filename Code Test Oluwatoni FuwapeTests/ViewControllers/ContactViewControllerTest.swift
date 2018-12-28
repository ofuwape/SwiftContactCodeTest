//
//  ContactViewControllerTest.swift
//  Code Test Oluwatoni FuwapeTests
//
//  Created by Toni Fuwape on 12/28/18.
//  Copyright © 2018 Oluwatoni Fuwape. All rights reserved.
//

import XCTest
import RealmSwift
@testable import Code_Test_Oluwatoni_Fuwape

class ContactViewControllerTest: XCTestCase {

    var contactVC: ContactViewController?
    override func setUp() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        contactVC = storyboard.instantiateViewController(withIdentifier: "ContactViewController") as? ContactViewController
        _ = contactVC?.view // To call viewDidLoad
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testDefaultProperties() {
        XCTAssertNotNil(contactVC?.searchBar)
        XCTAssertNotNil(contactVC?.collectionView)
        XCTAssertNotNil(contactVC?.noResultsLabel)
        XCTAssertTrue(contactVC?.itemsPerRow == 1)
        XCTAssertTrue(contactVC?.numOfSections == 1)
        XCTAssertNotNil(contactVC?.navigationItem.rightBarButtonItem)
    }
    
    func testResultsLoad() {
        
        contactVC?.foundResults(searchResults: [])
        XCTAssertTrue(contactVC?.contactResults.count == 0)
        
        let result = [Contact()]
        contactVC?.foundResults(searchResults: result)
        XCTAssertTrue(contactVC?.contactResults.count == 1)
        
        contactVC?.foundResults(query: "okay", nameResults: result, addressResults: result, phoneNumResults: result, emailResults: result)
        XCTAssertTrue(contactVC?.contactResults.count == 4)
        
    }

}
