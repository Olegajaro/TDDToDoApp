//
//  APIClientTests.swift
//  TDDToDoAppTests
//
//  Created by Олег Федоров on 25.04.2022.
//

import XCTest
@testable import TDDToDoApp

class APIClientTests: XCTestCase {
    
    var mockURLSession: MockURLSession!
    var sut: APIClient!

    override func setUpWithError() throws {
        mockURLSession = MockURLSession()
        sut = APIClient()
        sut.urlSession = mockURLSession
    }

    override func tearDownWithError() throws {
        mockURLSession = nil
        sut = nil
    }
    
    func userLogin() {
        let completionHandler = { (token: String?, error: Error?) in }
        sut.login(withName: "name",
                  password: "qwerty",
                  completionHadler: completionHandler)
    }
    
    func test_Login_Uses_Correct_Host() {
        userLogin()
        XCTAssertEqual(mockURLSession.urlComponents?.host, "todoapp.com")
    }
    
    func test_Login_uses_Correct_Path() {
        userLogin()
        XCTAssertEqual(mockURLSession.urlComponents?.path, "/login")
    }
}

extension APIClientTests {
    class MockURLSession: URLSessionProtocol {
        
        var url: URL?
        
        var urlComponents: URLComponents? {
            guard let url = url else {
                return nil
            }

            return URLComponents(url: url, resolvingAgainstBaseURL: true)
        }
        
        func dataTask(
            with url: URL,
            completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void
        ) -> URLSessionDataTask {
            self.url = url
            return URLSession.shared.dataTask(with: url)
        }
    }
}
