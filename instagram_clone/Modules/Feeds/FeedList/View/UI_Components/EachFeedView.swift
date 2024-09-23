import SwiftUI

struct EachFeedView : View {
    var eachFeed : FeedModel
    @State private var selectedTab = 0
    @State private var scale: CGFloat = 1.0
    @State private var showImagePreview: Bool = false
    @EnvironmentObject private var vm : FeedsViewModel
    @EnvironmentObject private var homeVm : HomeViewModel
    @EnvironmentObject private var profileVm : ProfileViewModel
    @EnvironmentObject private var addFeedsVm : AddFeedsViewModel
    @State private var isShareFeed : Bool = false
    @State private var isYourFeed : Bool = false
    @State private var showReactionRow : Bool = false
    @State private var showProfileDetail : Bool = false
    private let pagePadding: Double = 10
    var body: some View {
        NavigationStack{
            VStack{
                if let shareByUser = eachFeed.shareByUser {
                    HStack{
                        Button {
                            Task{
                                await onTapProfile()
                            }
                        } label: {
                            if let profileImage = shareByUser.author.image {
                                CachedAsyncImage(url: URL(string: "https://social.petsentry.info\(profileImage)")!, width: 50, height: 50, isCircle: true)
                            } else {
                                DummyProfile(size: 50)
                            }
                        }
                        VStack(alignment: .leading){
                            HStack{
                                Text(shareByUser.author.name)
                                    .foregroundColor(.primary)
                                    .font(.body)
                                    .fontWeight(.semibold)
                                Image(systemName: "flame.circle")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 15, height: 15)
                                    .foregroundStyle(.orange)
                                Spacer()
                                if isYourFeed {
                                    menu
                                }
                            }
                            if let edited = eachFeed.isEdited {
                                Text(edited ? "Edited" : "suggested for you")
                                    .foregroundColor(.primary)
                                    .font(.caption)
                            } else {
                                Text("suggested for you")
                                    .foregroundColor(.primary)
                                    .font(.caption)
                            }
                            
                        }
                    }
                    .padding(.horizontal, pagePadding)
                    .padding(.top, 10)
                    if let title = shareByUser.sharePostTitle {
                        HStack{
                            Text(title)
                                .fontWeight(.medium)
                            Spacer()
                        }
                    }
                    feedView
                        .padding(.all,15)
                        .overlay(
                            RoundedRectangle(cornerRadius: 2)
                                .stroke(Color.gray, lineWidth: 1)
                        )
                    reactionRow
                        .padding(.bottom, 20)
                }else {
                    feedView
                }
            }
            .onAppear{
                isShareFeed = eachFeed.shareByUser != nil
                if let shareByUser = eachFeed.shareByUser {
                    isYourFeed = shareByUser.author.id == profileVm.ownerDetail?.id
                }else{
                    isYourFeed = eachFeed.author?.id == profileVm.ownerDetail?.id
                }
                
            }
            .fullScreenCover(isPresented: $showProfileDetail, content: {
                ProfileDetailView(guestView: true)
            })
            .sheet(item: $vm.selectedReaction, content: { selectedReaction in
                AllReactionSheet(reactionModel: selectedReaction,onTap: { id in
                    Task {
                        await vm.getSelectedProfileDetail(id: String(id))
                        vm.selectedReaction = nil
                        showProfileDetail = true
                    }
                })
                .presentationDetents([.medium, .large])
                .presentationDragIndicator(.hidden)
            })
            .sheet(isPresented: $vm.showShareBottomsheet, content: {
                if #available(iOS 18.0, *) {
                    ShareSheet()
                        .presentationSizing(.fitted)
                        .presentationDragIndicator(.hidden)
                } else {
                    ShareSheet()
                    .presentationDetents([.height(200)])
                    .presentationDragIndicator(.hidden)
                }
            })
            .sheet(isPresented: $vm.showCommentSheet, content: {
                if let feed = vm.selectedFeed {
                    CommentsSheet(onTapCommentReaction: { reaction in
                        onAddComments(for: feed, comment: "\(reaction.name()).emoji")
                    }, onAddComment: {addedComment in
                        onAddComments(for: feed, comment: addedComment)
                    }, onUpdateComment : {updatedComment,commentId in
                        onUpdateComments(for: feed , comment: updatedComment, commentId: commentId)
                    }, onDeleteComment: { commentId  in
                        onDeleteComment(commentId)
                    })
                    .presentationDetents([.medium, .large])
                    .presentationDragIndicator(.hidden)
                }
            })
            .alert(isPresented: $addFeedsVm.feedDeleteSuccess, content: {
                Alert(title: Text("selected feed deleted successfully!"))
            })
        }
    }
}

