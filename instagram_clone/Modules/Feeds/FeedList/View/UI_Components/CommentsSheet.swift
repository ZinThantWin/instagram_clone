import SwiftUI

struct CommentsSheet : View {
    @State var comments : [Comment]
    var authorName : String
    var userName : String
    var userImageUrl : String
    var body: some View {
        ZStack{
            bgColor
            VStack{
                headingBar
                if !comments.isEmpty {
                    ScrollView{
                        LazyVStack{
                            ForEach(comments,id: \.id){comment in
                                EachComment(comment: comment)
                            }
                        }
                    }
                }else{
                    VStack(alignment: .center){
                        Spacer()
                        Text("no comments found!")
                        Spacer()
                    }
                }
            }
        }
    }
}

extension CommentsSheet {
    private var bgColor : some View{
        Rectangle()
            .fill(Color.black)
            .ignoresSafeArea()
    }
    
    private var headingBar : some View {
        VStack{
            Rectangle()
                .frame(width: 50, height: 4)
                .clipShape(.capsule)
                .foregroundColor(.secondary)
                .padding(.top,10)
            Text("Comments")
                .font(.system(size: 18,weight: .bold))
            Divider()
                .frame(height: 2)
                .foregroundColor(.primary)
        }
    }
}

struct EachComment : View {
    @State var comment : Comment
    var body: some View {
        HStack{
            DummyProfile(size: 25,color: .primary)
            VStack(alignment: .leading,spacing: 0){
                HStack{
                    Text(comment.authorName)
                        .font(.system(size: 14,weight: .semibold))
                    if let timeStamp = convertDateString(comment.updatedAt){
                        Text(timeStamp)
                            .font(.system(size: 13,weight: .regular))
                    }
                }
                Text(comment.content)
                    .font(.system(size: 16,weight: .semibold))
            }
            Spacer()
            VStack{
                Button{
                }label: {
                    Image(systemName: "heart")
                        .resizable()
                        .frame(width: 16, height: 15)
                        .foregroundColor(.secondary)
                }
                Text("\(String(Int.random(in: 1...10)))k")
                    .font(.system(size: 12,weight: .regular))
            }
            
        }
        .padding(.bottom, 10)
        .padding(.horizontal, 10)
    }
}

#Preview {
    CommentsSheet(comments: sampleFeedModel.sampleFeedModel.comments,authorName: "Kin Zo", userName: "dummy User",userImageUrl: "")
        .preferredColorScheme(.dark)
}
