import Foundation

final class SplashScreenViewModel : ObservableObject {
    @Published var isLoggedIn = false
    func checkToken(){
        let tempToken : String? = TokenManager.shared.getToken()
        superPrint("apitoken \(tempToken ?? "token is nil")")
        if tempToken != nil {
            ApiService.shared.apiToken = tempToken!
            isLoggedIn = true
        } else {
            isLoggedIn = false
        }
    }
}