extension EachFeedView {
    
    
    private func giveReaction(for postId : Int){
        Task {
            await vm.giveReaction(reactionType: .love, postId: postId)
        }
    }
    
    private func onDeleteComment(_ id: Int) {
        Task {
            await vm.deleteComment(for: id)
            await vm.getFollowedFeedList()
            await MainActor.run {
                if let feedList = vm.allFeedList {
                    vm.selectedFeed = feedList.data.first(where: {$0.id == vm.selectedFeed?.id})
                }
            }
        }
    }
    
    private func onAddComments(for feed : FeedModel,comment : String){
        Task{
            await vm.createNewComment(for: feed.id,comment: comment)
            await vm.getFollowedFeedList()
            await MainActor.run {
                if let feedList = vm.allFeedList {
                    vm.selectedFeed = feedList.data.first(where: {$0.id == vm.selectedFeed?.id})
                }
            }
        }
    }
    
    private func onUpdateComments(for feed : FeedModel,comment : String,commentId : Int){
        Task{
            await vm.updateComment(postId: feed.id, commentId: commentId, comment: comment)
            await vm.getFollowedFeedList()
            await MainActor.run {
                if let feedList = vm.allFeedList {
                    vm.selectedFeed = feedList.data.first(where: {$0.id == vm.selectedFeed?.id})
                }
            }
        }
    }
    
    private func onDeleteFeed()async{
        Task{
            await addFeedsVm.deleteSelectedFeed(for: isShareFeed ? eachFeed.shareByUser?.sharePostId ?? 0: eachFeed.id)
            await vm.getFollowedFeedList()
        }
    }
    
    private func onEditFeed()async{
        Task{
            addFeedsVm.selectedImageInUrl = eachFeed.images.first
            addFeedsVm.title = eachFeed.title
            addFeedsVm.content = eachFeed.content ?? ""
            addFeedsVm.feedIdToEdit = eachFeed.id
            homeVm.editFeed(destination: .add,viewModel: addFeedsVm)
        }
    }
    
    private func onTapProfile()async {
        Task{
            let _ = await profileVm.getUserProfile(id: String(eachFeed.author?.id ?? 1))
            showProfileDetail = true
        }
        
    }
    
