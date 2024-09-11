import Foundation

final class FeedsViewModel : ObservableObject{
    @Published var allFeedList : FeedListModel?
    @Published var selectedFeed : FeedModel?
    @Published var showCommentSheet : Bool = false
    @Published var showProfileFullScreenCover : Bool = false
    @Published var showReactionRow : Bool = false
    @Published var selectedProfileDetail : ProfileModel?
    private var profileVM: ProfileViewModel
    @Published var searchFeeds : String = ""
    @Published var commentToAdd : String = ""
    
    init(profileVM: ProfileViewModel) {
        self.profileVM = profileVM
    }
    
    func createNewComment(for postId : Int,comment : String )async{
        let body = ["postId" : postId,
                    "content" : comment] as [String : Any]
        do{
            let _ : Any  = try await ApiService.shared.apiPostCallAny(to: ApiEndPoints.comment, body: body, as: commentResponseModel.self, xNeedToken: true)
        }
        catch{
            superPrint(error)
        }
    }
    
    func getSelectedProfileDetail(id : String)async {
        let response : ProfileModel?  = await profileVM.getUserProfile(id: id)
        superPrint(response)
        await MainActor.run {
            selectedProfileDetail = response
            if selectedProfileDetail != nil {
                showProfileFullScreenCover = true
            }
        }
    }
    
    func getAllFeedList () async {
        do{
            let tempList : FeedListModel? = try await ApiService.shared.apiGetCall(from: ApiEndPoints.posts, as: FeedListModel.self,xNeedToken: true )
            assignRandomRanking(to: tempList)
            await MainActor.run {[weak self] in
                self?.allFeedList = tempList
            }
        }catch{
            superPrint("all posts failed \(error)")
        }
    }
    
    func onTapViewComments(_ selectedFeed : FeedModel ){
        self.selectedFeed = selectedFeed
        showCommentSheet = true
    }
    
    struct ReactionRequest: Encodable {
        let postId: Int
        let reactionType: String
    }
    
    func giveReaction(reactionType: Reaction,postId : Int ) async {
        let requestBody = ["postId": postId, "reactionType": reactionType.name(for: .reacted)] as [String : Any]
        do {
            let _: ReactionResponseModel = try await ApiService.shared.apiPostCallAny(to: ApiEndPoints.reaction, body: requestBody, as: ReactionResponseModel.self, xNeedToken: true)
            await getAllFeedList()
        } catch {
            superPrint(error)
        }
    }
    
    private func assignRandomRanking(to feedList: FeedListModel?) {
        // Ensure feedList is not nil
        guard var feedList = feedList else { return }
        
        // Loop through each feed and assign a random ranking if needed
        for index in feedList.data.indices {
            if feedList.data[index].ranking == nil {
                feedList.data[index].ranking = Int.random(in: 1...3)
            }
        }
    }
}

struct commentResponseModel : Codable {
    let id : Int
}
