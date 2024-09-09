import SwiftUI

struct ProfileDetailView: View {
    @State var guestView : Bool = false
    @EnvironmentObject private var vm : ProfileViewModel
    @EnvironmentObject private var feedsViewModel : FeedsViewModel
    var body: some View {
        NavigationStack {
            VStack{
                VStack(alignment: .leading){
                    HStack{
                        Spacer()
                        Text(vm.userDetail!.name)
                            .fontWeight(.bold)
                        Spacer()
                    }
                    HStack{
                        Spacer()
                        
                        if let image = vm.userDetail!.image {
                            NetworkImage(imageUrlInString: "https://social.petsentry.info\(image)", imageHeight: 70, imageWidth: 70)
                                .clipShape(Circle())
                        }
                        else{
                            NetworkImage(imageUrlInString: AppConstants.dummyModelProfile, imageHeight: 70, imageWidth: 70)
                                .clipShape(Circle())
                        }
                        Spacer()
                        EachTextColumn(caption: String(vm.userDetail!.posts.count), data: "Posts")
                        Spacer()
                        EachTextColumn(caption: String(Int.random(in: 150...999)), data: "Followers")
                        Spacer()
                        EachTextColumn(caption: String(Int.random(in: 150...999)), data: "Following")
                        Spacer()
                    }
                    Text(vm.userDetail!.name).padding(.top, 15)
                        .fontWeight(.bold)
                    if let bio = vm.userDetail?.bio {
                        Text(bio)
                            .fontWeight(.medium)
                    }else {
                        Text("No bio :(")
                            .fontWeight(.medium)
                    }
                }
                ScrollView{
                    editButtons
                }
            }
            .navigationDestination(isPresented: $vm.navigateToProfileEdit, destination: {
                EditProfilePage()
            })
        }
        .onAppear{
            superPrint(vm.userDetail!.posts.count)
        }
        .navigationTitle("\(vm.userDetail!.name)")
    }
}

extension ProfileDetailView {
    var editButtons : some View {
        LazyVStack (alignment: .leading){
            if !guestView {
                HStack{
                    Button {
                        vm.navigateToProfileEdit = true
                    } label: {
                        Text("Edit profile")
                            .fontWeight(.semibold)
                            .foregroundColor(.white)
                            .padding(.vertical, 5)
                            .frame(maxWidth: .infinity)
                            .background(Color(#colorLiteral(red: 0.2605174184, green: 0.2605243921, blue: 0.260520637, alpha: 1)))
                            .cornerRadius(5)
                    }
                    Button {
                        
                    } label: {
                        Text("Share profile")
                            .fontWeight(.semibold)
                            .foregroundColor(.white)
                            .padding(.vertical, 5)
                            .frame(maxWidth: .infinity)
                            .background(Color(#colorLiteral(red: 0.2605174184, green: 0.2605243921, blue: 0.260520637, alpha: 1)))
                            .cornerRadius(5)
                    }
                    
                }
            }
            HStack{
                Spacer()
                Text(guestView ? "\(vm.userDetail!.name)'s moments" : "Your moments")
                    .font(.headline)
                    .fontWeight(.semibold)
                Spacer()
            }
            .padding(.top,20)
            .padding(.top,10)
            ForEach (vm.userDetail!.posts, id: \.id){eachFeed in
                EachFeedView(eachFeed: eachFeed, onTapComments: {
                    superPrint("gesture incoming")
                }, onTapProfile: {
                    superPrint("gesture incoming")
                }, onTapReaction: {
                    superPrint("gesture incoming")
                }, onLongPressReaction: {
                    superPrint("gesture incoming")
                }, showReactions: $feedsViewModel.showReactionRow)
            }
        }
    }
}

struct EachTextColumn : View {
    var caption : String
    var data : String
    var body: some View {
        VStack{
            Text(caption)
            Text(data)
        }
    }
}


