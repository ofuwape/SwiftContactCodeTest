//
//  Code_TestOluwatoni_FuwapeUITests.swift
//  Code TestOluwatoni FuwapeUITests
//
//  Created by Toni Fuwape on 12/28/18.
//  Copyright © 2018 Oluwatoni Fuwape. All rights reserved.
//

import XCTest
@testable import Code_Test_Oluwatoni_Fuwape

class Code_TestOluwatoni_FuwapeUITests: XCTestCase {

    let app: XCUIApplication = XCUIApplication()
    
    override func setUp() {
        continueAfterFailure = false
        app.launch()
    }
    
    func testContactViewControllerUI() {
        XCTAssertNotNil(app.collectionViews)
        XCTAssertTrue(app.collectionViews.count == 1)
        XCTAssertNotNil(app.searchFields)
        XCTAssertTrue(app.searchFields.count == 1)
        
        XCTAssertNotNil(app.searchFields["Search"])
        app.searchFields["Search"].tap()
        app.searchFields["Search"].typeText("a")

        let queryLabel = app.staticTexts.element(boundBy: 4).label
        XCTAssert(queryLabel.contains("a"))
        
        app.navigationBars.buttons.element(boundBy: 0).tap()
    }
    
    func testDetailControllerClick(){
        app.collectionViews.cells.element(boundBy:0).tap()
        let detailTable = app.tables.matching(identifier: "DetailTableId")
        XCTAssertNotNil(detailTable)
        XCTAssertTrue(detailTable.cells.count >= 4)
        
        //test edit button
        app.navigationBars.buttons.element(boundBy: 0).tap()
        let updateTable = app.tables.matching(identifier: "UpdateTableId")
        XCTAssertNotNil(updateTable)
    }
    
    func testUpdateController(){
        app.navigationBars.buttons.element(boundBy: 0).tap()
        let myTable = app.tables.matching(identifier: "UpdateTableId")
        XCTAssertNotNil(myTable)
        XCTAssert(app.textFields["FirstName"].exists)
        XCTAssert(app.textFields["LastName"].exists)
        XCTAssert(app.textFields["Add Phone Number"].exists)
        XCTAssert(app.textFields["Add Email"].exists)
        XCTAssert(app.textFields["Pick BirthDate"].exists)
        XCTAssert(app.textFields["Add Address"].exists)
        
        // Add rows
        app.textFields["Add Phone Number"].tap()
        XCTAssert(app.textFields["Phone Number"].exists)
        
        app.textFields["Add Email"].tap()
        XCTAssert(app.textFields["Email"].exists)
        
        app.textFields["Add Address"].tap()
        XCTAssert(app.textFields["Address"].exists)
        
        // delete rows
        XCTAssert(app.images["DeleteRowSection_1"].exists)
        app.images["DeleteRowSection_1"].tap()
        XCTAssertFalse(!app.textFields["Phone Number"].exists)
        
        XCTAssert(app.images["DeleteRowSection_2"].exists)
        app.images["DeleteRowSection_2"].tap()
        XCTAssertFalse(!app.textFields["Email"].exists)
        
        XCTAssert(app.images["DeleteRowSection_4"].exists)
        app.images["DeleteRowSection_4"].tap()

    }
    
    func testUpdateControllerCancel(){
        app.navigationBars.buttons.element(boundBy: 0).tap()
        let myTable = app.tables.matching(identifier: "UpdateTableId")
        XCTAssertNotNil(myTable)
        app.navigationBars.buttons.element(boundBy: 0).tap()
    }
    
}
