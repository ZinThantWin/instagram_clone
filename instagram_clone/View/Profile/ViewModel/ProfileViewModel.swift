import Foundation

final class ProfileViewModel : ObservableObject {
    @Published var userDetail : ProfileModel?
    
    func getUserProfile(id : String) async -> ProfileModel? {
        await MainActor.run { [weak self] in
            self?.userDetail = nil 
        }
        do {
            let response : ProfileModel? = try await ApiService.shared.apiGetCall(from: "\(ApiEndPoints.users)/\(id)", as: ProfileModel.self,xNeedToken: true )
            await MainActor.run { [weak self] in 
                self?.userDetail = response
            }
        }catch{
            superPrint(error)
        }
        return userDetail
    }
}
