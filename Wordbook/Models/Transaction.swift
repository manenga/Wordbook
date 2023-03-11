//
//  Transaction.swift
//  Wordbook
//
//  Created by Manenga on 2023/03/11.
//

struct Transaction {
    private var store = [String: String]()
    private var next: [Transaction] = []
    
    func getStore() -> [String: String] {
        store
    }
    
    mutating func hasNext() -> Bool {
        return getNext() != nil
    }
    
    mutating func setNext(_ item: Transaction) {
        next.removeAll()
        next.append(item)
    }
    
    func getNext() -> Transaction? {
        next.first
    }
    
    mutating func setValueForKey(value: String?, key: String) {
        store[key] = value
    }
    
    func getValueForKey(_ key: String) -> String? {
        store[key]
    }
    
    func searchTree(for key: String) -> String? {
        if let nextTransaction = next.first {
            if let value = nextTransaction.store[key] {
                return value
            } else {
                return nextTransaction.searchTree(for: key)
            }
        } else {
            return nil
        }
    }
    
    mutating func deleteIfExistsInTree(_ key: String) {
        if var nextTransaction = next.first {
            if nextTransaction.store[key] != nil {
                nextTransaction.store[key] = nil
                setNext(nextTransaction)
            } else {
                nextTransaction.deleteIfExistsInTree(key)
            }
        }
    }
    
    func countAllOccurrences(of value: String, total: Int = 0) -> Int {
        var count = total
        for (_, val) in store {
            if val == value {
                count += 1
            }
        }
        if let nextTransaction = next.first {
            count = nextTransaction.countAllOccurrences(of: value, total: count)
        }
        return count
    }
}
