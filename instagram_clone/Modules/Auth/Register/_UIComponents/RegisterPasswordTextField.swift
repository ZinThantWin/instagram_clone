//
//  RegisterPasswordTextField.swift
//  instagram_clone
//
//  Created by ကင်ဇို on 20/08/2024.
//

import SwiftUI

struct RegisterPasswordTextField: View {
    @EnvironmentObject private var vm : RegisterViewModel
    var body: some View {
        AuthTextField(hintText: "Password", text: $vm.userPassword)
    }
}
