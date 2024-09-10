import Foundation
import PhotosUI

final class AddFeedsViewModel : ObservableObject {
    @Published var selectedImage : UIImage?
    @Published var selectedImageInData : Data?
    @Published var title : String = ""
    @Published var content : String = ""
    @Published var showSuccessAlert : Bool = false
    @Published var showErrorAlert : Bool = false
    
    func uploadImage()async{
        do {
            let _ : Any = try await ApiService.shared.apiUploadImage(to: ApiEndPoints.posts, imageData: selectedImageInData!, imageName: "image", title: title, content: content, as: AddFeedsModel.self)
            await MainActor.run {
                title = ""
                content = ""
                selectedImage = nil
                selectedImageInData = nil
                showSuccessAlert = true
            }
        } catch{
            superPrint("image upload error \(error)" )
            showErrorAlert = true
        }
    }
}
