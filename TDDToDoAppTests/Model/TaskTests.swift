//
//  TaskTests.swift
//  TDDToDoAppTests
//
//  Created by Олег Федоров on 16.04.2022.
//

import XCTest
@testable import TDDToDoApp

class TaskTests: XCTestCase {

    func test_Init_Task_With_Title() {
        let task = Task(title: "Foo")
        
        XCTAssertNotNil(task)
    }
    
    func test_Init_Task_With_Title_And_Description() {
        let task = Task(title: "Foo", description: "Bar")
        
        XCTAssertNotNil(task)
    }
    
    
    func test_When_Given_Title_Sets_Title() {
        let task = Task(title: "Foo")
        
        XCTAssertEqual(task.title, "Foo")
    }
    
    func test_When_Given_Description_Sets_Description() {
        let task = Task(title: "Foo", description: "Bar")
        
        XCTAssertEqual(task.description, "Bar")
    }
    
    func test_Task_Inits_WithDate() {
        let task = Task(title: "Foo")
        
        XCTAssertNotNil(task.date)
    }
    
    func test_When_Given_Location_Sets_Location() {
        let location = Location(name: "Foo")
        
        let task = Task(title: "Foo",
                        description: "Bar",
                        location: location)
        
        XCTAssertEqual(location, task.location)
    }
    
    func test_Can_Be_Created_From_Plist_Dictionaty() {
        let location = Location(name: "Baz")
        let date = Date(timeIntervalSince1970: 10)
        let task = Task(title: "Foo", description: "Bar", date: date, location: location)
        
        let locationDictionary: [String: Any] = ["name": "Baz"]
        let dictionary: [String: Any] = [
            "title": "Foo",
            "description": "Bar",
            "date": date,
            "location": locationDictionary
        ]
        
        let createdTask = Task(dict: dictionary)
        
        XCTAssertEqual(task, createdTask)
    }
}
