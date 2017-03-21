//
//  PGNFile.swift
//  SwiftPGN
//
//  Created by Alexander Perechnev on 21.03.17.
//  Copyright © 2017 Alexander Perechnev. All rights reserved.
//

import Foundation


class PGNFile {
    
    //
    // MARK: Private constants
    
    private let kGameRegexPattern = "(\\[.+\\])+(.|\n)+?((\\d\\-\\d)|(1/2\\-1/2))\n"
    
    //
    // MARK: Variables
    
    var gameList: [Game] = []
    
    //
    // MARK: Initialization
    
    init(string: String) {
        for gameString in try! string.findMatches(withPattern: self.kGameRegexPattern) {
            let game = Game(withPGNString: gameString)
            self.gameList.append(game)
        }
    }
    
}
