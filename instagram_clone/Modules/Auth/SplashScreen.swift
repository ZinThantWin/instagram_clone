//
//  SplashScreen.swift
//  instagram_clone
//
//  Created by ကင်ဇို on 19/08/2024.
//

import SwiftUI

struct SplashScreen: View {
    @EnvironmentObject private var splashViewModel : SplashScreenViewModel
    @EnvironmentObject private var homeViewModel : HomeViewModel
    var body: some View {
        Group{
            if splashViewModel.isLoggedIn {
                HomePage()
            }else{
                LoginPage()
            }
        }.onAppear{
//            TokenManager.shared.deleteToken()
            Task{
                await splashViewModel.checkToken()
            }
        }
    }
}

#Preview {
    SplashScreen()
}
