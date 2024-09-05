//
//  SplashScreen.swift
//  instagram_clone
//
//  Created by ကင်ဇို on 19/08/2024.
//

import SwiftUI

struct SplashScreen: View {
    @EnvironmentObject private var viewModel : SplashScreenViewModel
    var body: some View {
        Group{
            if viewModel.isLoggedIn {
                HomePage()
            }else{
                LoginPage()
            }
        }.onAppear{
//            TokenManager.shared.deleteToken()
            Task{
                await viewModel.checkToken()
            }
        }
    }
}

#Preview {
    SplashScreen()
}
