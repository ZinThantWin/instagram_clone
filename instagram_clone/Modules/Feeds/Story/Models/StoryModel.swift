import Foundation


struct StoryModel : Codable{
    let id: Int
    let content: String
    let image: String?
    let createdAt: String 
    let expiresAt: String
    let author : AuthorModel
}
