//
//  Game.swift
//  SwiftPGN
//
//  Created by Alexander Perechnev on 21.03.17.
//  Copyright © 2017 Alexander Perechnev. All rights reserved.
//

import Foundation


class Game {
    
    private let kMetaPattern = "\\[.+\\]"
    private let kMetaKeyPattern = "\\[[a-zA-Z]+(\\s|\\t)?"
    private let kMetaValuePattern = "\".+\""

    var event: String?
    var site: String?
    var date: String?
    var round: String?
    var white: String?
    var black: String?
    var opening: String?
    var ECO: String?
    var result: String?
    
    init(withPGNString pgnString: String) {
        let nsString = pgnString as NSString
        
        let regularExpression = try! NSRegularExpression(pattern: self.kMetaPattern, options: [])
        
        let range = NSMakeRange(0, nsString.length)
        let result = regularExpression.matches(in: pgnString, options: [], range: range)
        
        let matches = result.map { nsString.substring(with: $0.range) }
        
        print("==========")
        for match in matches {
            if let (key, value) = self.loadMeta(fromMetaString: match) {
                self.set(value: value, forMetaKey: key)
            }
        }
    }
    
    private func loadMeta(fromMetaString string: String) -> (String, String)? {
        let nsString = string as NSString
        
        func loadKey(fromString string: NSString) -> String? {
            let regularExpression = try! NSRegularExpression(pattern: self.kMetaKeyPattern, options: [])
            
            let range = NSMakeRange(0, string.length)
            let result = regularExpression.matches(in: string as String, options: [], range: range)
            
            let matches = result.map { string.substring(with: $0.range) }
            
            if let match = matches.first {
                return match.replacingOccurrences(of: "[", with: "").replacingOccurrences(of: "\"", with: "").replacingOccurrences(of: " ", with: "")
            }
            
            return nil
        }
        
        func loadValue(fromString string: NSString) -> String? {
            let regularExpression = try! NSRegularExpression(pattern: self.kMetaValuePattern, options: [])
            
            let range = NSMakeRange(0, string.length)
            let result = regularExpression.matches(in: string as String, options: [], range: range)
            
            let matches = result.map { string.substring(with: $0.range) }
            
            if let match = matches.first {
                return match.replacingOccurrences(of: "\"", with: "")
            }
            
            return nil
        }
        
        if let key = loadKey(fromString: nsString) {
            if let value = loadValue(fromString: nsString) {
                return (key, value)
            }
        }
        
        return nil
    }
    
    private func set(value: String, forMetaKey key: String) {
        switch key {
        case "Event":
            self.event = value
        case "Site":
            self.site = value
        case "Date":
            self.date = value
        case "Round":
            self.round = value
        case "White":
            self.white = value
        case "Black":
            self.black = value
        case "Opening":
            self.opening = value
        case "ECO":
            self.ECO = value
        case "Result":
            self.result = value
        default:
            break
        }
    }
    
}
