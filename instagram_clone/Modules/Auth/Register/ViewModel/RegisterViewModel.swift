import SwiftUI
import Combine

final class RegisterViewModel: ObservableObject {
    @Published var userName: String = ""
    @Published var userEmail: String = ""
    @Published var userPassword: String = ""
    @Published var loading: Bool = false
    @Published var registerSuccess : Bool = false
    
    func resetValues() {
        userName = ""
        userEmail = ""
        userPassword = ""
        loading = false
        registerSuccess = false
    }
    
    @MainActor
    func registerUser() async {
        loading = true
        
        let body = ["name": userName, "email": userEmail, "password": userPassword]
        
        superPrint(body)
        
        do{
            let _ : Any = try await ApiService.shared.apiPostCall(to : ApiEndPoints.registerUser,body: body, as: RegisterModel.self,xNeedToken: false);
            registerSuccess = true
            await MainActor.run {
                resetValues()
            }
        }catch{
            await MainActor.run {
                resetValues()
            }
            superPrint(error)
        }
        
    }


}
