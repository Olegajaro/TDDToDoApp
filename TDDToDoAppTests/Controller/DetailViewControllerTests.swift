//
//  DetailViewControllerTests.swift
//  TDDToDoAppTests
//
//  Created by Олег Федоров on 22.04.2022.
//

import XCTest
@testable import TDDToDoApp

class DetailViewControllerTests: XCTestCase {

    var sut: DetailViewController!
    
    override func setUpWithError() throws {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        sut = storyboard.instantiateViewController(
            withIdentifier: String(describing: DetailViewController.self)
        ) as? DetailViewController
        sut.loadViewIfNeeded()
    }

    override func tearDownWithError() throws {
        sut = nil
    }
    
    func test_Has_TitleLabel () {
        XCTAssertNotNil(sut.titleLabel)
        XCTAssertTrue(sut.titleLabel.isDescendant(of: sut.view))
    }
    
    func test_Has_DescriptionLabel() {
        XCTAssertNotNil(sut.descriptionLabel)
        XCTAssertTrue(
            sut.descriptionLabel.isDescendant(of: sut.view)
        )
    }
    
    func test_Has_DateLabel() {
        XCTAssertNotNil(sut.dateLabel)
        XCTAssertTrue(
            sut.dateLabel.isDescendant(of: sut.view)
        )
    }
    
    func test_Has_MapView() {
        XCTAssertNotNil(sut.mapView)
        XCTAssertTrue(
            sut.mapView.isDescendant(of: sut.view)
        )
    }
}
