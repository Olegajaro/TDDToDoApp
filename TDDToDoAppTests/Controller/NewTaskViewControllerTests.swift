//
//  NewTaskViewControllerTests.swift
//  TDDToDoAppTests
//
//  Created by Олег Федоров on 22.04.2022.
//

import XCTest
import CoreLocation
@testable import TDDToDoApp

class NewTaskViewControllerTests: XCTestCase {
    
    var sut: NewTaskViewController!
    var placemark: MockCLPlacemark!

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
        XCTAssertTrue(sut.addressTextField.isDescendant(of: sut.view))
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
    
    func test_Save_Uses_Geocoder_To_Convert_Coordinate_From_Address() {
        let df = DateFormatter()
        df.dateFormat = "dd.MM.yy"
        let date = df.date(from: "01.01.19")
        
        sut.titleTextField.text = "Foo"
        sut.locationTextField.text = "Bar"
        sut.dateTextField.text = "01.01.19"
        sut.addressTextField.text = "Сочи"
        sut.descriptionTextField.text = "Baz"
        
        sut.taskManager = TaskManager()
        let mockGeocoder = MockCLGeocoder()
        sut.geocoder = mockGeocoder
        sut.save()
        
        let coordinate = CLLocationCoordinate2D(latitude: 43.5849997, longitude: 39.7187835)
        let location = Location(name: "Bar", coordinate: coordinate)
        let generatedTask = Task(title: "Foo",
                                 description: "Baz",
                                 date: date,
                                 location: location)
        
        placemark = MockCLPlacemark()
        placemark.mockCoordinate = coordinate
        mockGeocoder.completionHandler?([placemark], nil)
        
        let task = sut.taskManager.task(at: 0)
        
        XCTAssertEqual(task, generatedTask)
    }
    
    func test_SaveButton_Has_Save_Method() {
        let saveButton = sut.saveButton
        
        guard
            let actions = saveButton?.actions(
                forTarget: sut,
                forControlEvent: .touchUpInside
            )
        else {
            XCTFail()
            return
        }
        
        XCTAssertTrue(actions.contains("save"))
    }
    
    func test_Geocoder_Fetches_Correct_Coordinate() {
        let geocoderAnswer = expectation(description: "Geocoder answer")
        let addressString = "Сочи"
        let geocoder = CLGeocoder()
        
        geocoder.geocodeAddressString(addressString) { placemarks, error in
            let placemark = placemarks?.first
            let location = placemark?.location
            
            guard
                let latitude = location?.coordinate.latitude,
                let longitude = location?.coordinate.longitude
            else {
                XCTFail()
                return
            }
            
            XCTAssertEqual(latitude, 43.5849997)
            XCTAssertEqual(longitude, 39.7187835)
            geocoderAnswer.fulfill()
        }
        
        waitForExpectations(timeout: 5, handler: nil)
    }
}

extension NewTaskViewControllerTests {
    class MockCLGeocoder: CLGeocoder {
        var completionHandler: CLGeocodeCompletionHandler?
        
        override func geocodeAddressString(
            _ addressString: String,
            completionHandler: @escaping CLGeocodeCompletionHandler
        ) {
            self.completionHandler = completionHandler
        }
    }
    
    class MockCLPlacemark: CLPlacemark {
        var mockCoordinate: CLLocationCoordinate2D!
        
        override var location: CLLocation? {
            return CLLocation(latitude: mockCoordinate.latitude,
                              longitude: mockCoordinate.longitude)
        }
    }
}
