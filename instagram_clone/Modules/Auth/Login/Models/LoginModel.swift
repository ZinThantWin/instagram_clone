import Foundation

struct LoginModel : Codable{
    let tokenID : LogInCredentialModel
}

struct LogInCredentialModel  : Codable{
    let token : String
    let userId: Int
}
