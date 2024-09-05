import Foundation

final class ProfileViewModel: ObservableObject {
    // Shared singleton instance
    static let shared = ProfileViewModel()
    
    @Published var userDetail: ProfileModel?
    @Published var navigateToProfileEdit: Bool = false

    // Private initializer to prevent external instantiation
    private init() {}

    func getUserProfile(id: String) async -> ProfileModel? {
        do {
            let response: ProfileModel? = try await ApiService.shared.apiGetCall(from: "\(ApiEndPoints.users)/\(id)", as: ProfileModel.self, xNeedToken: true)
            if response != nil {
                await MainActor.run { [weak self] in
                    self?.userDetail = response!
                }
            }
        } catch {
            superPrint(error)
        }
        return userDetail
    }
}
