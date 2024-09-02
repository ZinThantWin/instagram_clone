import SwiftUI

struct ProfileDetailView: View {
    @State var profile : ProfileModel
    @State var guestView : Bool = false 
    var body: some View {
        VStack{
            if !guestView {
                HStack{
                    Spacer()
                    Text(profile.name)
                        .fontWeight(.bold)
                    Spacer()
                }
            }
            ScrollView{
                LazyVStack (alignment: .leading){
                    HStack{
                        Spacer()
                        NetworkImage(imageUrlInString: AppConstants.dummyModelProfile, imageHeight: 100, imageWidth: 100)
                            .clipShape(Circle())
                        Spacer()
                        EachTextColumn(caption: String(profile.posts.count), data: "Posts")
                        Spacer()
                        EachTextColumn(caption: String(Int.random(in: 150...999)), data: "Followers")
                        Spacer()
                        EachTextColumn(caption: String(Int.random(in: 150...999)), data: "Following")
                        Spacer()
                    }
                    Text(profile.name).padding(.top, 15)
                        .fontWeight(.bold)
                    if let bio = profile.bio {
                        Text(bio)
                            .fontWeight(.medium)
                    }else {
                        Text("ဒီနေ့ ဖုန်ရှုမယ်")
                            .fontWeight(.medium)
                    }
                    HStack{
                        Spacer()
                        Text(guestView ? "\(profile.name) moments" : "Your moments")
                            .font(.headline)
                            .fontWeight(.semibold)
                        Spacer()
                    }
                    .padding(.top,20)
                    .padding(.top,10)
                    ForEach (profile.posts, id: \.id){eachFeed in
                        EachFeed(eachFeed: eachFeed) {
                            
                        } onTapProfile: {}
                    }
                }
            }
        }
        .navigationTitle("\(profile.name)")
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

#Preview {
    ProfileDetailView(profile: SampleProfileModel())
        .preferredColorScheme(.dark)
}
