import SwiftUI

@main
struct instagram_cloneApp: App {
    
    @StateObject private var profileVM = ProfileViewModel.shared
    @StateObject private var registerViewModel = RegisterViewModel()
    @StateObject private var suggestedFriendVM = SuggestedFriendViewModel()
    @StateObject private var homeVM = HomeViewModel()
    @StateObject private var addFeedVM = AddFeedsViewModel()
    @StateObject private var feedsVm : FeedsViewModel = FeedsViewModel(profileVM: ProfileViewModel.shared)
    @StateObject private var loginVm = LoginViewModel(profileVM: ProfileViewModel.shared)
    @StateObject private var splashVm = SplashScreenViewModel(loginViewModel: LoginViewModel(profileVM: ProfileViewModel.shared))
    var body: some Scene {
        WindowGroup {
            SplashScreenAnimationPage()
                .environmentObject(registerViewModel)
                .environmentObject(loginVm)
                .environmentObject(feedsVm)
                .environmentObject(profileVM )
                .environmentObject(splashVm )
                .environmentObject(homeVM )
                .environmentObject(addFeedVM )
                .environmentObject(suggestedFriendVM )
        }
    }
}
