import SwiftUI

struct EachSuggestedFriendView: View {
    @EnvironmentObject private var vm : SuggestedFriendViewModel
    @Binding var each : SuggestedFriend
    var onFollowButtonTap : () -> Void
    
    var body: some View {
        VStack{
            if let image = each.image {
                CachedAsyncImage(url: URL(string: "\(ApiEndPoints.imageBaseUrl)\(image)")!,width: 130, height: 130, isCircle: true)
            }else {
                NetworkImageProfile(imageUrlInString: "haha", imageHeight: 130, imageWidth: 130)
            }
            Text(each.name)
                .lineLimit(1)
                .fontWeight(.semibold)
            if let bio = each.bio {
                Text(bio.isEmpty ? "Connect on insta" : bio)
                    .lineLimit(1)
                    .fontWeight(.regular)
            } else {
                Text("Connect on insta")
                    .lineLimit(1)
                    .fontWeight(.regular)
            }
            Button{
                onFollowButtonTap()
            }label: {
                Text(each.isFollowing ? "Following" : "Follow")
                    .foregroundColor(.white)
                    .padding(.horizontal,each.isFollowing ? 53 : 63)
                    .padding(.vertical,5)
                    .background(each.isFollowing ? .black : .blue)
                    .cornerRadius(10)
                    .contentTransition(.numericText(countsDown: true ))
            }
        }
        .frame(width: 200, height: 270)
        .background(Color(uiColor: #colorLiteral(red: 0.1298420429, green: 0.1298461258, blue: 0.1298439503, alpha: 1)))
        .cornerRadius(15)
    }
}


