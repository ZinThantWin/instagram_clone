//
//  AddFeedsPage.swift
//  instagram_clone
//
//  Created by ကင်ဇို on 29/08/2024.
//

import SwiftUI
import PhotosUI

struct AddFeedsPage: View {
    @StateObject private var vm : AddFeedsViewModel  = AddFeedsViewModel()
    @State private var photosPickerItem : PhotosPickerItem?
    var body: some View {
        VStack{
            PhotosPicker(selection: $photosPickerItem) {
                Image(systemName: "plus.app")
            }
            Text("New post")
            if let selectedImage = vm.selectedImage {
                Image(uiImage: selectedImage)
                    .resizable()
                    .frame(maxWidth: .infinity, maxHeight: UIScreen.main.bounds.height * 0.4)
            }else{
                Text("No image selected")
            }
            Button{
                Task{
                    await vm.uploadImage()
                }
            }label: {
                Text("Upload")
            }
        }
        .onChange(of: photosPickerItem) { oldValue, newValue in
            Task{
                if let photosPickerItem,
                   let data = try? await photosPickerItem.loadTransferable(type: Data.self) {
                    vm.selectedImageInData = data
                    if let image = UIImage(data: data){
                        vm.selectedImage = image
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
