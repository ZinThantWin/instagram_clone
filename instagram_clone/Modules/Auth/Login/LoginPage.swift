//
//  LoginPage.swift
//  instagram_clone
//
//  Created by ကင်ဇို on 21/08/2024.
//

import SwiftUI

struct LoginPage: View {
    @EnvironmentObject private var loginViewModel : LoginViewModel
    var body: some View {
        NavigationStack{
            ZStack{
                AuthBGView()
                VStack{
                    Spacer()
                    Image.appLogo(named: "insta_logo", width: 100, height: 100)
                        .padding(.bottom, 50)
                    LoginEmailTextField()
                    LoginPasswordTextField().padding(.vertical,5)
                    LoginButton()
                    Spacer()
                    RegisterPageRouteButton()
                    Image.appLogo(named: "meta_logo", width: 200, height: 50)
                }.padding(.horizontal,20)
                ToastView(message: "Login success", isPresented: $loginViewModel.loginSuccess)
            }.navigationDestination(isPresented: $loginViewModel.loginSuccess) {
                HomePage()
            }
        }
        
    }
}
