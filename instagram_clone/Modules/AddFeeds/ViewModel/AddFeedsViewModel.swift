import Foundation
import PhotosUI

final class AddFeedsViewModel : ObservableObject {
    @Published var selectedImageInUrl : String?
    @Published var selectedImageInFile : [UIImage] = []
    @Published var selectedImageInData : [Data] = []
    @Published var title : String = ""
    @Published var content : String = ""
    @Published var showSuccessAlert : Bool = false
    @Published var showErrorAlert : Bool = false
    @Published var editingAddedFeed : Bool = false
    @Published var feedDeleteSuccess : Bool = false
    @Published var feedIdToEdit : Int?
    
    func uploadNewFeed()async{
        do {
            let _ : Any = try await ApiService.shared.uploadNewFeed(to: ApiEndPoints.posts, imageData: selectedImageInData, imageName: "images", title: title, content: content, as: AddFeedsModel.self)
            await MainActor.run {
                title = ""
                content = ""
                selectedImageInFile.removeAll()
                selectedImageInData.removeAll()
                showSuccessAlert = true
            }
        } catch{
            superPrint("image upload error \(error)" )
            await MainActor.run {
                showErrorAlert = true
            }
        }
    }
    
    func updateNewFeed(for postId : Int)async{
        do {
            let _ : Any = try await ApiService.shared.updateNewFeed(to: "\(ApiEndPoints.posts)/\(postId)", imageData: selectedImageInData, imageName: "images", title: title, content: content, as: AddFeedsModel.self)
            await MainActor.run {
                title = ""
                content = ""
                selectedImageInFile.removeAll()
                selectedImageInData.removeAll()
                showSuccessAlert = true
                editingAddedFeed = false
            }
        } catch{
            superPrint("image upload error \(error)" )
            showErrorAlert = true
        }
    }
    
    func deleteSelectedFeed(for feedId : Int)async{
        do{
            let response : Any = try await ApiService.shared.apiDeleteCall(from: "\(ApiEndPoints.posts)/\(feedId)", as: deleteFeedModel.self, xNeedToken: true)
            await MainActor.run {
                feedDeleteSuccess = true
            }
            superPrint(response)
        }catch{
            superPrint(error)
        }
    }
}

struct deleteFeedModel : Codable {
    let message, error : String?
}
