//
//  LoginPasswordTextField.swift
//  instagram_clone
//
//  Created by ကင်ဇို on 21/08/2024.
//

import SwiftUI

struct LoginPasswordTextField: View {
    @EnvironmentObject private var vm : LoginViewModel
    var body: some View {
        AuthTextField(hintText: "Password", text: $vm.loginPassword)
    }
}
