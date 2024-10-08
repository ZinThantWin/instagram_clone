import SwiftUI

struct ProfileDetailView: View {
    @State var guestView : Bool = false
    @EnvironmentObject private var vm : ProfileViewModel
    @EnvironmentObject private var feedsViewModel : FeedsViewModel
    @Environment(\.presentationMode) var presentationMode
    var body: some View {
        NavigationStack {
            VStack{
                VStack(alignment: .leading){
                    HStack{
                        if guestView {
                            Button{
                                presentationMode.wrappedValue.dismiss()
                            }label: {
                                Text("back")
                            }
                        }
                        Spacer()
                        Text(vm.userDetail!.name)
                            .fontWeight(.bold)
                        Spacer()
                    }
                    .padding(.horizontal,15)
                    .padding(.top, guestView ? 15 : 0)
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
                    .padding(.horizontal,15)
                    Text(vm.userDetail!.name).padding(.top, 15)
                        .fontWeight(.bold)
                    
                        .padding(.horizontal,15)
                    if let bio = vm.userDetail?.bio {
                        Text(bio)
                            .fontWeight(.medium)
                        
                            .padding(.horizontal,15)
                    }else {
                        Text("No bio :(")
                            .fontWeight(.medium)
                        
                            .padding(.horizontal,15)
                    }
                }
                ScrollView{
                    editButtons
                }
                .scrollIndicators(.never)
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
            Button{}label: {
                Text("Liked posts")
                    .foregroundColor(.white)
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
                EachFeedView(eachFeed: eachFeed)
            }
        }
    }
}

struct EachTextColumn: View {
    var caption: String
    var data: String
    
    var body: some View {
        VStack {
            Text(caption)
            Text(data)
                .contentTransition(.numericText())
        }
    }
}


