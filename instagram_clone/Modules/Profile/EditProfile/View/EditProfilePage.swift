import SwiftUI
import PhotosUI

struct EditProfilePage: View {
    @EnvironmentObject private var vm : ProfileViewModel
    @State private var photosPickerItem : PhotosPickerItem?
    var body: some View {
        VStack{
            if let fileImage = vm.selectedImage{
                Image(uiImage: fileImage)
                    .resizable()
                    .frame(width: 80, height: 80)
                    .clipShape(.circle)
            }else{
                if let image = vm.userDetail!.image {
                    NetworkImage(imageUrlInString: "https://social.petsentry.info\(image)", imageHeight: 80, imageWidth: 80)
                        .clipShape(.circle)
                }else{
                    DummyProfile(size: 80)
                        .clipShape(.circle)
                }
            }
            PhotosPicker(selection: $photosPickerItem) {
                Text("Edit profile picture")
            }
            List{
                Button{
                    vm.selectedDetailEdit = EditProfileDetailModel(title: "Name", value: vm.editedName ?? vm.userDetail!.name, shortDes: "Most of the time, you can change your name back in 14 days.", type: .name)
                    vm.navigateToDetailEdit = true
                }label: {
                    HStack {
                        Text("Name")
                            .frame(width : 80, alignment: .leading)
                        Text(vm.editedName ?? vm.userDetail?.name ?? "")
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                }
                
                Button{
                    vm.selectedDetailEdit = EditProfileDetailModel(title: "Email", value: vm.editedEmail ?? vm.userDetail!.email, shortDes: "Most of the time, you can change your email back in 14 days.", type: .email )
                    vm.navigateToDetailEdit = true
                }label: {
                    HStack {
                        Text("Email")
                            .frame(width : 80, alignment: .leading)
                        
                        Text(vm.editedEmail ?? vm.userDetail?.email ?? "")
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                }
                Button{
                    vm.selectedDetailEdit = EditProfileDetailModel(title: "Bio", value: vm.editedBio ?? vm.userDetail!.bio ?? "", shortDes: "Short description that describes you the best.", type: .bio  )
                    vm.navigateToDetailEdit = true
                }label: {
                    HStack {
                        Text("Bio")
                            .frame(width : 80, alignment: .leading)
                        
                        Text(vm.editedBio ?? vm.userDetail?.bio ?? "")
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                }
            }
            .listStyle(.plain)
            Spacer()
        }
        .onChange(of: photosPickerItem, { oldValue, newValue in
            Task{
                if let photosPickerItem,
                   let data = try? await photosPickerItem.loadTransferable(type: Data.self){
                    vm.selectedImageInData = data
                    if let image = UIImage(data: data){
                        vm.selectedImage = image
                    }
                }
            }
        })
        .onChange(of: vm.selectedDetailEdit.value) { oldValue, newValue in
            Task{
                await MainActor.run {
                    if vm.editedName == vm.userDetail?.name && vm.editedEmail == vm.userDetail?.email &&  vm.editedBio == vm.userDetail?.bio {
                        vm.detailHasBeenEdited = false 
                    } else {
                        vm.detailHasBeenEdited = true
                    }
                    if newValue.isEmpty {
                        switch vm.selectedDetailEdit.type {
                        case .name:
                            vm.editedName = vm.userDetail?.name
                        case .email:
                            vm.editedEmail = vm.userDetail?.email
                        case .bio:
                            vm.editedBio = vm.userDetail?.bio
                        }
                    } else {
                        switch vm.selectedDetailEdit.type {
                        case .name:
                            vm.editedName = newValue
                        case .email:
                            vm.editedEmail = newValue
                        case .bio:
                            vm.editedBio = newValue
                        }
                    }
                }
            }
        }
        .onDisappear{
            vm.resetEditedData()
        }
        .toolbar{
            ToolbarItem {
                if vm.detailHasBeenEdited {
                    Button{
                        vm.showPasswordSheet = true
                    }label: {
                        Text("Save")
                    }
                }
            }
        }
        .sheet(isPresented: $vm.showPasswordSheet, content: {
            ConfirmPasswordSheet()
                .presentationDetents([.height(100)])
                .presentationDragIndicator(.visible)
        })
        .navigationDestination(isPresented: $vm.navigateToDetailEdit, destination: {
            if let _ = vm.userDetail {
                EditDetailPage()
            }else{
                Text("Error")
            }
        })
    }
}

struct EachEditRow : View {
    @State var title : String
    @Binding var value : String
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
