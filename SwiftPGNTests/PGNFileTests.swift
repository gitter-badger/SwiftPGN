//
//  PGNFileTests.swift
//  SwiftPGN
//
//  Created by Alexander Perechnev on 21.03.17.
//  Copyright © 2017 Alexander Perechnev. All rights reserved.
//

import XCTest
@testable import SwiftPGN


class PGNFileTests: XCTestCase {
    
    private let kTestFilePath = "/Users/alexkrzyzanowski/Projects/SwiftPGN/SwiftPGNTests/multigame.pgn"
    
    
    func testPGNFileLoading() {
        let fileContent = try! String(contentsOfFile: self.kTestFilePath)
        let pgnFile = PGNFile(string: fileContent)
        XCTAssertEqual(pgnFile.gameList.count, 2)
    }

}
