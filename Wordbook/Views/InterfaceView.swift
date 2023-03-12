//
//  InterfaceView.swift
//  Wordbook
//
//  Created by Manenga on 2023/03/11.
//

import SwiftUI

struct InterfaceView: View {

    @State var selectedItem: String? = nil
    @State private var viewModel = InterfaceViewModel()
    @State private var textInput = ""
    @State private var placeholder = ""
    @State private var command: Command = .none
    @State private var showingCommitAlert = false
    @State private var showingDeleteAlert = false
    @State private var showingRollbackAlert = false
    @FocusState private var inputFieldIsFocused: Bool
    
    var body: some View {
        VStack(alignment: .leading) {
            commandStack.padding(.horizontal, 6)
            displayLog().padding(.horizontal, 6)

            if command == .set || command == .get
            || command == .delete || command == .count {
                inputField.focused($inputFieldIsFocused)
            }
            Spacer()
        }
        .padding(.bottom, 5)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.white)
    }

    private var inputField: some View {
        HStack {
            InputField(text: $textInput, placeholder: placeholder)
            Button(
                "Execute",
                action: {
                    onExecute()
                }).foregroundColor(Color.black)
                .alert("Are you sure you want to commit this transaction?",
                       isPresented: $showingCommitAlert) {
                    Button("Dismiss", role: .cancel) {
                        command = .none
                        selectedItem = ""
                        showingCommitAlert = false
                    }
                    Button("Commit", role: .none) {
                        viewModel.addCommandIfValid(type: .commit, shouldExecute: true)
                        showingCommitAlert = false
                    }
                }
               .alert("Are you sure you want to delete this key?",
                      isPresented: $showingDeleteAlert) {
                   Button("Dismiss", role: .cancel) {
                       command = .none
                       selectedItem = ""
                       showingDeleteAlert = false
                   }
                   Button("Delete", role: .none) {
                       viewModel.addCommandIfValid(
                        type: .delete,
                           string: textInput,
                           shouldExecute: true)
                        showingDeleteAlert = false
                   }
               }
              .alert("Are you sure you want to rollback this transaction?",
                     isPresented: $showingRollbackAlert) {
                  Button("Dismiss", role: .cancel) {
                      command = .none
                      selectedItem = ""
                      showingRollbackAlert = false
                  }
                  Button("Rollback", role: .none) {
                      viewModel.addCommandIfValid(type: .rollback, shouldExecute: true)
                      showingRollbackAlert = false
                  }
              }
        }.padding(.horizontal, 5)
    }
    
    private var commandStack: some View {
        VStack {
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 8) {
                    ActionButton(
                        titleText: "SET",
                        selectedTitle: $selectedItem,
                        action: {
                            command = .set
                            onAction()
                        })
                    ActionButton(
                        titleText: "GET",
                        selectedTitle: $selectedItem,
                        action: {
                            command = .get
                            onAction()
                        })
                    ActionButton(
                        titleText: "DELETE",
                        selectedTitle: $selectedItem,
                        action: {
                            command = .delete
                            onAction()
                        })
                    ActionButton(
                        titleText: "COUNT",
                        selectedTitle: $selectedItem,
                        action: {
                            command = .count
                            onAction()
                        })
                    ActionButton(
                        titleText: "BEGIN",
                        selectedTitle: $selectedItem,
                        action: {
                            command = .begin
                            onAction()
                        })
                    ActionButton(
                        titleText: "COMMIT",
                        selectedTitle: $selectedItem,
                        action: {
                            command = .commit
                            onAction()
                        })
                    ActionButton(
                        titleText: "ROLLBACK",
                        selectedTitle: $selectedItem,
                        action: {
                            command = .rollback
                            onAction()
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
                        Text(item)
                            .id(index)
                            .foregroundColor(.black)
                            .listRowSeparator(.hidden)
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
    
    private func onAction() {
        switch command {
        case .none:
            break
        case .set:
            selectedItem = "SET"
            inputFieldIsFocused = true
            placeholder = "<key> <value>"
            viewModel.addCommandIfValid(type: .set)
        case .get:
            selectedItem = "GET"
            placeholder = "<key>"
            inputFieldIsFocused = true
            viewModel.addCommandIfValid(type: .get)
        case .delete:
            placeholder = "<key>"
            selectedItem = "DELETE"
            inputFieldIsFocused = true
            viewModel.addCommandIfValid(type: .delete)
        case .count:
            selectedItem = "COUNT"
            placeholder = "<value>"
            inputFieldIsFocused = true
            viewModel.addCommandIfValid(type: .count)
        case .begin:
            textInput = ""
            selectedItem = "BEGIN"
            viewModel.addCommandIfValid(type: .begin, shouldExecute: true)
        case .commit:
            textInput = ""
            selectedItem = "COMMIT"
            presentConfirmationAlert()
        case .rollback:
            textInput = ""
            selectedItem = "ROLLBACK"
            presentConfirmationAlert()
        }
    }
    
    // TODO: The interface should be easily tested and extended. Interface should show alerts to confirm COMMIT, ROLLBACK or DELETE.
    
    private func presentConfirmationAlert() {
        if command == .commit {
            showingCommitAlert = true
        } else if command == .rollback {
            showingRollbackAlert = true
        } else if command == .delete {
            showingDeleteAlert = true
        }
    }
    
    private func onExecute() {
        if command == .delete {
            presentConfirmationAlert()
        } else {
            viewModel.addCommandIfValid(
                type: command,
                string: textInput,
                shouldExecute: true)
        }
        textInput = ""
        command = .none
        selectedItem = ""
    }
}

struct InterfaceView_Previews: PreviewProvider {
    static var previews: some View {
        InterfaceView()
    }
}
