import Foundation
import SwiftUI
import PhotosUI

final class ProfileViewModel: ObservableObject {
    // Shared singleton instance
    static let shared = ProfileViewModel()
    @Published var userDetail: ProfileModel?
    @Published var ownerDetail: ProfileModel?
    @Published var navigateToProfileEdit: Bool = false
    @Published var navigateToDetailEdit: Bool = false
    @Published var selectedDetailEdit : EditProfileDetailModel = SampleEditProfileDetailModel()
    
    @Published var editedName : String?
    @Published var editedBio : String?
    @Published var editedEmail : String?
    @Published var detailHasBeenEdited : Bool = false
    @Published var selectedImage : UIImage?
    @Published var selectedImageInData : Data?
    
    @Published var password : String = ""
    @Published var showPasswordSheet : Bool = false
    
    private init() {}
    
    func resetEditedData(){
        detailHasBeenEdited = false
        editedName = nil
        editedEmail = nil
        editedBio = nil
        selectedImage = nil
        selectedImageInData = nil
        password = ""
        showPasswordSheet = false
    }
    
    func getUserProfile(id: String) async -> ProfileModel? {
        do {
            let response: ProfileModel? = try await ApiService.shared.apiGetCall(from: "\(ApiEndPoints.users)/\(id)", as: ProfileModel.self, xNeedToken: true)
            if response != nil {
                await MainActor.run { [weak self] in
                    self?.userDetail = response!
                }
            }
        } catch {
            superPrint(error)
        }
        return userDetail
    }
    
    func updateUserProfile()async{
        let body = ["name": editedName ?? userDetail!.name,"email": editedEmail ?? userDetail!.email,"oldPassword" : password,"bio" : editedBio ?? userDetail!.bio ?? ""] as [String : Any]
        do{
            let _ : EditProfileModel? = try await ApiService.shared.apiUpdateImage(to: ApiEndPoints.users, imageData: selectedImageInData, imageName: "image", formFields: body, as: EditProfileModel.self, xNeedToken: true)
            let _ = await getUserProfile(id: "\(userDetail!.id)")
            await MainActor.run {
                resetEditedData()
            }
        }
        catch{
            superPrint(error)
        }
    }
}
