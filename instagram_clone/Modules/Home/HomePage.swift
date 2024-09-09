import SwiftUI

struct HomePage: View {
    
    init() {
           // Customize Tab Bar appearance
           let tabBarAppearance = UITabBarAppearance()
           tabBarAppearance.backgroundColor = .black

           UITabBar.appearance().standardAppearance = tabBarAppearance
           UITabBar.appearance().scrollEdgeAppearance = tabBarAppearance

           
           let navigationBarAppearance = UINavigationBarAppearance()
           navigationBarAppearance.backgroundColor = .black
           navigationBarAppearance.titleTextAttributes = [.foregroundColor: UIColor.white]

           UINavigationBar.appearance().standardAppearance = navigationBarAppearance
           UINavigationBar.appearance().scrollEdgeAppearance = navigationBarAppearance
       }
    
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
                    Text("List")
                        .tabItem {
                            Image(systemName: "list.number")
                        }
                    ProfilePage()
                        .tabItem {
                            Image(systemName: "person.circle")
                        }
                }
                .background(.black)
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
