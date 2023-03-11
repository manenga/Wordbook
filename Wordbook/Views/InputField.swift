//
//  InputField.swift
//  Wordbook
//
//  Created by Manenga on 2023/03/11.
//

import SwiftUI

struct InputField: View {
    @Binding var text: String
    var placeholder: String
    
    var body: some View {
        VStack {
            TextField("", text: $text)
                .autocapitalization(.none)
                .placeholder(when: text.isEmpty) {
                    Text(placeholder).foregroundColor(.indigo)
                }
                .padding(.horizontal, 5).padding(.top, 20)
            Divider().background(Color.gray)
        }
    }
}

//struct InputField_Previews: PreviewProvider {
//    static var previews: some View {
//        InputField(text: <#Binding<String>#>, placeholder: "Email")
//    }
//}
