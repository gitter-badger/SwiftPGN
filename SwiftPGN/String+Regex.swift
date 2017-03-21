//
//  String+Regex.swift
//  SwiftPGN
//
//  Created by Alexander Perechnev on 21.03.17.
//  Copyright © 2017 Alexander Perechnev. All rights reserved.
//

import Foundation


extension String {
    
    func findMatches(withPattern pattern: String) throws -> [String]  {
        let nsString = self as NSString
        var matchList: [String] = []
        
        let regularExpression = try NSRegularExpression(pattern: pattern, options: [])
        
        let range = NSMakeRange(0, nsString.length)
        let result = regularExpression.matches(in: self, options: [], range: range)
        
        let matches = result.map { nsString.substring(with: $0.range) }
        
        for match in matches {
            matchList.append(match)
        }
        
        return matchList
    }
    
}
