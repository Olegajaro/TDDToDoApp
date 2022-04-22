//
//  NewTaskViewControllerTests.swift
//  TDDToDoAppTests
//
//  Created by Олег Федоров on 22.04.2022.
//

import XCTest
@testable import TDDToDoApp

class NewTaskViewControllerTests: XCTestCase {
    
    var sut: NewTaskViewController!

    override func setUpWithError() throws {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        sut = storyboard.instantiateViewController(
            withIdentifier: String(describing: NewTaskViewController.self)
        ) as? NewTaskViewController
        sut.loadViewIfNeeded()
        
    }

    override func tearDownWithError() throws {
        sut = nil
    }

    func test_Has_TitleTextField() {
        XCTAssertTrue(sut.titleTextField.isDescendant(of: sut.view))
    }
    
    func test_Has_LocationTextField() {
        XCTAssertTrue(sut.locationTextField.isDescendant(of: sut.view))
    }
    
    func test_Has_DateTextField() {
        XCTAssertTrue(sut.dateTextField.isDescendant(of: sut.view))
    }
    
    func test_Has_AdressTextField() {
        XCTAssertTrue(sut.adressTextField.isDescendant(of: sut.view))
    }
    
    func test_Has_DescriptionTextField() {
        XCTAssertTrue(sut.descriptionTextField.isDescendant(of: sut.view))
    }
    
    func test_Has_SaveButton() {
        XCTAssertTrue(sut.saveButton.isDescendant(of: sut.view))
    }
    
    func test_Has_CancelButton() {
        XCTAssertTrue(sut.cancelButton.isDescendant(of: sut.view))
    }
}
