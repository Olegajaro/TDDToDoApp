//
//  DetailViewControllerTests.swift
//  TDDToDoAppTests
//
//  Created by Олег Федоров on 22.04.2022.
//

import XCTest
import CoreLocation
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
    
    func test_Has_LocationLabel() {
        XCTAssertNotNil(sut.locationLabel)
        XCTAssertTrue(
            sut.locationLabel.isDescendant(of: sut.view)
        )
    }
    
    func test_Has_MapView() {
        XCTAssertNotNil(sut.mapView)
        XCTAssertTrue(
            sut.mapView.isDescendant(of: sut.view)
        )
    }
    
    private func setupTaskAndAppearanceTransition() {
        let coordinate = CLLocationCoordinate2D(latitude: 43.92582475,
                                                longitude: 39.3145893)
        let date = Date(timeIntervalSince1970: 1546300800)
        let task = Task(
            title: "Foo",
            description: "Bar",
            date: date, location: Location(name: "Baz", coordinate: coordinate)
        )
        
        sut.task = task
        
        sut.beginAppearanceTransition(true, animated: true)
        sut.endAppearanceTransition()
    }
    
    func test_Setting_Task_Sets_TitleLabel() {
        setupTaskAndAppearanceTransition()
        
        XCTAssertEqual(sut.titleLabel.text, "Foo")
    }
    
    func test_Setting_Task_Sets_DescriptionLabel() {
        setupTaskAndAppearanceTransition()
        
        XCTAssertEqual(sut.descriptionLabel.text, "Bar")
    }
    
    func test_Setting_Task_Sets_LocationLabel() {
        setupTaskAndAppearanceTransition()
        
        XCTAssertEqual(sut.locationLabel.text, "Baz")
    }
    
    func test_Setting_Task_Sets_DateLabel() {
        setupTaskAndAppearanceTransition()
        
        XCTAssertEqual(sut.dateLabel.text, "01.01.19")
    }
    
    func test_Setting_Task_Sets_MapView() {
        setupTaskAndAppearanceTransition()
        
        XCTAssertEqual(sut.mapView.centerCoordinate.latitude,
                       43.92582475,
                       accuracy: 0.001)
        XCTAssertEqual(sut.mapView.centerCoordinate.longitude,
                       39.3145893,
                       accuracy: 0.001)
    }
}
