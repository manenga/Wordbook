//
//  ActionButton.swift
//  Wordbook
//
//  Created by Manenga on 2023/03/11.
//

import SwiftUI

struct ActionButton: View {
    var titleText: String
    
    private var isActive: Bool {
        guard let selectedTitle = selectedTitle else { return false }
        return titleText == selectedTitle
    }
    
    @Binding var selectedTitle: String?
    
    var action: (() -> Void)? = nil
    var activeColor: Color = .indigo
    
    var body: some View {
        Button(action: action ?? { onDefaultAction() }) {
                Text(titleText)
                    .frame(minWidth: 0)
                    .font(.system(size: 14))
                    .padding(.horizontal, 14)
                    .padding(.vertical, 5)
                    .foregroundColor(.white)
                    .overlay(
                        RoundedRectangle(cornerRadius: 7)
                            .stroke(Color.white, lineWidth: 2)
                )
            }
        .background(isActive ? activeColor : Color.gray)
            .cornerRadius(5)
    }
    
    private func onDefaultAction() {
        debugPrint("\(titleText) was tapped")
    }
    
}

//struct ActionButton_Previews: PreviewProvider {
//    static var previews: some View {
//        ActionButton(titleText: "Hello", isActive: true)
//    }
//}
