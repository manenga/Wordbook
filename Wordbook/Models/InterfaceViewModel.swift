//
//  TransactionViewModel.swift
//  Wordbook
//
//  Created by Manenga on 2023/03/11.
//

struct InterfaceViewModel {
    
    private var memoryLog = ""
    private var datastore: Datastore = Datastore()
    var commandLog: [String] = []
    
    mutating func addCommandIfValid(type: Command, string: String = "", shouldExecute: Bool = false) throws {
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
        
        guard shouldExecute else { return }
        
        if isInputValid(text: string, for: type) {
            memoryLog = ""
            execute(type: type, command: fullCommand)
        } else {
            throw ValidationErrors.badCommand
        }
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
        case .get:
            let key = String(splitArray[2])
            let valueForKey = datastore.get(key: key)
            commandLog.append(valueForKey)
        case .delete:
            let splitArray = command.split(separator: " ")
            let key = String(splitArray[2])
            datastore.delete(key: key)
        case .count:
            let value = String(splitArray[2])
            let count = datastore.count(value: value)
            commandLog.append("\(count)")
        case .begin:
            datastore.createTransaction()
        case .commit:
            if let response = datastore.commit() {
                commandLog.append("\(response)")
            }
        case .rollback:
            if let response = datastore.rollback() {
                commandLog.append("\(response)")
            }
        }
    }
    
    private func isInputValid(text: String, for type: Command) -> Bool {
        switch type {
        case .set:
            return text.trimmingCharacters(in: .whitespaces).split(separator: " ").count == 2
        case .get, .delete, .count:
            return text.trimmingCharacters(in: .whitespaces).split(separator: " ").count == 1
        default:
            return true
        }
    }
}
