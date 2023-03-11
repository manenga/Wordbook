//
//  TransactionViewModel.swift
//  Wordbook
//
//  Created by Manenga on 2023/03/11.
//

struct TransactionViewModel {
    
    private var memoryLog = ""
    private var datastore: Datastore = Datastore()
    var commandLog: [String] = []
    
    mutating func addCommand(type: Command, string: String = "", executed: Bool = false) {
        var prefix = ""
        
        switch type {
        case .none:
            break
        case .set:
            prefix = "> SET"
        case .get:
            prefix = "> GET"
        case .delete:
            prefix = "> DELETE"
        case .count:
            prefix = "> COUNT"
        case .begin:
            prefix = "> BEGIN"
        case .commit:
            prefix = "> COMMIT"
        case .rollback:
            prefix = "> ROLLBACK"
        }
        
        clearMemoryLogIfExists()
        
        let fullCommand = "\(prefix) \(string)"
        commandLog.append(fullCommand)
        memoryLog = fullCommand
        
        guard executed else { return }
        memoryLog = ""
        execute(type: type, command: fullCommand)
    }
    
    mutating func clearMemoryLogIfExists() {
        if commandLog.endIndex > 0 {
            let lastCommand = commandLog[commandLog.endIndex - 1]
            if lastCommand == memoryLog {
                commandLog.remove(at: commandLog.endIndex - 1)
            }
        }
    }
    
    private mutating func execute(type: Command, command: String) {
        let splitArray = command.split(separator: " ")
        switch type {
        case .none:
            break
        case .set:
            let key = String(splitArray[2])
            let value = String(splitArray[3])
            datastore.set(key: key, value: value)
            debugPrint("Setting \(value) for \(key)")
        case .get:
            let key = String(splitArray[2])
            let valueForKey = datastore.get(key: key)
            commandLog.append(valueForKey)
            if valueForKey == "key not set" {
                debugPrint("\(valueForKey) for \(key)")
            } else {
                debugPrint("Found \(valueForKey) for \(key)")
            }
        case .delete:
            let splitArray = command.split(separator: " ")
            let key = String(splitArray[2])
            datastore.delete(key: key)
            debugPrint("Deleting \(key)")
        case .count:
            let value = String(splitArray[2])
            let count = datastore.count(value: value)
            commandLog.append("\(count)")
            debugPrint("Counting \(count) keys for \(value)")
        case .begin:
            datastore.createTransaction()
            debugPrint("Begin Transaction")
        case .commit:
            if let response = datastore.commit() {
                commandLog.append("\(response)")
            }
            debugPrint("Commit")
        case .rollback:
            if let response = datastore.rollback() {
                commandLog.append("\(response)")
            }
            debugPrint("Rollback Transaction")
        }
    }
    
    func validates(type: Command, command: String) -> Bool {
        switch type {
        case .none:
            return false
        case .set:
            return false
        case .get:
            return false
        case .delete:
            return false
        case .count:
            return false
        case .begin:
            return false
        case .commit:
            return false
        case .rollback:
            return false
        }
    }
}
