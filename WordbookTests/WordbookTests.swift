//
//  WordbookTests.swift
//  WordbookTests
//
//  Created by Manenga on 2023/03/11.
//

import XCTest
@testable import Wordbook

final class WordbookTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testSetValue() throws {
        var viewModel = TransactionViewModel()
        viewModel.addCommand(type: .set, string: "foo 123", executed: true)
        XCTAssertEqual("> SET foo 123", viewModel.commandLog.last)
    }

    func testGetValue() throws {
        var viewModel = TransactionViewModel()
        viewModel.addCommand(type: .set, string: "foo 123", executed: true)
        viewModel.addCommand(type: .get, string: "foo", executed: true)
        XCTAssertEqual("123", viewModel.commandLog.last)
        viewModel.addCommand(type: .get, string: "abc", executed: true)
        XCTAssertEqual("key not set", viewModel.commandLog.last)
    }
    
    func testDeleteValue() throws {
        var viewModel = TransactionViewModel()
        viewModel.addCommand(type: .set, string: "foo 123", executed: true)
        viewModel.addCommand(type: .get, string: "foo", executed: true)
        XCTAssertEqual("123", viewModel.commandLog.last)
        viewModel.addCommand(type: .delete, string: "foo", executed: true)
        viewModel.addCommand(type: .get, string: "foo", executed: true)
        XCTAssertEqual("key not set", viewModel.commandLog.last)
    }
    
    func testCountOccurrences() throws {
        var viewModel = TransactionViewModel()
        viewModel.addCommand(type: .set, string: "foo 123", executed: true)
        viewModel.addCommand(type: .set, string: "bar 456", executed: true)
        viewModel.addCommand(type: .set, string: "baz 123", executed: true)
        viewModel.addCommand(type: .count, string: "123", executed: true)
        XCTAssertEqual("2", viewModel.commandLog.last)
        viewModel.addCommand(type: .count, string: "456", executed: true)
        XCTAssertEqual("1", viewModel.commandLog.last)
    }
    
    func testCommitTransaction() throws {
        var viewModel = TransactionViewModel()
        viewModel.addCommand(type: .set, string: "bar 123", executed: true)
        viewModel.addCommand(type: .get, string: "bar", executed: true)
        XCTAssertEqual("123", viewModel.commandLog.last)
        viewModel.addCommand(type: .begin, executed: true)
        viewModel.addCommand(type: .set, string: "foo 456", executed: true)
        viewModel.addCommand(type: .get, string: "bar", executed: true)
        XCTAssertEqual("123", viewModel.commandLog.last)
        viewModel.addCommand(type: .delete, string: "bar", executed: true)
        viewModel.addCommand(type: .commit, executed: true)
        viewModel.addCommand(type: .get, string: "bar", executed: true)
        XCTAssertEqual("key not set", viewModel.commandLog.last)
        viewModel.addCommand(type: .rollback, executed: true)
        XCTAssertEqual("no transaction", viewModel.commandLog.last)
        viewModel.addCommand(type: .get, string: "foo", executed: true)
        XCTAssertEqual("456", viewModel.commandLog.last)
    }
    
    func testRollbackTransaction() throws {
        var viewModel = TransactionViewModel()
        viewModel.addCommand(type: .set, string: "foo 123", executed: true)
        viewModel.addCommand(type: .set, string: "bar abc", executed: true)
        viewModel.addCommand(type: .begin, executed: true)
        viewModel.addCommand(type: .set, string: "foo 456", executed: true)
        viewModel.addCommand(type: .get, string: "foo", executed: true)
        XCTAssertEqual("456", viewModel.commandLog.last)
        viewModel.addCommand(type: .set, string: "bar def", executed: true)
        viewModel.addCommand(type: .get, string: "bar", executed: true)
        XCTAssertEqual("def", viewModel.commandLog.last)
        viewModel.addCommand(type: .rollback, executed: true)
        viewModel.addCommand(type: .get, string: "foo", executed: true)
        XCTAssertEqual("123", viewModel.commandLog.last)
        viewModel.addCommand(type: .get, string: "bar", executed: true)
        XCTAssertEqual("abc", viewModel.commandLog.last)
        viewModel.addCommand(type: .commit, executed: true)
        XCTAssertEqual("no transaction", viewModel.commandLog.last)
    }
    
    func testNestedTransactions() throws {
        var viewModel = TransactionViewModel()
        viewModel.addCommand(type: .set, string: "foo 123", executed: true)
        viewModel.addCommand(type: .set, string: "bar 456", executed: true)
        viewModel.addCommand(type: .begin, executed: true)
        viewModel.addCommand(type: .set, string: "foo 456", executed: true)
        viewModel.addCommand(type: .begin, executed: true)
        viewModel.addCommand(type: .count, string: "456", executed: true)
        XCTAssertEqual("2", viewModel.commandLog.last)
        viewModel.addCommand(type: .get, string: "foo", executed: true)
        XCTAssertEqual("456", viewModel.commandLog.last)
        viewModel.addCommand(type: .set, string: "foo 789", executed: true)
        viewModel.addCommand(type: .get, string: "foo", executed: true)
        XCTAssertEqual("789", viewModel.commandLog.last)
        viewModel.addCommand(type: .rollback, executed: true)
        viewModel.addCommand(type: .get, string: "foo", executed: true)
        XCTAssertEqual("456", viewModel.commandLog.last)
        viewModel.addCommand(type: .delete, string: "foo", executed: true)
        viewModel.addCommand(type: .get, string: "foo", executed: true)
        XCTAssertEqual("key not set", viewModel.commandLog.last)
        viewModel.addCommand(type: .rollback, executed: true)
        viewModel.addCommand(type: .get, string: "foo", executed: true)
        XCTAssertEqual("123", viewModel.commandLog.last)
    }
}
