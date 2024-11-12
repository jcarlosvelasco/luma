//
//  String+Extensions.swift
//  ImageApp2
//
//  Created by Juan Carlos Velasco on 13/8/24.
//

import Foundation

extension String {
    var first200Safe: String {
        let endIndex = index(startIndex, offsetBy: Swift.min(200, count))
        let substring = String(self[startIndex..<endIndex])
        
        // Replace whitespace with underscore or dash
        let replacedSubstring = substring
            .replacingOccurrences(of: " ", with: "_")
            .replacingOccurrences(of: "\t", with: "_")
            .replacingOccurrences(of: "\n", with: "_")
        
        // Remove unsafe characters from the substring
        let allowedCharacters = CharacterSet.alphanumerics.union(CharacterSet(charactersIn: "-_"))
        let filteredSubstring = replacedSubstring
            .components(separatedBy: allowedCharacters.inverted)
            .joined()
        
        return filteredSubstring
    }
}
