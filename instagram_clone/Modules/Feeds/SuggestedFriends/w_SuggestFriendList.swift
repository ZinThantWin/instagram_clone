//
//  w_SuggestFriendList.swift
//  instagram_clone
//
//  Created by ကင်ဇို on 13/09/2024.
//

import SwiftUI

struct SuggestFriendListView: View {
    @EnvironmentObject private var vm : SuggestedFriendViewModel
    @EnvironmentObject private var feedsVm : FeedsViewModel
    @EnvironmentObject private var profileVm : ProfileViewModel
    var body: some View {
        VStack{
            ScrollView(.horizontal){
                LazyHStack {
                    ForEach($vm.suggestedFriendList,id: \.id){$each in
                        EachSuggestedFriendView(each : $each, onFollowButtonTap: {
                            Task{
                                each.isFollowing ? await vm.unfollow(followingId: each.id) : await vm.follow(followingId: each.id)
                                await vm.getSuggestedFriendList(yourId: profileVm.ownerDetail?.id)
                                await feedsVm.getFollowedFeedList()
                            }
                        })
                    }
                }
                .padding(.horizontal,10)
            }
        }
        .scrollIndicators(.never)
        .onAppear{
            Task{
                await vm.getSuggestedFriendList(yourId: profileVm.ownerDetail?.id)
            }
        }
    }
}
