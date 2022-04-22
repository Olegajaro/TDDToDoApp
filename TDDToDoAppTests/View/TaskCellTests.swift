//
//  TaskCellTests.swift
//  TDDToDoAppTests
//
//  Created by Олег Федоров on 20.04.2022.
//

import XCTest
@testable import TDDToDoApp

class TaskCellTests: XCTestCase {
    
    var cell: TaskCell!

    override func setUpWithError() throws {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(
            withIdentifier: String(describing: TaskListViewController.self)
        ) as! TaskListViewController
        controller.loadViewIfNeeded()
        
        let tableView = controller.tableView
        let dataSource = FakeDataSource()
        tableView?.dataSource = dataSource
        
        cell = tableView?.dequeueReusableCell(
            withIdentifier: String(describing: TaskCell.self),
            for: IndexPath(row: 0, section: 0)
        ) as? TaskCell
    }

    override func tearDownWithError() throws {
        cell = nil
    }
    
    func test_Cell_Has_TitleLabel() {
        XCTAssertNotNil(cell.titleLabel)
    }
    
    func test_Cell_Has_TitleLabel_In_ContentView() {
        XCTAssertTrue(cell.titleLabel.isDescendant(of: cell.contentView))
    }
    
    func test_Cell_Has_LocationLabel() {
        XCTAssertNotNil(cell.locationLabel)
    }
    
    func test_Cell_Has_LocationLabel_In_ContentView() {
        XCTAssertTrue(cell.locationLabel.isDescendant(of: cell.contentView))
    }
    
    func test_Cell_Has_DateLabel() {
        XCTAssertNotNil(cell.dateLabel)
    }
    
    func test_Cell_Has_DateLabel_In_ContentView() {
        XCTAssertTrue(cell.dateLabel.isDescendant(of: cell.contentView))
    }
    
    func test_Configure_Sets_Title() {
        let task = Task(title: "Foo")
        cell.configure(withTask: task)
        
        XCTAssertEqual(cell.titleLabel.text, task.title)
    }
    
    func test_Configure_Sets_Date() {
        let task = Task(title: "Foo")
        cell.configure(withTask: task)
        
        let df = DateFormatter()
        df.dateFormat = "dd.MM.yy"
        
        let date = task.date
        let dateString = df.string(from: date)
        
        XCTAssertEqual(cell.dateLabel.text, dateString)
    }
    
    func test_Configure_Sets_Location_Name() {
        let location = Location(name: "Foo")
        let task = Task(title: "Bar", location: location)
        cell.configure(withTask: task)
        
        XCTAssertEqual(cell.locationLabel.text, task.location?.name)
    }
    
    private func configureCellWithDoneTask() {
        let task = Task(title: "Foo")
        cell.configure(withTask: task, done: true)
    }
    
    func test_Done_Task_Should_Strike_Through() {
        configureCellWithDoneTask()
        
        let attributes: [NSAttributedString.Key: Any] = [
            .strikethroughStyle: NSUnderlineStyle.single.rawValue
        ]
        let attributedString = NSAttributedString(
            string: "Foo",
            attributes: attributes
        )
        
        XCTAssertEqual(cell.titleLabel.attributedText, attributedString)
    }
    
    func test_Done_Task_DateLabel_Equals_Nil() {
        configureCellWithDoneTask()
        
        XCTAssertNil(cell.dateLabel)
    }
    
    func test_Done_Task_LocationLabel_Equals_Nil() {
        configureCellWithDoneTask()
        
        XCTAssertNil(cell.locationLabel)
    }
}

extension TaskCellTests {
    class FakeDataSource: NSObject, UITableViewDataSource {
        func tableView(_ tableView: UITableView,
                       numberOfRowsInSection section: Int) -> Int {
            return 1
        }
        
        func tableView(_ tableView: UITableView,
                       cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            return UITableViewCell()
        }
    }
}
