//
//  Datastore.swift
//  Wordbook
//
//  Created by Manenga on 2023/03/11.
//

struct Datastore {
    var top: Transaction? = nil
    var size = 0
    var GlobalStore = [String: String]()
    
    mutating func reset() {
        top = nil
        size = 0
        debugPrint("Reset Stack: \(size)")
        debugPrint("GloblalStore:")
        debugPrint("\(GlobalStore)")
    }
    
    // Create a new Transaction, and make it the current active transaction
    mutating func createTransaction() {
        var transaction = Transaction()
        if let topTransaction = top {
            transaction.setNext(topTransaction)
        }
        top = transaction
        size += 1
        debugPrint("Create Transaction: \(size)")
    }

    // Create a new Transaction, and make it the current active transaction
    mutating func deleteTransaction() {
        if top?.hasNext() ?? false {
            top = top?.getNext()
            size -= 1
            debugPrint("Delete Transaction. Remaining: \(size)")
        }
    }
    
    // Copy all keys from the active transaction to the GlobalStore and reset when done
    mutating func commit() -> String? {
        if let activeTransaction = top {
            for (key, value) in activeTransaction.getStore() {
                GlobalStore[key] = value
                if var nextTransaction = activeTransaction.getNext() {
                    // update the parent transaction
                    nextTransaction.setValueForKey(value: value, key: key)
                    top?.setNext(nextTransaction)
                }
            }
            reset()
//            deleteTransaction()
            return nil
        } else {
            debugPrint("Nothing to commit")
            return "no transaction"
        }
    }
    
    // Remove the top transaction from the stack
    mutating func rollback() -> String? {
        if top == nil {
            debugPrint("No Active Transaction")
            return "no transaction"
        } else {
            deleteTransaction()
//            reset()
        }
        return nil
    }
    
    // Get value of key from the datastore. Check the active transaction first then child transaction then the Global Store
    func get(key: String) -> String {
        if let activeTransaction = top {
            if let value = activeTransaction.getValueForKey(key) {
                return value
            } else if let value = activeTransaction.searchTree(for: key) {
                return value
            } else if let value = GlobalStore[key] {
                return value
            } else {
                return "key not set"
            }
        } else {
            if let value = GlobalStore[key] {
                return value
            } else {
               return "key not set"
            }
        }
    }
    
    // Set value for key in the datastore. Use the active transaction if we have one, otherwise use the Global Store
    mutating func set(key: String, value: String) {
        if top == nil {
            GlobalStore[key] = value
        } else {
            top?.setValueForKey(value: value, key: key)
        }
    }
    
    // Return the number of occurrences of a specified value in the datastore. Check all transactions and the Global Store
    func count(value: String) -> Int {
        var count = 0
        for (_, val) in GlobalStore {
            if val == value {
                count += 1
            }
        }
        if let activeTransaction = top {
            count = activeTransaction.countAllOccurrences(of: value, total: count)
        }
        return count
    }

    // Delete a key from the datastore. First check the top transaction, its children and lastly the Global Store, only delete the first occurrence
    mutating func delete(key: String) {
        if let activeTransaction = top {
            if activeTransaction.getValueForKey(key) != nil {
                top?.setValueForKey(value: nil, key: key)
            } else if activeTransaction.searchTree(for: key) != nil {
                top?.deleteIfExistsInTree(key)
            } else {
                GlobalStore[key] = nil
            }
        } else {
            GlobalStore[key] = nil
        }
    }
}
