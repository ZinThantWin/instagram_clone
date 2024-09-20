import SwiftUI

struct HomePage: View {
    @EnvironmentObject private var vm : HomeViewModel
    
    var body: some View {
        ZStack{
            bgImage
            myTabView
            .background(.black)
            .navigationBarBackButtonHidden(true)
            .navigationSplitViewStyle(.balanced)
        }
    }
}



extension HomePage {
    
    private var myTabView : some View {
        TabView(selection : $vm.selectedTab){
            FeedListPage()
                .tabItem {
                    Image(systemName: "house")
                }
                .tag(Tab.home)
//            Text("Search")
//            .tabItem {
//                Image(systemName: "magnifyingglass")
//            }
//            .tag(Tab.search)
            AddFeedsPage()
                .tabItem {
                    Image(systemName: "plus.circle")
                }
                .tag(Tab.add)
//            Text("List")
//                .tabItem {
//                    Image(systemName: "list.number")
//                }
//                .tag(Tab.list)
            ProfilePage()
                .tabItem {
                    Image(systemName: "person.circle")
                }
                .tag(Tab.profile)
        }
    }
    
    private var bgImage : some View{
        Rectangle()
            .fill(Color.black.gradient)
            .ignoresSafeArea()
    }
}

#Preview {
    HomePage()
}
