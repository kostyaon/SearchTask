//
//  TriePrefixSearchingTests.swift
//  BB-taskTests
//
//  Created by KonstanTanos on 28/05/2023.
//

import Foundation
import XCTest

class TriePrefixSearchingTests: XCTestCase {
    
    var trieSearchingService: TriePrefixSearching!
    
    override func setUp() {
        super.setUp()
        
        self.trieSearchingService = TriePrefixSearching()
    }
    
    override func tearDown() {
        self.trieSearchingService = nil
        
        super.tearDown()
    }
    
    func testSearchForPrefix() {
        let dictionary: Dictionary<Int, String> = [
            0: "Amsterdam",
            1: "Wroclaw",
            2: "Warszawa",
            3: "Krakow",
            4: "Los Angeles",
            5: "Lublin",
            6: "San Francisco"
        ]

        
        let expectation = self.expectation(description: "Trie creation completion")
        
        trieSearchingService.createTrie(from: dictionary) {
            let emptyResults = self.trieSearchingService.searchFor(prefix: "")
            XCTAssertTrue(emptyResults.isEmpty, "Results should be empty for an empty prefix")
            
            let results = self.trieSearchingService.searchFor(prefix: "W")
            XCTAssertTrue(results.contains(1), "Result should contain ID 1")
            XCTAssertTrue(results.contains(2), "Result should contain ID 2")
            XCTAssertFalse(results.contains(0), "Result should not contain ID 0")
            XCTAssertFalse(results.contains(3), "Result should not contain ID 3")
            XCTAssertFalse(results.contains(4), "Result should not contain ID 4")
            XCTAssertFalse(results.contains(5), "Result should not contain ID 5")
            XCTAssertFalse(results.contains(6), "Result should not contain ID 6")
            
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 2.0)
    }
    
    func testIsEmpty() {
        let dictionary: Dictionary<Int, String> = [
            0: "Amsterdam",
            1: "Wroclaw"
        ]
        
        let expectation = XCTestExpectation(description: "Trie creation completion")
        
        XCTAssertTrue(self.trieSearchingService.isEmpty(), "Trie should be empty")
        
        trieSearchingService.createTrie(from: dictionary) {
            XCTAssertFalse(self.trieSearchingService.isEmpty(), "Trie should not be empty")
            
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 2.0)
    }
    
    func testInvalidInput() {
        let dictionary: Dictionary<Int, String> = [
            0: "Amsterdam",
            1: "Wroclaw"
        ]
        
        let expectation = XCTestExpectation(description: "Trie creation completion")
        
        trieSearchingService.createTrie(from: dictionary) {
            let results = self.trieSearchingService.searchFor(prefix: "!")
            XCTAssertTrue(results.isEmpty, "Results should be empty for an invalid character input")
            
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 2.0)
    }
    
    func testNonExistingPrefix() {
        let dictionary: Dictionary<Int, String> = [
            0: "Amsterdam",
            1: "Wroclaw"
        ]
        
        let expectation = XCTestExpectation(description: "Trie creation completion")
        
        trieSearchingService.createTrie(from: dictionary) {
            let results = self.trieSearchingService.searchFor(prefix: "wroclaw")
            XCTAssertTrue(results.isEmpty, "Results should be empty for a nonexisting input")
            
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 2.0)
    }
}
