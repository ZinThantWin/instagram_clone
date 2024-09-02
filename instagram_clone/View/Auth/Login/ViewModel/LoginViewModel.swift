import Foundation

final class LoginViewModel: ObservableObject {
    @Published var loginEmail : String = "passwords@gmail.com"
    @Published var loginPassword : String = "passwords"
    @Published var loading : Bool = false
    @Published var loginSuccess : Bool = false
    @Published var logInModel : LoginModel?
    
    func LoginUser()async{
        await MainActor.run {
            loading = true
        }
        let body = ["email": loginEmail, "password": loginPassword]
        do{
            let loginModel  : LoginModel = try await ApiService.shared.apiPostCall(to: ApiEndPoints.logInUser, body: body, as: LoginModel.self,xNeedToken: false)
            await MainActor.run {
                self.logInModel = loginModel
            }
            ApiService.shared.apiToken = loginModel.tokenID.token
            TokenManager.shared.saveToken(loginModel.tokenID.token)
            await MainActor.run {
                loading = false
                loginSuccess = true
            }
        }catch{
            superPrint(error)
            await MainActor.run {
                loading = false
            }
        }
    }
}
