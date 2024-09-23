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
                                EachFeedView(eachFeed: feed)
                            }
                        } else {
                            Text("No feeds available.")
                                .foregroundColor(.gray)
                        }
                    }
                }
                .scrollIndicators(.hidden)
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
}