    private var feedView : some View{
        
        ZStack{
            if showReactionRow {
                Rectangle()
                    .fill(.white.opacity(0.000001))
                    .ignoresSafeArea()
                    .onTapGesture {
                        showReactionRow = false
                    }
            }
            VStack(alignment: .leading,spacing: 0){
                HStack{
                    Button {
                        
                        Task{
                            await onTapProfile()
                        }
                    } label: {
                        if let profileImage = eachFeed.author?.image {
                            CachedAsyncImage(url: URL(string: "https://social.petsentry.info\(profileImage)")!, width: 50, height: 50, isCircle: true)
                        } else {
                            DummyProfile(size: 50)
                        }
                        
                    }
                    
                    headerSection
                }
                .padding(.horizontal, pagePadding)
                .padding(.bottom, pagePadding)
                
                if !eachFeed.images.isEmpty {
                    TabView(selection: $selectedTab) {
                        ForEach(Array(eachFeed.images.enumerated()), id: \.offset) { index, each in
                            CachedAsyncImage(
                                url: URL(string: "https://social.petsentry.info\(each)")!,
                                width: UIScreen.main.bounds.width,
                                height: UIScreen.main.bounds.height * 0.4,
                                isCircle: false
                            )
                            .cornerRadius(3)
                            .tag(index) // Tagging each view with its index
                        }
                    }
                    .tabViewStyle(.page(indexDisplayMode: .always))
                    .frame(height: UIScreen.main.bounds.height * 0.4)
                }
                
                if !isShareFeed{
                    reactionRow
                }
                
                VStack(alignment: .leading){
                    if !eachFeed.title.isEmpty {
                        Text(eachFeed.title)
                            .fontWeight(.bold)
                            .padding(.top,2)
                    }
                    if let content = eachFeed.content {
                        Text(content)
                            .fontWeight(.regular)
                    }
                    if !eachFeed.comments.isEmpty {
                        Button{
                            vm.onTapViewComments(eachFeed)
                        }label: {
                            Text("view all comments")
                                .foregroundColor(.secondary)
                        }
                        .padding(.top,2)
                    }
                    
                    if let dateInString = eachFeed.createdAt {
                        if let date = convertDateString(dateInString){
                            Text(date)
                                .font(.caption)
                                .fontWeight(.regular)
                        }
                    }
                    
                }.padding(.horizontal, pagePadding)
            }
            .padding(.top, isShareFeed ? 5 : 30)
        }
    }
    
    private var menu : some View{
        Menu{
            Button{
                Task{
                    await onEditFeed()
                }
            }label: {
                HStack{
                    Image(systemName: "pencil")
                    Text("Edit")
                }
            }
            Button(role: .destructive){
                Task{
                    await onDeleteFeed()
                }
            }label: {
                HStack{
                    Image(systemName: "trash")
                    Text("Delete")
                    
                }
            }
        } label: {
            Image(systemName: "ellipsis")
                .foregroundColor(.white)
                .padding()
        }
    }
    
    private var reactionRow : some View{
        HStack(alignment: .top,spacing: 0){
            if let reaction = eachFeed.userReactonType {
                reactionImage(for: reaction)
                    .gesture(reactionGesture)
            } else {
                reactionImage(for: nil)
                    .gesture(reactionGesture)
            }
            
            if let reactions = eachFeed.reactions {
                Button{
                    onTapReactionCount(reactionModel: reactions)
                }label: {
                    Text("\(String(reactions.all.users.count))")
                        .contentTransition(.numericText(countsDown: true))
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                }
            }
            
            EachFeedIcon(icon: "bubble.right",iconColor: .white, action: {
                vm.onTapViewComments(eachFeed)
            }).padding(.leading, 10)
            Text("\(String(eachFeed.comments.count))")
                .fontWeight(.semibold)
            EachFeedIcon(icon: "paperplane", iconColor: .white,action: {
                vm.showShareBottomsheet = true
                vm.feedToShare = eachFeed
            })
            .padding(.leading, 10)
            if let count = eachFeed.reactionCount {
                Text("\(String(count))")
                    .fontWeight(.semibold)
            }
            Spacer()
        }
        .padding(.top, 15)
        .padding(.horizontal, 10)
        .overlay {
            if showReactionRow {
                HStack{
                    ForEach(Reaction.allCases.dropLast(), id : \.self) {reaction in
                        Button{
                            onReactionSelected(reaction, eachFeed)
                        }label: {
                            Image(systemName: reaction.systemImage(for: .notReacted))
                                .resizable()
                                .scaledToFit()
                                .frame(width: 30, height: 30)
                                .padding(.horizontal,10)
                                .symbolRenderingMode(.hierarchical)
                                .symbolEffect(.variableColor)
                                .foregroundColor(.primary)
                        }
                    }
                }
                .padding(.horizontal, 5)
                .padding(.vertical, 10)
                .background(Color.black)
                .cornerRadius(50)
                .offset(y: -30)
            }
        }
    }
    
