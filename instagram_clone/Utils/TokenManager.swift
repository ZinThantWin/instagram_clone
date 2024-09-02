import Foundation

final class TokenManager {
    private let tokenKey = "apiToken"
    
    static let shared = TokenManager()
        
    private init() {}
    
    // Save token to UserDefaults
    func saveToken(_ token: String) {
        UserDefaults.standard.set(token, forKey: tokenKey)
    }
    
    // Retrieve token from UserDefaults
    func getToken() -> String? {
        return UserDefaults.standard.string(forKey: tokenKey)
    }
    
    // Delete token from UserDefaults
    func deleteToken() {
        superPrint("deleting saved token")
        UserDefaults.standard.removeObject(forKey: tokenKey)
    }
}
