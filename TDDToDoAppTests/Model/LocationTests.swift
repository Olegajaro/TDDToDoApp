//
//  LocationTests.swift
//  TDDToDoAppTests
//
//  Created by Олег Федоров on 16.04.2022.
//

import XCTest
import CoreLocation
@testable import TDDToDoApp

class LocationTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func test_Init_Sets_Name() {
        let location = Location(name: "Foo")
        
        XCTAssertEqual(location.name, "Foo")
    }

    func test_Init_Sets_Coordinates() {
        let coordinate = CLLocationCoordinate2D(latitude: 1, longitude: 2)
        let location = Location(name: "Foo", coordinate: coordinate)
        
        XCTAssertEqual(location.coordinate?.latitude, coordinate.latitude)
        XCTAssertEqual(location.coordinate?.longitude, coordinate.longitude)
    }
    
    func test_Can_Be_Created_From_Plist_Dictionaty() {
        let location = Location(
            name: "Foo",
            coordinate: CLLocationCoordinate2D(latitude: 10.0,
                                               longitude: 10.0)
        )
        let dict: [String: Any] = [
            "name": "Foo",
            "latitude": 10.0,
            "longitude": 10.0
        ]
        
        let createdLocation = Location(dict: dict)
        
        XCTAssertEqual(location, createdLocation)
    }
    
    func test_Can_Be_Serialized_Into_Dictionary() {
        let location = Location(
            name: "Foo",
            coordinate: CLLocationCoordinate2D(latitude: 10.0,
                                               longitude: 10.0)
        )
        let genetatedLocation = Location(dict: location.dict)
        
        XCTAssertEqual(location, genetatedLocation)
    }
}
