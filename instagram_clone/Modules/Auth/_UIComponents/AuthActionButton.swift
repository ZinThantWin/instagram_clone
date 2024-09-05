//
//  RegisterButton.swift
//  instagram_clone
//
//  Created by ကင်ဇို on 20/08/2024.
//

import SwiftUI

struct AuthActionButton: View {
    var buttonText: String
    var loading: Bool
    var vPadding: Double = 15
    var hPadding: Double = 15
    var action: ()async ->   Void
    @EnvironmentObject private var vm : RegisterViewModel
    var body: some View {
        if loading  {
            ProgressView()
                .progressViewStyle(CircularProgressViewStyle())
                .padding()
        } else {
            Button(action: {
                Task {
                    await action()
                }
            }) {
                Text(buttonText)
                    .padding(.horizontal,hPadding)
                    .padding(.vertical,vPadding)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity).background(AppColors.authButtonColor).cornerRadius(20)
            }
        }
    }
}
