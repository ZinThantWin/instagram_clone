import Foundation

struct ProfileModel : Codable {
    let id : Int
    var name,email : String
    var image,bio : String?
    let createdAt : String
    let posts : [FeedModel]
}
