import SwiftUI

struct EachFeed : View {
    var eachFeed : FeedModel
    var onTapComments : () -> Void
    var onTapProfile  : () -> Void
    var body: some View {
        VStack(alignment: .leading){
            HStack{
                Button {
                    onTapProfile()
                } label: {
                    DummyProfile(size: 50)
                }

                VStack(alignment: .leading){
                    HStack{
                        if let name = eachFeed.authorName {
                            Text(name)
                                .foregroundColor(.primary)
                                .font(.body)
                                .fontWeight(.semibold)
                        }else{
                            Text("Anonymous")
                                .foregroundColor(.primary)
                                .font(.body)
                                .fontWeight(.semibold)
                        }
                        Image(systemName: "flame.circle")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 15, height: 15)
                            .symbolRenderingMode(.multicolor)
                            .foregroundStyle(.yellow, .red)
                        Spacer()
                        if let date = convertDateString(eachFeed.createdAt){
                            Text(date)
                                .font(.caption)
                                .fontWeight(.regular)
                        }
                    }
                    Text("suggested for you")
                        .foregroundColor(.primary)
                        .font(.caption)
                    if let ranking = eachFeed.ranking {
                        Text(String(ranking))
                            .foregroundColor(.primary)
                            .font(.caption)
                    }
                }
            }
            if let url = eachFeed.image{
                NetworkImage(imageUrlInString: "https://social.petsentry.info\(url)", imageHeight: UIScreen.main.bounds.height * 0.6, imageWidth: UIScreen.main.bounds.width)
            }
            HStack(alignment: .top,spacing: 0){
                EachFeedIcon(icon: "heart",iconColor: .white, action: {})
                
                if let count = eachFeed.reactionCount {
                    if count == 0 {
                        Text("\(String(count))")
                            .fontWeight(.semibold)
                    }
                    else{
                        Text("\(String(count))M")
                            .fontWeight(.semibold)
                    }
                }
                
                EachFeedIcon(icon: "bubble.right",iconColor: .white, action: {
                    onTapComments()
                }).padding(.leading, 10)
                Text("\(String(eachFeed.comments.count))")
                    .fontWeight(.semibold)
                EachFeedIcon(icon: "paperplane", iconColor: .white,action: {})
                    .padding(.leading, 10)
                if let count = eachFeed.reactionCount {
                    Text("\(String(count))")
                        .fontWeight(.semibold)
                }
                Spacer()
            }.padding(.top, 15)
            if !eachFeed.title.isEmpty {
                Text(eachFeed.title)
                    .fontWeight(.bold)
            }
            if let content = eachFeed.content {
                Text(content)
                    .fontWeight(.semibold)
            }
            if !eachFeed.comments.isEmpty {
                Button{
                    onTapComments()
                }label: {
                    Text("view all comments")
                        .foregroundColor(.secondary)
                }
                
            }
        }.padding(.bottom, 30)
    }
}

extension EachFeed {
    private var commentators : some View {
        HStack(alignment: .top,spacing: 10){
            NetworkImage(imageUrlInString: "https://media.licdn.com/dms/image/D4E12AQFU58KVLBrBPA/article-cover_image-shrink_720_1280/0/1718287564870?e=2147483647&v=beta&t=AvStMR_NLecv5c3EXxH_1KhqxlPef5399uLpHAaprVY", imageHeight: 30, imageWidth: 30).clipShape(Circle()).padding(.leading,10)
            NetworkImage(imageUrlInString: "https://i.guim.co.uk/img/media/319746c6b8b2c4e73050a8462ca3c5615cf6b507/0_67_3408_2045/master/3408.jpg?width=1200&height=1200&quality=85&auto=format&fit=crop&s=a48187d9354c91e113c38d576d7b4178", imageHeight: 30, imageWidth: 30).clipShape(Circle())
            NetworkImage(imageUrlInString: "https://prod-media.beinsports.com/image/1683756755444_eec03c5b-247b-4cd9-aed0-aab93c60aa95.jpg", imageHeight: 30, imageWidth: 30).clipShape(Circle())
            Spacer()
        }
    }
}

struct EachFeedIcon : View {
    var icon :String
    var iconColor :Color
    var action : () -> Void
    var body: some View {
        Button{
            action()
        }label: {
            Image(systemName: icon )
                .resizable()
                .scaledToFit()
                .frame(width: 25, height: 25)
                .foregroundColor(iconColor)
                .padding(.horizontal,5)
        }
    }
}

#Preview {
    EachFeed(eachFeed: sampleFeedModel.sampleFeedModel,onTapComments: {
        superPrint("feed comments tapped")
    }, onTapProfile: {})
    .preferredColorScheme(.dark)
}
