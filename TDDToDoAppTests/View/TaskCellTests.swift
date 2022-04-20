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
        XCTAssertTrue(cell.titleLabel.isDescendant(of: cell.contentView))
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
