//
//  ProfilePage.swift
//  instagram_clone
//
//  Created by ကင်ဇို on 30/08/2024.
//

import SwiftUI

struct ProfilePage: View {
    @EnvironmentObject private var vm : ProfileViewModel
    @EnvironmentObject private var loginVM : LoginViewModel
    var body: some View {
        ZStack{
            if let profile = vm.userDetail {
                ProfileDetailView(profile: profile)
            }else {
                Text("fetching data")
            }
        }
        .onAppear{
            Task{
                await vm.getUserProfile(id: "77")
            }
        }
    }
    
}
