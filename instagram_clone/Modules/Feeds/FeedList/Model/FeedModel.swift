import Foundation

struct FeedListModel : Codable {
    var data : [FeedModel]
}

struct AllReactionModel : Codable {
    let count : Int?
    let users : [AuthorModel]
}

struct ShareByModel : Codable {
    let author : AuthorModel
}

struct ReactionModel : Codable , Identifiable {
    let id: UUID = UUID()
    let all : AllReactionModel
    let like, love , haha , sad : [AuthorModel]
    let angry : [AuthorModel]
}

struct Comment : Codable {
    let id : Int
    let content: String
    let author : AuthorModel
    let updatedAt : String?
    let isEdited : Bool?
}

struct AuthorModel : Codable {
    let id : Int
    let name : String
    let image : String?
}

struct FeedModel: Codable {
    let id: Int
    let title: String
    let content: String?
    let author : AuthorModel?
    let shareByUser : ShareByModel?
    let images: [String]
    let createdAt: String?
    let reactionCount: Int?
    let isEdited : Bool?
    var comments : [Comment]
    var ranking : Int? = Int.random(in: 1...3)
    let reactions : ReactionModel?
    var userReactonType : String?
}

struct sampleFeedModel {
    static let sampleFeedModel = FeedModel(id: 1, title: "sample title", content: "This is sample content", author: AuthorModel(id: 23, name: "dummy author", image: ""), shareByUser: nil , images: ["/uploads/1723630534266.jpg"], createdAt: "2024-08-14T10:15:34.589Z", reactionCount: 3,isEdited: true,comments: [Comment(id: 10, content: "ဖုန်ရှုလိုက်", author: AuthorModel(id: 1, name: "Dummy commenter", image: nil),updatedAt: "2024-09-07T04:36:28.272Z", isEdited : false)],reactions:  ReactionModel(all: AllReactionModel(count: 1, users: [AuthorModel(id: 1, name: "", image: nil )]), like: [AuthorModel(id: 1, name: "", image: nil )], love: [AuthorModel(id: 1, name: "", image: nil )], haha: [AuthorModel(id: 1, name: "", image: nil )], sad: [AuthorModel(id: 1, name: "", image: nil )],angry: [AuthorModel(id: 1, name: "", image: nil )]))
}
