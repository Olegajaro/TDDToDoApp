//
//  String+Extensions.swift
//  TDDToDoApp
//
//  Created by Олег Федоров on 25.04.2022.
//

import Foundation

extension String {
    var percentEncoded: String {
        let allowedCharaters = CharacterSet(
            charactersIn: "!@#$%^&*()-+=[]\\}{,.><"
        ).inverted
        
        guard
            let encodedString = addingPercentEncoding(
                withAllowedCharacters: allowedCharaters
            )
        else { fatalError() }
        
        return encodedString
    }
}
