import SwiftUI

struct FeedListPage: View {
    @EnvironmentObject var vm: FeedsViewModel
    @EnvironmentObject var loginViewModel: LoginViewModel
    @EnvironmentObject var profileViewModel: ProfileViewModel
    @EnvironmentObject var homeViewModel: HomeViewModel
    @EnvironmentObject var addFeedVm: AddFeedsViewModel
    @State private var postDeleteSuccess : Bool = false
    
    var body: some View {
        NavigationView {
            NavigationStack {
                ScrollView {
                    LazyVStack {
                        SuggestFriendListView()
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
                                             onTapDeleteFeed: {
                                    onDeleteFeed(feed) },
                                             onTapReactionCount: {
                                    onTapReactionCount(reactionModel: feed.reactions)
                                },
                                             showReactions: $vm.showReactionRow)
                            }
                        } else {
                            Text("No feeds available.")
                                .foregroundColor(.gray)
                        }
                    }
                }
                .scrollIndicators(.hidden)
                .alert(isPresented: $postDeleteSuccess, content: {
                    Alert(title: Text("selected feed deleted successfully!"))
                })
                .sheet(item: $vm.selectedReaction, content: { selectedReaction in
                    AllReactionSheet(reactionModel: selectedReaction,onTap: { id in
                        onTap(id)
                    })
                    .presentationDetents([.medium, .large])
                    .presentationDragIndicator(.hidden)
                })
                .sheet(isPresented: $vm.showCommentSheet, content: {
                    if let feed = vm.selectedFeed {
                        CommentsSheet(onTapCommentReaction: { reaction in
                            onAddComments(for: feed, comment: "\(reaction.name()).emoji")
                        }, onAddComment: {addedComment in
                            onAddComments(for: feed, comment: addedComment)
                        }, onUpdateComment : {updatedComment,commentId in
                            onUpdateComments(for: feed , comment: updatedComment, commentId: 1)
                        }, onDeleteComment: { commentId  in
                            onDeleteComment(commentId)
                        })
                        .presentationDetents([.medium, .large])
                        .presentationDragIndicator(.hidden)
                    }
                })
                .refreshable {
                    Task {
                        await vm.getFollowedFeedList()
                    }
                }
                .navigationTitle("Instagram")
                .onAppear {
                    Task {
                        await vm.getFollowedFeedList()
                    }
                }
            }
        }
    }
    
    private func onAddComments(for feed : FeedModel,comment : String){
        Task{
            await vm.createNewComment(for: feed.id,comment: comment)
            await vm.getFollowedFeedList()
            await MainActor.run {
                if let feedList = vm.allFeedList {
                    vm.selectedFeed = feedList.data.first(where: {$0.id == vm.selectedFeed?.id})
                }
            }
        }
    }
    
    private func onUpdateComments(for feed : FeedModel,comment : String,commentId : Int){
        Task{
            await vm.updateComment(postId: feed.id, commentId: commentId, comment: comment )
            await vm.getFollowedFeedList()
            await MainActor.run {
                if let feedList = vm.allFeedList {
                    vm.selectedFeed = feedList.data.first(where: {$0.id == vm.selectedFeed?.id})
                }
            }
        }
    }
    
    private func onTapComments(_ feed: FeedModel) {
        vm.onTapViewComments(feed)
    }
    
    private func onTapReactionCount(reactionModel : ReactionModel?) {
        vm.selectedReaction = reactionModel
    }
    
    private func onTapProfile(_ feed: FeedModel) {
        Task {
            await vm.getSelectedProfileDetail(id: String(feed.author?.id ?? 1))
            profileViewModel.userDetail = vm.selectedProfileDetail
        }
    }
    
    private func onTap(_ id: Int) {
        Task {
            await vm.getSelectedProfileDetail(id: String(id))
            profileViewModel.userDetail = vm.selectedProfileDetail
        }
    }
    
    private func onEditFeed(_ feed: FeedModel) {
        addFeedVm.selectedImageInUrl = feed.images.first
        addFeedVm.title = feed.title
        addFeedVm.content = feed.content ?? ""
        addFeedVm.feedIdToEdit = feed.id
        homeViewModel.editFeed(destination: .add,viewModel: addFeedVm)
    }
    
    private func onDeleteFeed(_ feed: FeedModel) {
        Task {
            await addFeedVm.deleteSelectedFeed(for: feed.id)
            await vm.getFollowedFeedList()
            await MainActor.run {
                postDeleteSuccess = true
            }
        }
    }
    
    private func onDeleteComment(_ id: Int) {
        Task {
            await vm.deleteComment(for: id)
            await vm.getFollowedFeedList()
            await MainActor.run {
                if let feedList = vm.allFeedList {
                    vm.selectedFeed = feedList.data.first(where: {$0.id == vm.selectedFeed?.id})
                }
            }
        }
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
