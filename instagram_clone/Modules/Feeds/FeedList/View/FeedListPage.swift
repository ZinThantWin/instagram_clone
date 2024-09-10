import SwiftUI

struct FeedListPage: View {
    @EnvironmentObject var vm: FeedsViewModel
    @EnvironmentObject var loginViewModel: LoginViewModel
    @EnvironmentObject var profileViewModel: ProfileViewModel
    @EnvironmentObject var homeViewModel: HomeViewModel
    
    var body: some View {
        NavigationView {
            NavigationStack {
                ScrollView {
                    LazyVStack {
                        if let feeds = vm.allFeedList?.data {
                            ForEach(feeds, id: \.id) { feed in
                                EachFeedView(eachFeed: feed,
                                             onTapComments: { onTapComments(feed) },
                                             onTapProfile: { onTapProfile(feed) },
                                             onTapReaction: { onTapReaction(feed) },
                                             onLongPressReaction: { vm.showReactionRow = true },
                                             onReactionSelected: { reaction in onReactionSelected(reaction, feed) },
                                             onTapEditFeed: {
                                    onEditFeed(feed) },
                                             yourFeed: feed.author?.id == profileViewModel.userDetail?.id,
                                             showReactions: $vm.showReactionRow)
                            }
                        } else {
                            Text("No feeds available.")
                                .foregroundColor(.gray)
                        }
                    }
                }
                .sheet(isPresented: $vm.showCommentSheet, content: {
                    if let selectedFeed = vm.selectedFeed {
                        CommentsSheet(comments: selectedFeed.comments, authorName: "Ko Zin", userName: "dummy User name", userImageUrl: "")
                            .presentationDetents([.medium, .large])
                            .presentationDragIndicator(.hidden)
                    }
                })
                .refreshable {
                    Task {
                        await vm.getAllFeedList()
                    }
                }
                .navigationTitle("Instagram")
                .onAppear {
                    Task {
                        await vm.getAllFeedList()
                    }
                }
            }
        }
    }
    
    private func onTapComments(_ feed: FeedModel) {
        vm.onTapViewComments(feed)
    }
    
    private func onTapProfile(_ feed: FeedModel) {
        Task {
            await vm.getSelectedProfileDetail(id: String(feed.id))
        }
    }
    
    private func onEditFeed(_ feed: FeedModel) {
        homeViewModel.moveTo(destination: .add)
    }
    private func onTapReaction(_ feed: FeedModel) {
        Task {
            await vm.giveReaction(reactionType: .love, postId: feed.id)
        }
    }
    
    private func onReactionSelected(_ reaction: Reaction, _ feed: FeedModel) {
        Task {
            await vm.giveReaction(reactionType: reaction, postId: feed.id)
            vm.showReactionRow = false
        }
    }
}
