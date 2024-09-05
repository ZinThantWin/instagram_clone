import Foundation

struct FeedListModel : Codable {
    var data : [FeedModel]
}

struct Comment : Codable {
    let id : Int
    let content: String
    let authorName : String
    let updatedAt : String 
}

struct FeedModel: Codable {
    let id: Int
    let title: String
    let content: String?
    let authorId: Int?
    let authorName : String?
    let image: String?
    let createdAt: String
    let reactionCount: Int?
    let comments : [Comment]
    var ranking : Int? = Int.random(in: 1...3)
}

struct sampleFeedModel {
    static let sampleFeedModel = FeedModel(id: 1, title: "sample title", content: "This is sample content", authorId: 1, authorName: "dummy author", image: "/uploads/1723630534266.jpg", createdAt: "2024-08-14T10:15:34.589Z", reactionCount: 3,comments: [Comment(id: 1, content: "dummy comment", authorName: "dummny commentor", updatedAt: "2024-08-14T10:17:16.205Z"),Comment(id: 2, content: "dummy comment2", authorName: "dummny commentor2", updatedAt: "2024-08-14T20:17:16.205Z"),Comment(id: 3, content: "dummy comment3", authorName: "dummny commentor3", updatedAt: "2024-08-14T20:17:16.205Z"),Comment(id: 4, content: "dummy comment4", authorName: "dummny commentor4", updatedAt: "2024-08-14T20:17:16.205Z"),Comment(id: 5, content: "dummy comment5", authorName: "dummny commentor5", updatedAt: "2024-08-14T20:17:16.205Z")])
}
