import Foundation

final class LoginViewModel: ObservableObject {
    @Published var loginEmail : String = "insta@gmail.com"
    @Published var loginPassword : String = "insta"
    @Published var loading : Bool = false
    @Published var loginSuccess : Bool = false
    @Published var logInModel : LoginModel?
    @Published var userProfile : ProfileModel?
    private var profileVM: ProfileViewModel
    
    init(profileVM: ProfileViewModel) {
        self.profileVM = profileVM
    }
    
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
            await updateMe()
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
    
    func updateMe()async{
        do {
            let response : ProfileModel? = try await ApiService.shared.apiGetCall(from: ApiEndPoints.validateUser, as: ProfileModel.self, xNeedToken: true )
            await MainActor.run { [weak self] in 
                self?.userProfile = response
                self?.profileVM.userDetail = response
                self?.profileVM.ownerDetail = response
            }
        }catch {
            superPrint("update me error \(error)")
        }
    }
}
