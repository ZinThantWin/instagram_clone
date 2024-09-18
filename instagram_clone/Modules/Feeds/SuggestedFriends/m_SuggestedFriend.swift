import Foundation

struct SuggestedFriendList : Codable{
    let data : [SuggestedFriend]
}

struct SuggestedFriend : Codable {
    let id : Int
    let name : String
    let image, bio : String?
    var isFollowing : Bool
}
