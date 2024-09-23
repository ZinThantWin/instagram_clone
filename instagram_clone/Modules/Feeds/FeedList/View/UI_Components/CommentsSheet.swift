import SwiftUI

struct CommentsSheet : View {
    @EnvironmentObject private var vm : FeedsViewModel
    var onTapCommentReaction : ((CommentSuggestedReaction) -> Void)?
    var onAddComment : ((String) -> Void)?
    var onUpdateComment : ((String,Int) -> Void)?
    var onDeleteComment : ((Int) -> Void)?
    @State var commentText : String = ""
    @FocusState var isTextfieldFocused : Bool
    @State var editingComment : Bool = false
    @State var editingCommentId : Int?
    @State var selectedComment : Comment?
    let reactions: [CommentSuggestedReaction] = [
        .like,
            .love,
        .tornado,
        .rainbow,
        .bolt,
        .game,
        .tennis,
        .fire,
        .cold
    ]
    var body: some View {
        ZStack{
            bgColor
            VStack{
                headingBar
                CommentBodyView(editingComment: $editingComment, commentText: $commentText,editingCommentId: $editingCommentId) { commentId in
                    onDeleteComment?(commentId)
                }
                Spacer()
                Divider()
                    .foregroundColor(Color(uiColor: #colorLiteral(red: 0.5741485357, green: 0.5741624236, blue: 0.574154973, alpha: 1)))
                ScrollView(.horizontal) {
                    LazyHStack{
                        ForEach(reactions,id: \.id) { reaction in
                            EachCommentReaction(onTapReaction: { reaction in
                                onTapCommentReaction?(reaction)
                            }, reaction: reaction )
                            .padding(.all, 0)
                        }
                    }.frame(height: 60)
                }
                .scrollIndicators(.hidden)
                commentBox
                    .scrollIndicators(.hidden)
            }
        }
    }
}

struct EachCommentReaction : View {
    var onTapReaction : ((CommentSuggestedReaction) -> Void)?
    var reaction : CommentSuggestedReaction
    @State var isLarge : Bool = false
    var body: some View {
        Button{
            onTapReaction?(reaction)
        }label: {
            Image(systemName: reaction.name())
                .resizable()
                .scaledToFit()
                .frame(width: 30, height: 30)
                .scaleEffect(isLarge ?  1 : Double.random(in: 0.9...1.1))
                .foregroundColor(Color(uiColor: reaction.color()))
                .padding()
        }.onAppear{
            withAnimation(Animation.bouncy().repeatForever(autoreverses: true)) {
                isLarge.toggle()
            }
        }
    }
}

struct CommentBodyView : View {
    @EnvironmentObject private var vm: FeedsViewModel
    @Binding  var editingComment : Bool
    @Binding var commentText : String
    @Binding var editingCommentId : Int?
    var onDeleteComment : ((Int) -> Void )?
    var body: some View {
        if !vm.selectedFeed!.comments.isEmpty {
            ScrollView{
                LazyVStack{
                    ForEach(vm.selectedFeed!.comments,id: \.id){comment in
                        EachComment(comment: comment, commentText: $commentText,editingComment: _editingComment,editingCommentId: $editingCommentId) { commentId in
                            onDeleteComment?(commentId)
                        }
                    }
                }
            }
        }else{
            VStack(alignment: .center){
                Spacer()
                Text("No comments yet")
                    .font(.title)
                    .fontWeight(.semibold)
                Text("Start the conversation.")
                    .font(.subheadline)
                    .fontWeight(.regular)
                Spacer()
            }
        }
    }
}

extension CommentsSheet {
    
    private var commentBox : some View{
        HStack{
            NetworkImageProfile(imageUrlInString: AppConstants.dummyModelProfile, imageHeight: 40, imageWidth: 40)
            TextField("Add a comment...", text: $commentText)
                .focused($isTextfieldFocused)
                .overlay {
                    if !commentText.isEmpty  {
                        HStack(){
                            Spacer()
                            Button{
                                superPrint(editingComment)
                                editingComment ? onUpdateComment?(commentText, editingCommentId ?? 0) : onAddComment?(commentText)
                                commentText = ""
                            }label: {
                                Image(systemName: "arrow.up.circle.fill")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 30, height: 30)
                                    .foregroundColor(.blue)
                            }
                        }
                    }
                }
        }.padding(.horizontal,15)
    }
    
    private var bgColor : some View{
        Rectangle()
            .fill(Color.black)
            .ignoresSafeArea()
    }
    
    private var headingBar : some View {
        VStack{
            Rectangle()
                .frame(width: 50, height: 5)
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
    @Binding var commentText : String
    @EnvironmentObject private var profileVM : ProfileViewModel
    @EnvironmentObject private var vm : FeedsViewModel
    @Binding var editingComment : Bool
    @Binding var editingCommentId : Int?
    var onDeleteComment : ((Int) -> Void)?
    var body: some View {
        HStack{
            NetworkImageProfile(imageUrlInString: AppConstants.dummyModelProfile, imageHeight: 45, imageWidth: 45)
            VStack(alignment: .leading,spacing: 0){
                HStack{
                    Text(comment.author.name)
                        .font(.system(size: 14,weight: .thin))
                    if let dateInString = comment.updatedAt {
                        if let timeStamp = convertDateString(dateInString){
                            Text(timeStamp)
                                .font(.system(size: 14,weight: .medium))
                        }
                    }
                    
                    if profileVM.userDetail?.id == comment.author.id {
                        Button {
                            onDeleteComment?(comment.id)
                        } label: {
                            Text("delete")
                                .font(.system(size: 12,weight: .regular))
                                .foregroundColor(.secondary)
                        }
                    }
                }
                if comment.content.hasSuffix(".emoji"){
                    let emote = comment.content.replacingOccurrences(of: ".emoji", with: "")
                    let reaction = CommentSuggestedReaction(from: emote)
                    Image(systemName: reaction!.name())
                        .symbolEffect(.pulse)
                        .foregroundColor(Color(uiColor: reaction!.color()))
                }else{
                    Text(comment.content)
                        .font(.system(size: 16,weight: .medium))
                }
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
                Text("\(String(Int.random(in: 1..<100)))")
                    .font(.system(size: 10,weight: .regular))
            }
            
        }
        .contextMenu {
            Button(action: {
            }) {
                Text("Like")
                Image(systemName: Reaction.like.systemImage(for: .reacted))
            }
            Button{
                commentText = comment.content
                editingComment = true
                editingCommentId = comment.id
            }label: {
                Text("Edit")
                Image(systemName: "pencil") 
            }
            
            Button(role : .destructive){
                onDeleteComment?(comment.id)
            } label: {
                Text("Delete")
                Image(systemName: "trash")
            }
        }
        .padding(.bottom, 10)
        .padding(.horizontal, 10)
    }
}
