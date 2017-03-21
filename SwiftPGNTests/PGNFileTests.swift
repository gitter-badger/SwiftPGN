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
    
    private let kTestFilePath = "/Users/alexkrzyzanowski/Projects/SwiftPGN/SwiftPGNTests/test.pgn"

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testLoading() {
        let file = try! String(contentsOfFile: self.kTestFilePath)
        let game = PGNFile(string: file)
        print("game")
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
