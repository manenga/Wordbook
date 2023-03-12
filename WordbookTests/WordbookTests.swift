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
        var viewModel = InterfaceViewModel()
        viewModel.addCommandIfValid(type: .set, string: "foo 123", shouldExecute: true)
        XCTAssertEqual("> SET foo 123", viewModel.commandLog.last)
    }

    func testGetValue() throws {
        var viewModel = InterfaceViewModel()
        viewModel.addCommandIfValid(type: .set, string: "foo 123", shouldExecute: true)
        viewModel.addCommandIfValid(type: .get, string: "foo", shouldExecute: true)
        XCTAssertEqual("123", viewModel.commandLog.last)
        viewModel.addCommandIfValid(type: .get, string: "abc", shouldExecute: true)
        XCTAssertEqual("key not set", viewModel.commandLog.last)
    }
    
    func testDeleteValue() throws {
        var viewModel = InterfaceViewModel()
        viewModel.addCommandIfValid(type: .set, string: "foo 123", shouldExecute: true)
        viewModel.addCommandIfValid(type: .get, string: "foo", shouldExecute: true)
        XCTAssertEqual("123", viewModel.commandLog.last)
        viewModel.addCommandIfValid(type: .delete, string: "foo", shouldExecute: true)
        viewModel.addCommandIfValid(type: .get, string: "foo", shouldExecute: true)
        XCTAssertEqual("key not set", viewModel.commandLog.last)
    }
    
    func testCountOccurrences() throws {
        var viewModel = InterfaceViewModel()
        viewModel.addCommandIfValid(type: .set, string: "foo 123", shouldExecute: true)
        viewModel.addCommandIfValid(type: .set, string: "bar 456", shouldExecute: true)
        viewModel.addCommandIfValid(type: .set, string: "baz 123", shouldExecute: true)
        viewModel.addCommandIfValid(type: .count, string: "123", shouldExecute: true)
        XCTAssertEqual("2", viewModel.commandLog.last)
        viewModel.addCommandIfValid(type: .count, string: "456", shouldExecute: true)
        XCTAssertEqual("1", viewModel.commandLog.last)
    }
    
    func testCommitTransaction() throws {
        var viewModel = InterfaceViewModel()
        viewModel.addCommandIfValid(type: .set, string: "bar 123", shouldExecute: true)
        viewModel.addCommandIfValid(type: .get, string: "bar", shouldExecute: true)
        XCTAssertEqual("123", viewModel.commandLog.last)
        viewModel.addCommandIfValid(type: .begin, shouldExecute: true)
        viewModel.addCommandIfValid(type: .set, string: "foo 456", shouldExecute: true)
        viewModel.addCommandIfValid(type: .get, string: "bar", shouldExecute: true)
        XCTAssertEqual("123", viewModel.commandLog.last)
        viewModel.addCommandIfValid(type: .delete, string: "bar", shouldExecute: true)
        viewModel.addCommandIfValid(type: .commit, shouldExecute: true)
        viewModel.addCommandIfValid(type: .get, string: "bar", shouldExecute: true)
        XCTAssertEqual("key not set", viewModel.commandLog.last)
        viewModel.addCommandIfValid(type: .rollback, shouldExecute: true)
        XCTAssertEqual("no transaction", viewModel.commandLog.last)
        viewModel.addCommandIfValid(type: .get, string: "foo", shouldExecute: true)
        XCTAssertEqual("456", viewModel.commandLog.last)
    }
    
    func testRollbackTransaction() throws {
        var viewModel = InterfaceViewModel()
        viewModel.addCommandIfValid(type: .set, string: "foo 123", shouldExecute: true)
        viewModel.addCommandIfValid(type: .set, string: "bar abc", shouldExecute: true)
        viewModel.addCommandIfValid(type: .begin, shouldExecute: true)
        viewModel.addCommandIfValid(type: .set, string: "foo 456", shouldExecute: true)
        viewModel.addCommandIfValid(type: .get, string: "foo", shouldExecute: true)
        XCTAssertEqual("456", viewModel.commandLog.last)
        viewModel.addCommandIfValid(type: .set, string: "bar def", shouldExecute: true)
        viewModel.addCommandIfValid(type: .get, string: "bar", shouldExecute: true)
        XCTAssertEqual("def", viewModel.commandLog.last)
        viewModel.addCommandIfValid(type: .rollback, shouldExecute: true)
        viewModel.addCommandIfValid(type: .get, string: "foo", shouldExecute: true)
        XCTAssertEqual("123", viewModel.commandLog.last)
        viewModel.addCommandIfValid(type: .get, string: "bar", shouldExecute: true)
        XCTAssertEqual("abc", viewModel.commandLog.last)
        viewModel.addCommandIfValid(type: .commit, shouldExecute: true)
        XCTAssertEqual("no transaction", viewModel.commandLog.last)
    }
    
    func testNestedTransactions() throws {
        var viewModel = InterfaceViewModel()
        viewModel.addCommandIfValid(type: .set, string: "foo 123", shouldExecute: true)
        viewModel.addCommandIfValid(type: .set, string: "bar 456", shouldExecute: true)
        viewModel.addCommandIfValid(type: .begin, shouldExecute: true)
        viewModel.addCommandIfValid(type: .set, string: "foo 456", shouldExecute: true)
        viewModel.addCommandIfValid(type: .begin, shouldExecute: true)
        viewModel.addCommandIfValid(type: .count, string: "456", shouldExecute: true)
        XCTAssertEqual("2", viewModel.commandLog.last)
        viewModel.addCommandIfValid(type: .get, string: "foo", shouldExecute: true)
        XCTAssertEqual("456", viewModel.commandLog.last)
        viewModel.addCommandIfValid(type: .set, string: "foo 789", shouldExecute: true)
        viewModel.addCommandIfValid(type: .get, string: "foo", shouldExecute: true)
        XCTAssertEqual("789", viewModel.commandLog.last)
        viewModel.addCommandIfValid(type: .rollback, shouldExecute: true)
        viewModel.addCommandIfValid(type: .get, string: "foo", shouldExecute: true)
        XCTAssertEqual("456", viewModel.commandLog.last)
        viewModel.addCommandIfValid(type: .delete, string: "foo", shouldExecute: true)
        viewModel.addCommandIfValid(type: .get, string: "foo", shouldExecute: true)
        XCTAssertEqual("key not set", viewModel.commandLog.last) // TODO: figure out why this isn't using GlobalStore. Could it be wrong?
        viewModel.addCommandIfValid(type: .rollback, shouldExecute: true)
        viewModel.addCommandIfValid(type: .get, string: "foo", shouldExecute: true)
        XCTAssertEqual("123", viewModel.commandLog.last)
    }
}
