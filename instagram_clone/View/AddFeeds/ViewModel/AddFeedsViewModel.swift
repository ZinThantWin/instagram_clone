import Foundation
import PhotosUI

final class AddFeedsViewModel : ObservableObject {
    @Published var selectedImage : UIImage?
    @Published var selectedImageInData : Data?
    @Published var title : String = "fixing"
    @Published var content : String = "image issue"
    
    func uploadImage()async{
        do {
            let response : Any = try await ApiService.shared.apiUploadImage(to: ApiEndPoints.posts, imageData: selectedImageInData!, imageName: "image", title: title, content: content, as: AddFeedsModel.self)
            superPrint("image upload success \(response)")
        } catch{
            superPrint("image upload error \(error)" )
        }
    }
}
