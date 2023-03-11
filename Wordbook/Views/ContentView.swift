//
//  ContentView.swift
//  Wordbook
//
//  Created by Manenga on 2023/03/11.
//

import SwiftUI

struct ContentView: View {

    @State var selectedItem: String? = nil
    @State private var viewModel = TransactionViewModel()
    @State private var textInput = ""
    @State private var placeholder = ""
    @State private var command: Command = .none
    @State private var showingAlert = false

    var body: some View {
        VStack {
            commandStack.padding(.horizontal, 6)
            displayLog().padding(.horizontal, 6)
 
            if command == .set || command == .get
            || command == .delete || command == .count {
                inputField
            }
        }
    }

    private var inputField: some View {
        HStack {
            InputField(text: $textInput, placeholder: placeholder)
            Button(
                "Execute",
                action: {
//                    if viewModel.validates(type: command, command: textInput) {
//
                        viewModel.addCommand(
                            type: command,
                            string: textInput,
                            executed: true)
                        
                        textInput = ""
                        command = .none
                        selectedItem = ""
                    
//                    } else {
//                        textInput = ""
//                        showingAlert = true
//                        command = .none
////                        viewModel.clearMemoryLogIfExists()
//                    }
                }).foregroundColor(Color.black)
                .alert("Badly formatted command.",
                       isPresented: $showingAlert) {
                    Button("Dismiss", role: .cancel) { }
                }
            // TODO: The interface should be easily tested and extended. Interface should show alerts to confirm COMMIT, ROLLBACK or DELETE.
        }.padding(.horizontal, 5)
    }
    
    private var commandStack: some View {
        VStack {
            ScrollView(.horizontal) {
                HStack(spacing: 8) {
                    ActionButton(
                        titleText: "SET",
                        selectedTitle: $selectedItem,
                        action: {
                            command = .set
                            selectedItem = "SET"
                            placeholder = "<key> <value>"
                            viewModel.addCommand(type: .set)
                        })
                    ActionButton(
                        titleText: "GET",
                        selectedTitle: $selectedItem,
                        action: {
                            command = .get
                            selectedItem = "GET"
                            placeholder = "<key>"
                            viewModel.addCommand(type: .get)
                        })
                    ActionButton(
                        titleText: "DELETE",
                        selectedTitle: $selectedItem,
                        action: {
                            command = .delete
                            placeholder = "<key>"
                            selectedItem = "DELETE"
                            viewModel.addCommand(type: .delete)
                        })
                    ActionButton(
                        titleText: "COUNT",
                        selectedTitle: $selectedItem,
                        action: {
                            command = .count
                            selectedItem = "COUNT"
                            placeholder = "<value>"
                            viewModel.addCommand(type: .count)
                        })
                    ActionButton(
                        titleText: "BEGIN",
                        selectedTitle: $selectedItem,
                        action: {
                            command = .begin
                            selectedItem = "BEGIN"
                            viewModel.addCommand(type: .begin, executed: true)
                            textInput = ""
                            command = .none
                            selectedItem = ""
                        })
                    ActionButton(
                        titleText: "COMMIT",
                        selectedTitle: $selectedItem,
                        action: {
                            command = .commit
                            selectedItem = "COMMIT"
                            viewModel.addCommand(type: .commit, executed: true)
                            textInput = ""
                            command = .none
                            selectedItem = ""
                        })
                    ActionButton(
                        titleText: "ROLLBACK",
                        selectedTitle: $selectedItem,
                        action: {
                            command = .rollback
                            selectedItem = "ROLLBACK"
                            viewModel.addCommand(type: .rollback, executed: true)
                            textInput = ""
                            command = .none
                            selectedItem = ""
                        })
                }
            }
            Divider()
        }
    }
    
    private func displayLog() -> some View {
        ScrollViewReader { proxy in
            ScrollView {
                VStack (alignment: .leading) {
                    ForEach(Array(viewModel.commandLog.enumerated()), id: \.offset) { index, item in
                        Text(item).listRowSeparator(.hidden).id(index)
                    }
                }.frame(maxWidth: .infinity, alignment: .leading)
            }
            .onChange(of: viewModel.commandLog.count) { _ in
                if viewModel.commandLog.count > 0 {
                    proxy.scrollTo(viewModel.commandLog.count - 1)
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
