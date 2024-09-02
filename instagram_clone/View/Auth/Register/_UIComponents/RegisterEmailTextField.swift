//
//  RegisterEmailTextField.swift
//  instagram_clone
//
//  Created by ကင်ဇို on 20/08/2024.
//

import SwiftUI

struct RegisterEmailTextField: View {
    @EnvironmentObject private var vm : RegisterViewModel
    var body: some View {
        VStack{
            AuthTextField(hintText: "Email", text: $vm.userEmail)
        }
    }
}

#Preview {
    RegisterEmailTextField().environmentObject(RegisterViewModel())
}
