import SwiftUI

struct UserListPage: View {
    @EnvironmentObject var vm : UserViewModel
    var body: some View {
        NavigationView {
            List {
                if let users = vm.userList?.data {
                    ForEach(users, id: \.id) { user in
                        NavigationLink(destination: ProfileDetailPage(eachUser: user )) {
                            EachUserProfile(eachUser: user)
                        }
                    }
                    .onDelete { IndexSet in
                        superPrint(IndexSet)
                    }
                } else {
                    Text("No user found!")
                        .foregroundColor(.gray)
                        .italic()
                        .frame(maxWidth: .infinity,minHeight: 500)
                }
            }
            .searchable(text: $vm.searchText)
            .navigationTitle("Profiles")
            .onAppear {
                Task {
                    await vm.getAllUserProfiles()
                }
            }
            .refreshable{
                Task {
                    await vm.getAllUserProfiles()
                }
            }
        }
    }
}
