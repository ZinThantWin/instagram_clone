//
//  SuggestedFriendsViewModel.swift
//  instagram_clone
//
//  Created by ကင်ဇို on 13/09/2024.
//

import Foundation
import SwiftUI

final class SuggestedFriendViewModel : ObservableObject{
    @Published var suggestedFriendList : [SuggestedFriend] = []
    
    func getSuggestedFriendList(yourId : Int? = nil)async{
        do {
            let response = try await ApiService.shared.apiGetCall(from: ApiEndPoints.suggestedFriend, as: SuggestedFriendList.self,xNeedToken: true )
            await MainActor.run {
                withAnimation {
                    suggestedFriendList = response.data
                    suggestedFriendList.sort { a, b in
                        !a.isFollowing
                    }
                    if let profileId = yourId {
                        suggestedFriendList.removeAll { each in
                            each.id == profileId
                        }
                    }
                }
            }
        }
        catch {
            superPrint(error )
        }
    }
    
    func follow(followingId : Int)async{
        let body = ["followingId" : followingId]
        do {
            let _ = try await ApiService.shared.apiPostCall(to: ApiEndPoints.follow, body: body, as: FollowResponseModel.self, xNeedToken: true)
        } catch {
            superPrint(error)
        }
    }
    
    func unfollow(followingId : Int )async{
        let body = ["followingId" : followingId]
        do {
            let _ = try await ApiService.shared.apiPostCallAny(to: ApiEndPoints.unfollow, body: body, as: FollowResponseModel.self, xNeedToken: true)
        } catch {
            superPrint(error)
        }
    }
}

struct FollowResponseModel : Codable {
    let message : String
}
