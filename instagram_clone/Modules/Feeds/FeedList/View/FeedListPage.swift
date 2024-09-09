import SwiftUI

struct FeedListPage: View {
    @EnvironmentObject var vm: FeedsViewModel
    @EnvironmentObject var loginViewModel: LoginViewModel
    
    var body: some View {
        NavigationView {
            NavigationStack{
                ScrollView {
                    LazyVStack {
                        if let feeds = vm.allFeedList?.data {
                            ForEach(feeds, id: \.id) { feed in
                                EachFeedView(eachFeed: feed, onTapComments: {
                                    vm.onTapViewComments(feed)
                                }, onTapProfile: {
                                    Task {
                                        await vm.getSelectedProfileDetail(id: String(feed.id))
                                    }
                                }, onTapReaction: {
                                    Task {
                                        await vm.giveReaction(reactionType: .love, postId: feed.id)
                                    }
                                }, onLongPressReaction: {
                                    vm.showReactionRow = true
                                }, onReactionSelected: {reaction in
                                    superPrint(reaction)
                                    Task {
                                        await vm.giveReaction(reactionType: reaction, postId: feed.id)
                                        vm.showReactionRow = false
                                    }
                                },showReactions: $vm.showReactionRow)
                            }
                        } else {
                            Text("No feeds available.")
                                .foregroundColor(.gray)
                        }
                    }
                }
                //                .navigationDestination(isPresented: $vm.showProfileFullScreenCover, destination: {
                //                    if let selectedProfile = vm.selectedProfileDetail {
                //                        ProfileDetailView(profile: Binding(get: {
                //                            selectedProfile
                //                        }, set: {
                //                            vm .selectedProfileDetail = $0
                //                        }), guestView: true)
                //                    }
                //
                //                })
                .sheet(isPresented: $vm.showCommentSheet, content: {
                    CommentsSheet(comments: vm.selectedFeed!.comments,authorName: "Ko Zin",userName: "dummy User name",userImageUrl: "")
                        .presentationDetents([.medium,.large])
                        .presentationDragIndicator(.hidden)
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
}

