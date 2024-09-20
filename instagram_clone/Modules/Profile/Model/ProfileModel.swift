import Foundation

struct ProfileModel : Codable, Identifiable {
    let id : Int
    var name,email : String
    var image,bio : String?
    let createdAt : String?
    let posts : [FeedModel]
}
