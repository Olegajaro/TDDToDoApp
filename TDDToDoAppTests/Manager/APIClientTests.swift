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
        mockURLSession = MockURLSession(data: nil,
                                        urlResponse: nil,
                                        responseError: nil)
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
                  password: "%qwerty",
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
    
    func test_Login_Uses_Expexcted_Query_Patameters() {
        userLogin()
        
        guard
            let queryItems = mockURLSession.urlComponents?.queryItems
        else {
            XCTFail()
            return
        }
        
        let urlQueryItemName = URLQueryItem(name: "name", value: "name")
        let urlQuetyItemPassword = URLQueryItem(name: "password",
                                                value: "%qwerty")
        
        XCTAssertTrue(queryItems.contains(urlQueryItemName))
        XCTAssertTrue(queryItems.contains(urlQuetyItemPassword))
    }
    
    // token -> Data -> completionHandler -> DataTask -> URLSession
    func test_Successful_Login_Creates_Token() {
        let jsonDataStub = "{\"token\": \"tokenString\"}".data(using: .utf8)
        mockURLSession = MockURLSession(data: jsonDataStub,
                                        urlResponse: nil,
                                        responseError: nil)
        sut.urlSession = mockURLSession
        let tokenExpectaction = expectation(description: "Token expectation")
        
        var caughToken: String?
        sut.login(withName: "login", password: "password") { token, _ in
            caughToken = token
            tokenExpectaction.fulfill()
        }
        waitForExpectations(timeout: 1) { _ in
            XCTAssertEqual(caughToken, "tokenString")
        }
    }
}

extension APIClientTests {
    class MockURLSession: URLSessionProtocol {
        
        var url: URL?
        private let mockDataTask: MockURLSessionDataTask
        
        var urlComponents: URLComponents? {
            guard let url = url else {
                return nil
            }

            return URLComponents(url: url, resolvingAgainstBaseURL: true)
        }
        
        init(
            data: Data?,
            urlResponse: URLResponse?,
            responseError: Error?
        ) {
            mockDataTask = MockURLSessionDataTask(
                data: data,
                urlResponse: urlResponse,
                responseError: responseError
            )
        }
        
        func dataTask(
            with url: URL,
            completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void
        ) -> URLSessionDataTask {
            self.url = url
//            return URLSession.shared.dataTask(with: url)
            mockDataTask.completionHandler = completionHandler
            return mockDataTask
        }
    }
    
    class MockURLSessionDataTask: URLSessionDataTask {
        typealias CompletionHandler = (Data?, URLResponse?, Error?) -> Void
        
        private let data: Data?
        private let urlResponse: URLResponse?
        private let responseError: Error?
        
        var completionHandler: CompletionHandler?
        
        init(
            data: Data?,
            urlResponse: URLResponse?,
            responseError: Error?
        ) {
            self.data = data
            self.urlResponse = urlResponse
            self.responseError = responseError
        }
        
        override func resume() {
            DispatchQueue.main.async {
                self.completionHandler?(self.data,
                                        self.urlResponse,
                                        self.responseError)
            }
        }
    }
}
