import SwiftUI

struct ShareSheet : View {
    @EnvironmentObject private var vm : FeedsViewModel
    @EnvironmentObject private var profileVm : ProfileViewModel
    @State private var shareTitle: String = ""
    var body: some View {
        VStack{
            if let profile = profileVm.ownerDetail{
                HStack{
                    if let userImage = profile.image {
                        CachedAsyncImage(url : URL(string: "\(ApiEndPoints.imageBaseUrl)\(userImage)")!, width: 50, height: 50, isCircle: true)
                    }else {
                        DummyProfile(size: 50)
                    }
                    Text(profile.name)
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                    Spacer()
                }
            }
            TextField(text: $shareTitle) {
                Text("Say something about this...")
            }
            .textFieldStyle(.plain)
            Button{
                Task {
                    await vm.sharePost(for: vm.feedToShare.id, title: shareTitle)
                    vm.showReactionRow = false
                    vm.selectedFeed = nil
                    shareTitle = ""
                    vm.showShareBottomsheet = false
                }
            }label: {
                HStack{
                    Spacer()
                    Text("share now")
                        .foregroundColor(.white)
                        .padding(.horizontal, 20)
                        .padding(.vertical, 8)
                        .background(.blue)
                        .cornerRadius(5)
                }
            }
        }
        .padding(.horizontal,15)
        .padding(.vertical,15)
    }
}

#Preview {
    ShareSheet()
}

