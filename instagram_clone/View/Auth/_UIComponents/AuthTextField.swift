//
//  RegisterEmailTextField.swift
//  instagram_clone
//
//  Created by ကင်ဇို on 20/08/2024.
//

import SwiftUI

struct AuthTextField: View {
    var hintText: String
    @Binding var text : String 
    var body: some View {
        VStack{
            TextField(hintText, text: $text)
                .padding(.horizontal,10)
                .padding(.vertical,18)
                .background(AppColors.authTextFieldBGColor)
                .cornerRadius(10)
                .font(.custom("HelveticaNeue", size: 15))
                .foregroundColor(.primary)
                .textInputAutocapitalization(.never)
                .autocorrectionDisabled(true)
                .overlay(
                    RoundedRectangle(cornerRadius: 8+2)
                        .stroke(AppColors.authTextFieldBorderColor, lineWidth: 1.5))
        }
    }
}
