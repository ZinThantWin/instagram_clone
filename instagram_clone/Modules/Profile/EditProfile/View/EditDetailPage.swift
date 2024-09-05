//
//  EditDetailPage.swift
//  instagram_clone
//
//  Created by ကင်ဇို on 04/09/2024.
//

import SwiftUI

struct EditDetailPage: View {
    @Environment(\.presentationMode) var presentationMode
    var body: some View {
        Text("Detail")
//        VStack{
//            if let model = vm.selectedEditDetail {
//                TextField(text: Binding(
//                    get: { model.value },
//                    set: { vm.selectedEditDetail?.value = $0 }
//                )) {
//                    Text(model.title)
//                } .overlay{
//                    textfieldClearButton
//                }
//            }
//            
//            Divider()
//            Text(vm.selectedEditDetail!.shortDes)
//            Spacer()
//        }
//        .navigationTitle(vm.selectedEditDetail!.title)
//        .toolbar{
//            ToolbarItem {
//                Button{
//                    presentationMode.wrappedValue.dismiss()
//                }label: {
//                    Text("Done")
//                }
//            }
//        }
    }
}

//extension EditDetailPage{
//    private var textfieldClearButton : some View{
//        HStack {
//            Spacer()
//            
//            if !vm.selectedEditDetail!.value.isEmpty {
//                Button(action: {
//                    vm.selectedEditDetail!.value  = ""
//                }) {
//                    Image(systemName: "xmark.circle.fill")
//                        .foregroundColor(.gray)
//                }
//                .padding(.trailing, 8)
//            }
//        }
//    }
//}
