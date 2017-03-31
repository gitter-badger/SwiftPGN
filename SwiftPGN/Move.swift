//
//  Move.swift
//  SwiftPGN
//
//  Created by Alexander Perechnev on 31.03.17.
//  Copyright © 2017 Alexander Perechnev. All rights reserved.
//

import Foundation


struct Move {
    
    var white: PieceMove
    var black: PieceMove?
    var comment: String?
    
    init(withWhite white: PieceMove) {
        self.white = white
    }
    
}
