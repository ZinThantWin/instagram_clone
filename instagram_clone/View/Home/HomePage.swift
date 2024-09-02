import SwiftUI

struct HomePage: View {
    var body: some View {
            ZStack{
                bgImage
                TabView{
                    FeedListPage()
                        .tabItem {
                            Image(systemName: "house")
                        }
                    Text("search")
                        .tabItem {
                            Image(systemName: "magnifyingglass")
                        }
                    AddFeedsPage()
                        .tabItem {
                            Image(systemName: "plus.circle")
                        }
                    UserListPage()
                        .tabItem {
                            Image(systemName: "list.number")
                        }
                    ProfilePage()
                        .tabItem {
                            Image(systemName: "person.circle")
                        }
                }
                .navigationTitle("Instagram")
                .navigationSplitViewStyle(.balanced)
                .navigationBarBackButtonHidden(true)
            }
    }
}



extension HomePage {
    private var bgImage : some View{
        Rectangle()
            .fill(Color.black.gradient)
            .ignoresSafeArea()
    }
}

#Preview {
    HomePage()
}
