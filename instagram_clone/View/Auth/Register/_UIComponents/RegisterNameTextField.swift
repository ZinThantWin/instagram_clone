//
//  RegisterEmailTextField.swift
//  instagram_clone
//
//  Created by ကင်ဇို on 20/08/2024.
//

import SwiftUI

struct RegisterNameTextField: View {
    @EnvironmentObject private var vm : RegisterViewModel
    var body: some View {
        VStack{
            AuthTextField(hintText: "Enter your name", text: $vm.userName)
        }
    }
}

#Preview {
    RegisterEmailTextField().environmentObject(RegisterViewModel())
}
