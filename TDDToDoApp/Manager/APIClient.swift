//
//  APIClient.swift
//  TDDToDoApp
//
//  Created by Олег Федоров on 25.04.2022.
//

import Foundation

enum NetworkError: Error {
    case emptyData
}

protocol URLSessionProtocol {
    func dataTask(
        with url: URL,
        completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void
    ) -> URLSessionDataTask
}

extension URLSession: URLSessionProtocol {}

class APIClient {
    lazy var urlSession: URLSessionProtocol = URLSession.shared
    
    func login(
        withName name: String,
        password: String,
        completionHadler: @escaping (String?, Error?) -> Void
    ) {
        let allowedCharacters = CharacterSet.urlQueryAllowed
        /*
         URLFragmentAllowedCharacterSet  "#%<>[\]^`{|}
         URLHostAllowedCharacterSet      "#%/<>?@\^`{|}
         URLPasswordAllowedCharacterSet  "#%/:<>?@[\]^`{|}
         URLPathAllowedCharacterSet      "#%;<>?[\]^`{|}
         URLQueryAllowedCharacterSet     "#%<>[\]^`{|}
         URLUserAllowedCharacterSet      "#%/:<>?@[\]^`
         */
        guard
            let name = name.addingPercentEncoding(withAllowedCharacters: allowedCharacters),
            let password = password.addingPercentEncoding(withAllowedCharacters: allowedCharacters)
        else { fatalError() }
        
        let query = "name=\(name)&password=\(password)"
        
        guard
            let url = URL(string: "https://todoapp.com/login?\(query)")
        else { fatalError() }
        
        urlSession.dataTask(with: url) { data, response, error in
            
            guard error == nil else {
                completionHadler(nil, error)
                return
            }
            
            guard let data = data else {
                completionHadler(nil, NetworkError.emptyData)
                return
            }
            
            do {
                let dictionary = try JSONSerialization.jsonObject(with: data) as? [String : String]
                
                let token = dictionary?["token"]
                completionHadler(token, nil)
            } catch {
                completionHadler(nil, error)
            }
        }.resume()
    }
}
