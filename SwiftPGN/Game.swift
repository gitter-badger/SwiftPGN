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
        let matches = try! pgnString.findMatches(withPattern: self.kMetaPattern)
        
        for match in matches {
            if let (key, value) = self.loadMeta(fromMetaString: match) {
                self.set(value: value, forMetaKey: key)
            }
        }
    }
    
    private func loadMeta(fromMetaString string: String) -> (String, String)? {
        func loadKey(fromString string: String) -> String? {
            let matches = try! string.findMatches(withPattern: self.kMetaKeyPattern)
            
            if let match = matches.first {
                return match.replacingOccurrences(of: "[", with: "").replacingOccurrences(of: "\"", with: "").replacingOccurrences(of: " ", with: "")
            }
            
            return nil
        }
        
        func loadValue(fromString string: String) -> String? {
            let matches = try! string.findMatches(withPattern: self.kMetaValuePattern)
            
            if let match = matches.first {
                return match.replacingOccurrences(of: "\"", with: "")
            }
            
            return nil
        }
        
        if let key = loadKey(fromString: string) {
            if let value = loadValue(fromString: string) {
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
