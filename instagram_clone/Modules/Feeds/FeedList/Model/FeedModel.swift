import Foundation

struct FeedListModel : Codable {
    var data : [FeedModel]
}

struct AllReactionModel : Codable {
    let count : Int?
    let users : [AuthorModel]
}

struct ReactionModel : Codable {
    let all : AllReactionModel
    let like, love , haha , sad : [AuthorModel]
    let angry : [AuthorModel]
}

struct Comment : Codable {
    let id : Int
    let content: String
    let author : AuthorModel
    let updatedAt : String?
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
    let image: String?
    let createdAt: String?
    let reactionCount: Int?
    let comments : [Comment]
    var ranking : Int? = Int.random(in: 1...3)
    let reactions : ReactionModel?
    var userReactonType : String?
}

struct sampleFeedModel {
    static let sampleFeedModel = FeedModel(id: 1, title: "sample title", content: "This is sample content", author: AuthorModel(id: 23, name: "dummy author", image: ""), image: "/uploads/1723630534266.jpg", createdAt: "2024-08-14T10:15:34.589Z", reactionCount: 3,comments: [Comment(id: 10, content: "ဖုန်ရှုလိုက်", author: AuthorModel(id: 1, name: "Dummy commenter", image: nil), updatedAt: "2024-09-07T04:36:28.272Z")],reactions:  ReactionModel(all: AllReactionModel(count: 1, users: [AuthorModel(id: 1, name: "", image: nil )]), like: [AuthorModel(id: 1, name: "", image: nil )], love: [AuthorModel(id: 1, name: "", image: nil )], haha: [AuthorModel(id: 1, name: "", image: nil )], sad: [AuthorModel(id: 1, name: "", image: nil )],angry: [AuthorModel(id: 1, name: "", image: nil )]))
}
