//
//  RegisterButton.swift
//  instagram_clone
//
//  Created by ကင်ဇို on 20/08/2024.
//

import SwiftUI

struct RegisterButton: View {
    @EnvironmentObject private var vm : RegisterViewModel
    var body: some View {
        AuthActionButton(buttonText: "Register", loading: vm.loading, action: vm.registerUser)
    }
}
