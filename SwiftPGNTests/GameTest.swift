//
//  GameTest.swift
//  SwiftPGN
//
//  Created by Alexander Perechnev on 21.03.17.
//  Copyright © 2017 Alexander Perechnev. All rights reserved.
//

import XCTest
@testable import SwiftPGN


class GameTest: XCTestCase {
    
    private let kTestFilePath = "/Users/alexkrzyzanowski/Projects/SwiftPGN/SwiftPGNTests/one_game.pgn"
    
    
    func testMovesLoading() {
        let fileContent = try! String(contentsOfFile: self.kTestFilePath)
        let pgnFile = PGNFile(string: fileContent)
        let game: Game! = pgnFile.gameList.first
        XCTAssertNotNil(game)
        
        let moves = [
            [(Figure.pawn, "e", 4), (Figure.pawn, "c", 6)],
            [(Figure.pawn, "d", 4), (Figure.pawn, "d", 5)],
            [(Figure.knight, "c", 3), (Figure.pawn, "e", 4)],
            [(Figure.knight, "e", 4), (Figure.knight, "d", 7)],
            [(Figure.knight, "g", 5), (Figure.knight, "f", 6)],
            [(Figure.bishop, "d", 3), (Figure.pawn, "e", 6)],
            [(Figure.knight, "f", 3), (Figure.pawn, "h", 6)],
            [(Figure.knight, "e", 6), (Figure.queen, "e", 7)],
            // 9.O-O fxe6
            [(Figure.bishop, "g", 6), (Figure.king, "d", 8)], //{Каспаров встряхнул головой}
            [(Figure.bishop, "f", 4), (Figure.pawn, "b", 5)],
            [(Figure.pawn, "a", 4), (Figure.bishop, "b", 7)],
            [(Figure.rook, "e", 1), (Figure.knight, "d", 5)],
            [(Figure.bishop, "g", 3), (Figure.king, "c", 8)],
            [(Figure.pawn, "b", 5), (Figure.pawn, "b", 5)],
            [(Figure.queen, "d", 3), (Figure.bishop, "c", 6)],
            [(Figure.bishop, "f", 5), (Figure.pawn, "f", 5)],
            [(Figure.rook, "e", 7), (Figure.bishop, "e", 7)],
            [(Figure.pawn, "c", 4)] // 19.c4 1-0
        ]
        
        XCTAssertEqual(game.moves.count, moves.count)
        
        for (m_i, move) in moves.enumerated() {
            let gameMove = game.moves[m_i]
            
            XCTAssertEqual(gameMove.white.figure, move[0].0, "Move: \(m_i+1), Parsed: \(gameMove.white.figure), Test: \(move[0].0)")
            XCTAssertEqual(gameMove.white.position.0, move[0].1)
            XCTAssertEqual(gameMove.white.position.1, move[0].2)
            
            if let blackMove = gameMove.black {
                XCTAssertEqual(blackMove.figure, move[1].0)
                XCTAssertEqual(blackMove.position.0, move[1].1)
                XCTAssertEqual(blackMove.position.1, move[1].2)
            }
            
            if m_i == 8 {
                XCTAssertEqual(gameMove.comment, "Каспаров встряхнул головой")
            }
        }
    }

}
