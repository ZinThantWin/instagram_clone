import SwiftUI

@main
struct instagram_cloneApp: App {
    @StateObject private var loginVm = LoginViewModel()
    @StateObject private var profileVM = ProfileViewModel()
    @StateObject private var registerViewModel = RegisterViewModel()
    @StateObject private var feedsVm : FeedsViewModel = FeedsViewModel(profileVM: ProfileViewModel())
    @StateObject private var userVm : UserViewModel  = UserViewModel ()
    var body: some Scene {
        WindowGroup {
            SplashScreen()
                .environmentObject(registerViewModel)
                .environmentObject(loginVm)
                .environmentObject(feedsVm)
                .environmentObject(userVm )
                .environmentObject(profileVM )
        }
    }
}
