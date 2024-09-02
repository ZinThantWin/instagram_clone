//
//  LoginButton.swift
//  instagram_clone
//
//  Created by ကင်ဇို on 21/08/2024.
//

import SwiftUI

struct LoginButton: View {
    @EnvironmentObject private var vm : LoginViewModel
    var body: some View {
        AuthActionButton(buttonText: "Log in", loading: vm.loading,vPadding: 8, action: vm.LoginUser)
    }
}

#Preview {
    LoginButton()
}
