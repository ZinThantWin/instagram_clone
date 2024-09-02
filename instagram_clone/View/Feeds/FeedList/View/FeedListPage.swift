import SwiftUI

struct FeedListPage: View {
    @EnvironmentObject var vm: FeedsViewModel
    
    var body: some View {
        NavigationView {
            NavigationStack{
                ScrollView {
                    LazyVStack {
                        if let feeds = vm.allFeedList?.data {
                            ForEach(feeds, id: \.id) { feed in
                                EachFeed(eachFeed: feed) {
                                    vm.onTapViewComments(feed)
                                } onTapProfile: {
                                    Task{
                                        await vm.getSelectedProfileDetail(id: String(feed.id))
                                    }
                                }
                            }
                        } else {
                            Text("No feeds available.")
                                .foregroundColor(.gray)
                        }
                    }
                }
                .navigationDestination(isPresented: $vm.showProfileFullScreenCover, destination: {
                    ProfileDetailView(profile: vm.selectedProfileDetail ?? SampleProfileModel() , guestView: true)
                })
                .sheet(isPresented: $vm.showCommentSheet, content: {
                    CommentsSheet(comments: vm.selectedFeed!.comments)
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

