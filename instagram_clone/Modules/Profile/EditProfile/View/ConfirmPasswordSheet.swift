//
//  ConfirmPasswordSheet.swift
//  instagram_clone
//
//  Created by ကင်ဇို on 05/09/2024.
//

import SwiftUI

struct ConfirmPasswordSheet: View {
    @EnvironmentObject private var vm : ProfileViewModel
    var body: some View {
        TextField("Enter your password", text: $vm.password)
            .autocorrectionDisabled(true)
            .textInputAutocapitalization(.never)
            .padding()
        Button{
            Task{
                await vm.updateUserProfile()
            }
        }label: {
            Text("Update profile")
                .foregroundColor(.white)
                .padding(.horizontal,30)
                .padding(.vertical,8)
                .background(Color.blue)
                .cornerRadius(5)
        }
    }
}

#Preview {
    ConfirmPasswordSheet()
}
