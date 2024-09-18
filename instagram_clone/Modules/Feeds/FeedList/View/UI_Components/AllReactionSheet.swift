import SwiftUI

struct EachReactionSection : Identifiable{
    let id : UUID = UUID()
    let reaction : Reaction
    let reactionList : [AuthorModel]
}

struct AllReactionSheet : View {
    @State var allReactionTabs : [EachReactionSection] = []
    var reactionModel : ReactionModel
    @State var selectedTab : EachReactionSection?
    var onTap : ((Int) -> Void)?
    var body: some View {
        VStack{
            if !allReactionTabs.isEmpty {
                ScrollView(.horizontal){
                    HStack{
                        ForEach(allReactionTabs,id: \.id){tab in
                            EachTab(tab: tab,isSelected: Binding(get: {
                                tab.reaction == selectedTab?.reaction
                            }, set: { abcd in
                                superPrint(abcd)
                            }),  onTap: {tab in
                                withAnimation(.spring) {
                                    selectedTab = tab
                                }
                            })
                        }
                    }
                }
                .padding(.bottom, 10)
                .scrollIndicators(.hidden)
            } else {
                Spacer()
                emptyView
                Spacer()
            }
            VStack(alignment: .leading){
                if let list = selectedTab {
                    ForEach(list.reactionList,id: \.id){each in
                        EachReaction(name: each.name, id : each.id,image: each.image ?? "", reaction: list.reaction) { id in
                            onTap?(id)
                        }
                    }
                }
            }
            Spacer()
        }
        .padding(.horizontal, 20)
        .onAppear{
            self.allReactionTabs = [EachReactionSection(reaction: .all, reactionList: reactionModel.all.users),EachReactionSection(reaction: .like, reactionList: reactionModel.like),EachReactionSection(reaction: .love, reactionList: reactionModel.love),EachReactionSection(reaction: .sad, reactionList: reactionModel.sad),EachReactionSection(reaction: .haha, reactionList: reactionModel.haha),EachReactionSection(reaction: .angry, reactionList: reactionModel.angry),]
            self.allReactionTabs = self.allReactionTabs.filter({ each in
                each.reactionList.count > 0
            })
            self.allReactionTabs.sort { one, two in
                one.reactionList.count > two.reactionList.count
            }
            selectedTab = allReactionTabs.first(where: {$0.reaction == .all})
        }
    }
}

extension AllReactionSheet {
    private var bgImage : some View {
        Rectangle()
            .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
            .foregroundColor(.secondary)
    }
    
    private var emptyView : some View {
        Text("Oops! no reaction found!")
    }
}

struct EachReaction : View {
    @State var name : String
    @State var id : Int
    @State var image : String
    @State var reaction : Reaction
    var onTap : ((Int) -> Void)?
    var body: some View {
        Button{
            onTap?(id)
        }label: {
            HStack{
                NetworkImageProfile(imageUrlInString: "https://social.petsentry.info\(image)", imageHeight: 35, imageWidth: 35)
                
                    .overlay {
                        if !(reaction == .all) {
                            Image(systemName: reaction.systemImage(for: .reacted))
                                .foregroundColor(Color(uiColor: reaction.color()))
                                .padding(.all,3)
                                .background(.black)
                                .clipShape(.circle)
                            .offset(x: 10,y: 10)
                        }
                    }
                    .padding(.trailing, 10)
                Text(name)
                Spacer()
            }
        }
        .foregroundColor(.white)
    }
}

struct EachTab : View {
    @State var tab : EachReactionSection
    @Binding var isSelected : Bool
    var onTap : (EachReactionSection) -> Void
    var body: some View {
        let systemImage : String = tab.reaction.systemImage(for: .reacted)
        let systemName : String = tab.reaction .name(for: .reacted)
        let imageColor : UIColor = tab.reaction .color()
        Button{
            onTap(tab)
        }label: {
            VStack(spacing: 0){
                HStack{
                    if systemImage.isEmpty {
                        Text(systemName)
                            .foregroundColor(isSelected ? Color(uiColor: imageColor) : .white)
                            .fontWeight(.semibold)
                    }
                    else{
                        Image(systemName: systemImage)
                            .foregroundColor(Color(uiColor: imageColor))
                    }
                    Text(String(tab.reactionList.count))
                        .foregroundColor(isSelected ? Color(uiColor: imageColor) : .white)
                        .fontWeight(.semibold)
                }
                .scaleEffect(isSelected ? 1.2 : 1)
                Rectangle()
                    .fill(isSelected ? Color(uiColor: imageColor) : .clear)
                    .frame(width: 50, height: 2)
                    .cornerRadius(5)
                    .padding(.top, 5)
            }
            .padding(.top,15)
            .padding(.horizontal,5)
        }
    }
}

#Preview {
    AllReactionSheet(reactionModel: sampleReactionModel())
}

func sampleReactionModel () -> ReactionModel {
    return ReactionModel(all: AllReactionModel(count: 1, users: [sampleAuthorModel()]), like: [sampleAuthorModel(),sampleAuthorModel(),sampleAuthorModel()], love: [sampleAuthorModel()], haha: [sampleAuthorModel()], sad: [sampleAuthorModel()], angry: [sampleAuthorModel()])
}

func sampleAuthorModel () -> AuthorModel {
    return AuthorModel(id: Int.random(in: 1...10000), name: "author name \(Int.random(in: 1...10000))", image: "");
}
