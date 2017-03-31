//
//  PieceMove.swift
//  SwiftPGN
//
//  Created by Alexander Perechnev on 31.03.17.
//  Copyright © 2017 Alexander Perechnev. All rights reserved.
//

import Foundation


struct PieceMove {
    
    var piece: Piece
    var position: (String, Int)
    var sourcePosition: (String?, Int?)
    var isCheck: Bool
    
    init(withPosition position: (String, Int), ofPiece piece: Piece) {
        self.piece = piece
        self.position = position
        self.sourcePosition = (nil, nil)
        self.isCheck = false
    }
    
}
