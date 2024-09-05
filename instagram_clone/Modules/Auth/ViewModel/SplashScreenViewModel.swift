import Foundation

final class SplashScreenViewModel : ObservableObject {
    @Published var isLoggedIn = false
    private var loginViewModel : LoginViewModel
    
    init(loginViewModel: LoginViewModel) {
        self.loginViewModel = loginViewModel
    }
    
    func checkToken() async{
        let tempToken : String? = TokenManager.shared.getToken()
        superPrint("apitoken \(tempToken ?? "token is nil")")
        if tempToken != nil {
            ApiService.shared.apiToken = tempToken!
            await loginViewModel.updateMe()
            await MainActor.run {
                isLoggedIn = true
            }
        } else {
            await MainActor.run {
                isLoggedIn = false
            }
        }
    }
}
