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
    
    private let kMovePattern = "\\d+\\.\\s*(([a-zA-Z0-9]{2,})|(O-O)|(O-O-O))\\+?\\s(([a-zA-Z0-9]{2,})|(O-O)|(O-O-O))?(\\s\\{.+\\})?"
    private let kResultPattern = "\\s(1-0|0-1|1\\/2-1\\/2)"
    
    private let kPositionedPiecePattern = "([KQRBN]?[a-h1-8]?x?[a-h][1-8]\\+?)|(O-O)|(O-O-O)"
    private let kMoveCommentPattern = "\\{.+\\}"

    var event: String?
    var site: String?
    var date: String?
    var round: String?
    var white: String?
    var black: String?
    var opening: String?
    var ECO: String?
    var result: String?
    
    var moves: [Move] = []
    
    //
    // MARK: Initialization
    
    init(withPGNString pgnString: String) {
        self.parseMeta(fromPGNGameString: pgnString)
        self.parseMoves(fromPGNGameString: pgnString)
        self.parseResult(fromPGNGameString: pgnString)
    }
    
    //
    // MARK: Meta parsing
    
    private func parseMeta(fromPGNGameString pgnString: String) {
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
    
    //
    // MARK: Moves parsing
    
    private func parseMoves(fromPGNGameString pgnString: String) {
        for match in try! pgnString.findMatches(withPattern: self.kMovePattern) {
            if let move = self.parseMove(fromString: match) {
                self.moves.append(move)
            }
        }
    }
    
    private func parseMove(fromString moveString: String) -> Move? {
        var positionedFigures: [PieceMove] = []
        
        for match in try! moveString.findMatches(withPattern: self.kPositionedPiecePattern) {
            var step = match.replacingOccurrences(of: "\n", with: "").replacingOccurrences(of: " ", with: "")
            
            if step == "O-O" {
                positionedFigures.append(PieceMove(withPosition: ("", 0), ofPiece: .kingsideCastling))
                continue
            } else if step == "O-O-O" {
                positionedFigures.append(PieceMove(withPosition: ("", 0), ofPiece: .queensideCastling))
                continue
            }
            
            var isCheck = false
            if step.contains("+") {
                let _ = step.characters.popLast()
                isCheck = true
            }
            
            guard let horizontal = step.characters.popLast() else { continue }
            guard let vertical = step.characters.popLast() else { continue }
            
            let position = (String(vertical), Int(String(horizontal))!)
            
            let figure: Piece = self.figure(fromMoveString: step)
            
            var sourcePosition: (String?, Int?) = (nil, nil)
            while let c = step.characters.popLast() {
                if "abcdefgh".contains(String(c)) {
                    sourcePosition.0 = String(c)
                } else if "12345678".contains(String(c)) {
                    sourcePosition.1 = Int(String(c))
                }
            }
            
            var positionedFigure = PieceMove(withPosition: position, ofPiece: figure)
            positionedFigure.sourcePosition = sourcePosition
            positionedFigure.isCheck = isCheck
            
            positionedFigures.append(positionedFigure)
        }
        
        var comment: String? = nil
        for match in try! moveString.findMatches(withPattern: self.kMoveCommentPattern) {
            comment = match
        }
        
        if positionedFigures.count > 0 {
            var move = Move(withWhite: positionedFigures[0])
            
            if positionedFigures.count > 1 {
                move.black = positionedFigures[1]
            }
            
            if let comment = comment {
                move.comment = comment.replacingOccurrences(of: "{", with: "").replacingOccurrences(of: "}", with: "")
            }
            return move
        }
        
        return nil
    }
    
    private func figure(fromMoveString s: String) -> Piece {
        if s.contains("K") {
            return Piece.king
        } else if s.contains("Q") {
            return Piece.queen
        } else if s.contains("R") {
            return Piece.rook
        } else if s.contains("B") {
            return Piece.bishop
        } else if s.contains("N") {
            return Piece.knight
        }
        return .pawn
    }
    
    private func parseResult(fromPGNGameString pgnString: String) {
        for match in try! pgnString.findMatches(withPattern: self.kResultPattern) {
            self.result = match.replacingOccurrences(of: " ", with: "")
        }
    }
    
}
