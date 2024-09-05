import SwiftUI

struct EditProfilePage: View {
    @EnvironmentObject private var vm : ProfileViewModel
    var body: some View {
        VStack{
            HStack(alignment: .center){
                Text("Edit profile")
                    .fontWeight(.semibold)
                    .font(.title2)
                    .onTapGesture {
                        superPrint("dkfjkdfj")
                    }
            }
            if let image = vm.userDetail!.image {
                NetworkImage(imageUrlInString: "https://social.petsentry.info\(image)", imageHeight: 80, imageWidth: 80)
                    .clipShape(.circle)
            }else{
                DummyProfile(size: 80)
                    .clipShape(.circle)
            }
            Button{}label: {
                Text("Edit profile picture")
            }
            List{
                EachEditRow(title: "Name", value: vm.userDetail!.name) {
                }
                EachEditRow(title: "Email", value: vm.userDetail!.email) {
                    
                }
                EachEditRow(title: "Bio", value: vm.userDetail!.bio ?? "") {
                    
                }
            }
            .listStyle(.plain)
            Spacer()
        }
//        .navigationDestination(isPresented: $vm .navigateToEditDetail, destination: {
//            if let detail = vm.selectedEditDetail {
//                EditDetailPage()
//            }else{
//                Text("Error")
//            }
//        })
    }
}

struct EachEditRow : View {
    @State  var title : String
    @State  var value : String
    var onTap : () -> Void
    var body: some View {
        Button{
            onTap()
        }label: {
            HStack {
                Text(title)
                    .frame(width : 80, alignment: .leading)
                if value.isEmpty {
                    Text(title)
                        .foregroundColor(.secondary)
                        .frame(maxWidth: .infinity, alignment: .leading)
                } else {
                    Text(value)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
            }
        }
    }
}