    private var commentators : some View {
        HStack(alignment: .top,spacing: 10){
            NetworkImage(imageUrlInString: "https://media.licdn.com/dms/image/D4E12AQFU58KVLBrBPA/article-cover_image-shrink_720_1280/0/1718287564870?e=2147483647&v=beta&t=AvStMR_NLecv5c3EXxH_1KhqxlPef5399uLpHAaprVY", imageHeight: 30, imageWidth: 30).clipShape(Circle()).padding(.leading,10)
            NetworkImage(imageUrlInString: "https://i.guim.co.uk/img/media/319746c6b8b2c4e73050a8462ca3c5615cf6b507/0_67_3408_2045/master/3408.jpg?width=1200&height=1200&quality=85&auto=format&fit=crop&s=a48187d9354c91e113c38d576d7b4178", imageHeight: 30, imageWidth: 30).clipShape(Circle())
            NetworkImage(imageUrlInString: "https://prod-media.beinsports.com/image/1683756755444_eec03c5b-247b-4cd9-aed0-aab93c60aa95.jpg", imageHeight: 30, imageWidth: 30).clipShape(Circle())
            Spacer()
        }
    }
    
    private var headerSection : some View {
        VStack(alignment: .leading){
            HStack{
                if let author = eachFeed.author {
                    Text(author.name)
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
                    .foregroundStyle(.orange)
                Spacer()
                if isYourFeed && !isShareFeed{
                    menu
                }
            }
            if let edited = eachFeed.isEdited {
                Text(edited ? "Edited" : "suggested for you")
                    .foregroundColor(.primary)
                    .font(.caption)
            } else {
                Text("suggested for you")
                    .foregroundColor(.primary)
                    .font(.caption)
            }
            
        }
    }
    
    private func getReactionName(reactionName: String) -> String {
        switch reactionName.uppercased() {
        case "LIKE":
            return Reaction.like.systemImage(for: .reacted)
        case "LOVE":
            return Reaction.love.systemImage(for: .reacted)
        case "HAHA":
            return Reaction.haha.systemImage(for: .reacted)
        case "ANGRY":
            return Reaction.angry.systemImage(for: .reacted)
        case "SAD":
            return Reaction.sad.systemImage(for: .reacted)
        default:
            return Reaction.love.systemImage(for: .reacted)
        }
    }
    
    private func getReactionColor(reactionName: String) -> Color {
        switch reactionName.uppercased() {
        case "LIKE":
            return Color.blue
        case "LOVE":
            return Color.pink
        case "HAHA":
            return Color.yellow
        case "ANGRY":
            return Color.red
        case "SAD":
            return Color.yellow
        default:
            return Color.pink
        }
    }
    
    private func reactionImage(for reaction: String?) -> some View {
        let systemName = reaction != nil ? getReactionName(reactionName: reaction!) : "heart"
        let color = reaction != nil ? getReactionColor(reactionName: reaction!) : .white
        
        return Image(systemName: systemName)
            .resizable()
            .scaledToFit()
            .frame(width: 25, height: 25)
            .foregroundColor(color)
            .padding(.trailing, 5)
            .transition(.symbolEffect(.automatic).combined(with: .blurReplace(.downUp)))
    }
    
    private var reactionGesture: some Gesture {
        TapGesture()
            .onEnded {
                giveReaction(for: eachFeed.id)
            }
            .simultaneously(with: LongPressGesture(minimumDuration: 0.5)
                .onEnded { _ in
                    showReactionRow = true
                }
            )
    }
    
    private func onTapReactionCount(reactionModel : ReactionModel?) {
        vm.selectedReaction = reactionModel
    }
    
    private func onReactionSelected(_ reaction: Reaction, _ feed: FeedModel) {
        Task {
            await vm.giveReaction(reactionType: reaction, postId: feed.id)
            showReactionRow = false
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



