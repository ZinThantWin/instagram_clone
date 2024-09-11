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
                                             yourFeed: feed.author?.id == profileViewModel.userDetail?.id,
                                             showReactions: $vm.showReactionRow)
                            }
                        } else {
                            Text("No feeds available.")
                                .foregroundColor(.gray)
                        }
                    }
                }
                .alert(isPresented: $postDeleteSuccess, content: {
                    Alert(title: Text("selected feed deleted successfully!"))
                })
                .sheet(isPresented: $vm.showCommentSheet, content: {
                    if let feed = vm.selectedFeed {
                        CommentsSheet(comments: Binding(
                            get: { vm.selectedFeed?.comments ?? [] },
                            set: { vm.selectedFeed?.comments = $0 }
                        ), authorName: "Ko Zin", userName: "dummy User name", userImageUrl: "", onTapCommentReaction: { reaction in
                            onAddComments(for: feed, comment: "\(reaction.name()).emoji")
                        }, onAddComment: {addedComment in
                            onAddComments(for: feed, comment: addedComment)
                        })
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
    
    private func onAddComments(for feed : FeedModel,comment : String){
        Task{
            await vm.createNewComment(for: feed.id,comment: comment)
            await vm.getAllFeedList()
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
    
    private func onTapProfile(_ feed: FeedModel) {
        Task {
            await vm.getSelectedProfileDetail(id: String(feed.id))
        }
    }
    
    private func onEditFeed(_ feed: FeedModel) {
        addFeedVm.selectedImageInUrl = feed.image
        addFeedVm.title = feed.title
        addFeedVm.content = feed.content ?? ""
        addFeedVm.feedIdToEdit = feed.id
        homeViewModel.editFeed(destination: .add,viewModel: addFeedVm)
    }
    
    private func onDeleteFeed(_ feed: FeedModel) {
        Task {
            await addFeedVm.deleteSelectedFeed(for: feed.id)
            await vm.getAllFeedList()
            await MainActor.run {
                postDeleteSuccess = true
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
