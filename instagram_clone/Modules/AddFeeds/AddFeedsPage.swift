//
//  AddFeedsPage.swift
//  instagram_clone
//
//  Created by ကင်ဇို on 29/08/2024.
//

import SwiftUI
import PhotosUI

struct AddFeedsPage: View {
    @EnvironmentObject private var vm : AddFeedsViewModel
    @EnvironmentObject private var homeVM : HomeViewModel
    @State private var photosPickerItem : PhotosPickerItem?
    var body: some View {
        VStack{
            HStack{
                Spacer()
                if vm.editingAddedFeed {
                    Text("Edit post")
                        .fontWeight(.bold)
                } else {
                    Text("New post")
                        .fontWeight(.bold)
                }
                Spacer()
                if vm.editingAddedFeed {
                    Button {
                        vm.editingAddedFeed = false
                        homeVM.selectedTab = .home
                    } label: {
                        Image(systemName: "xmark")
                            .foregroundColor(.white)
                            .padding()
                    }
                }
            }
            TextField("title", text: $vm.title, prompt: Text("Write a title..."))
                .autocorrectionDisabled()
                .textInputAutocapitalization(.never)
                .padding(.horizontal,15)
            if !vm.title.isEmpty {
                TextField("content", text: $vm.content, prompt: Text("Write a content..."))
                    .autocorrectionDisabled()
                    .textInputAutocapitalization(.never)
                    .padding(.horizontal,15)
            }
            
            HStack{
                Spacer()
                if let imageUrl = vm.selectedImageInUrl {
                    NetworkImage(imageUrlInString: "https://social.petsentry.info\(imageUrl)", imageHeight: UIScreen.main.bounds.height * 0.4, imageWidth: .infinity)
                }
                else if let selectedImage = vm.selectedImageInFile {
                    Image(uiImage: selectedImage)
                        .resizable()
                        .scaledToFit()
                        .frame(maxWidth: .infinity, maxHeight: UIScreen.main.bounds.height * 0.4)
                }else{
                    VStack{
                        PhotosPicker(selection: $photosPickerItem) {
                            Image(systemName: "photo.fill")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 50,height: 50)
                        }
                        Text("add image")
                            .foregroundColor(.black)
                    }
                    .frame(maxWidth: .infinity,maxHeight: 100)
                }
                Spacer()
            }
            
            if !vm.title.isEmpty {
                Button{
                    if vm.editingAddedFeed {
                        Task{
                            await vm.updateNewFeed(for: vm.feedIdToEdit!)
                        }
                    } else{
                        Task{
                            await vm.uploadNewFeed()
                        }
                    }
                }label: {
                    Text("Share moment")
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity, maxHeight: 48)
                        .background(Color.blue)
                        .cornerRadius(8)
                }
                .padding(.bottom, 30)
                .padding(.horizontal, 15)
                .padding(.top, 20)
            }
            Spacer()
        }
        .alert(isPresented: $vm.showSuccessAlert, content: {
            Alert(title: Text("moment share success!"))
        })
        .onChange(of: photosPickerItem) { oldValue, newValue in
            Task{
                if let photosPickerItem,
                   let data = try? await photosPickerItem.loadTransferable(type: Data.self) {
                    vm.selectedImageInData = data
                    if let image = UIImage(data: data){
                        vm.selectedImageInFile = image
                    }
                }
            }
        }
    }
}

extension AddFeedsPage{
    private var loadingWidget : some View{
        Rectangle()
            .fill(Color.primary.gradient)
    }
}

#Preview {
    AddFeedsPage()
}
