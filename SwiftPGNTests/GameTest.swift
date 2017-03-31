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
            [(Piece.pawn, "e", 4), (Piece.pawn, "c", 6)],
            [(Piece.pawn, "d", 4), (Piece.pawn, "d", 5)],
            [(Piece.knight, "c", 3), (Piece.pawn, "e", 4)],
            [(Piece.knight, "e", 4), (Piece.knight, "d", 7)],
            [(Piece.knight, "g", 5), (Piece.knight, "f", 6)],
            [(Piece.bishop, "d", 3), (Piece.pawn, "e", 6)],
            [(Piece.knight, "f", 3), (Piece.pawn, "h", 6)],
            [(Piece.knight, "e", 6), (Piece.queen, "e", 7)],
            [(Piece.kingsideCastling, "", 0), (Piece.pawn, "e", 6)], // 9.O-O fxe6
            [(Piece.bishop, "g", 6), (Piece.king, "d", 8)], //{Каспаров встряхнул головой}
            [(Piece.bishop, "f", 4), (Piece.pawn, "b", 5)],
            [(Piece.pawn, "a", 4), (Piece.bishop, "b", 7)],
            [(Piece.rook, "e", 1), (Piece.knight, "d", 5)],
            [(Piece.bishop, "g", 3), (Piece.king, "c", 8)],
            [(Piece.pawn, "b", 5), (Piece.pawn, "b", 5)],
            [(Piece.queen, "d", 3), (Piece.bishop, "c", 6)],
            [(Piece.bishop, "f", 5), (Piece.pawn, "f", 5)],
            [(Piece.rook, "e", 7), (Piece.bishop, "e", 7)],
            [(Piece.pawn, "c", 4)] // 19.c4 1-0
        ]
        
        XCTAssertEqual(game.moves.count, moves.count)
        
        for (m_i, move) in moves.enumerated() {
            let gameMove = game.moves[m_i]
            
            XCTAssertEqual(gameMove.white.piece, move[0].0, "Move: \(m_i+1), Parsed: \(gameMove.white.piece), Test: \(move[0].0)")
            XCTAssertEqual(gameMove.white.position.0, move[0].1)
            XCTAssertEqual(gameMove.white.position.1, move[0].2)
            
            if let blackMove = gameMove.black {
                XCTAssertEqual(blackMove.piece, move[1].0)
                XCTAssertEqual(blackMove.position.0, move[1].1)
                XCTAssertEqual(blackMove.position.1, move[1].2)
            }
            
            if m_i == 2 {
                XCTAssertEqual(gameMove.black!.sourcePosition.0, "d")
            } else if m_i == 4 {
                XCTAssertEqual(gameMove.black!.sourcePosition.0, "g")
            } else if m_i == 6 {
                XCTAssertEqual(gameMove.white.sourcePosition.1, 1)
            } else if m_i == 8 {
                XCTAssertEqual(gameMove.black!.sourcePosition.0, "f")
            } else if m_i == 9 {
                XCTAssertEqual(gameMove.white.isCheck, true)
                XCTAssertEqual(gameMove.comment, "Каспаров встряхнул головой")
            } else if m_i == 14 {
                XCTAssertEqual(gameMove.white.sourcePosition.0, "a")
                XCTAssertEqual(gameMove.black!.sourcePosition.0, "c")
            } else if m_i == 16 {
                XCTAssertEqual(gameMove.black!.sourcePosition.0, "e")
            }
        }
        
        XCTAssertEqual(game.result, "1-0")
    }

}
