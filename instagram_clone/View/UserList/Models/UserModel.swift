import Foundation

struct UserModelList : Codable {
    let data : [UserModel]
}

struct UserModel : Codable {
    let id : Int 
    let name : String
    let image : String?
    let bio : String?
}
