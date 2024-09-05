import Foundation

struct ProfileModel : Codable {
    let id : Int
    let name : String
    let email : String
    let image : String?
    let bio : String?
    let createdAt : String
    let posts : [FeedModel]
}

func  SampleProfileModel() -> ProfileModel {
    return ProfileModel(id: 1, name: "Testing", email: "zinthantwin@gmail.com", image: Optional("/uploads/1725015540819.jpg"), bio: Optional("Mobile Developer"), createdAt: "2024-08-27T08:12:31.752Z", posts: [instagram_clone.FeedModel(id: 17, title: "dynamic mr br nyr", content: Optional("chilling with tiger 2 + 1 and r lu kyaw"), authorId: nil, authorName: nil, image: Optional("/uploads/1724923794084.jfif"), createdAt: "2024-08-29T09:29:54.098Z", reactionCount: Optional(0), comments: [], ranking: nil), instagram_clone.FeedModel(id: 15, title: "chilling in dynamic", content: Optional("chilling with tiger 2 + 1"), authorId: nil, authorName: nil, image: Optional("/uploads/1724924114071.jpg"), createdAt: "2024-08-29T09:25:51.431Z", reactionCount: Optional(0), comments: [], ranking: nil), instagram_clone.FeedModel(id: 13, title: "go to dynamic", content: Optional("chilling with tiger ahee"), authorId: nil, authorName: nil, image: Optional("/uploads/1724924114071.jpg"), createdAt: "2024-08-29T07:53:20.467Z", reactionCount: Optional(0), comments: [], ranking: nil), instagram_clone.FeedModel(id: 21, title: "dynamic mr br nyr kwe kwa", content: Optional("chilling with tiger 2 + 1 and  myay pl hlaw"), authorId: nil, authorName: nil, image: Optional("/uploads/1724924114071.jpg"), createdAt: "2024-08-29T09:35:14.078Z", reactionCount: Optional(0), comments: [], ranking: nil), instagram_clone.FeedModel(id: 16, title: "dynamic mr br nyr", content: Optional("chilling with tiger 2 + 1 and r lu kyaw"), authorId: nil, authorName: nil, image: Optional("/uploads/1724994197402.jpg"), createdAt: "2024-08-29T09:29:16.124Z", reactionCount: Optional(0), comments: [], ranking: nil), instagram_clone.FeedModel(id: 35, title: "fixing", content: Optional("image issue"), authorId: nil, authorName: nil, image: Optional("/uploads/1725002953446.image"), createdAt: "2024-08-30T07:29:13.451Z", reactionCount: Optional(0), comments: [instagram_clone.Comment(id: 5, content: "image issue is so fine", authorName: "Zin Thant Win", updatedAt: "2024-08-30T10:10:06.207Z")], ranking: nil)]);
}
