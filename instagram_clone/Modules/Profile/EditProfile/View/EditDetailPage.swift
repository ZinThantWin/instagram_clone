//
//  EditDetailPage.swift
//  instagram_clone
//
//  Created by ကင်ဇို on 04/09/2024.
//

import SwiftUI

struct EditDetailPage: View {
    @EnvironmentObject private var vm : ProfileViewModel
    @Environment(\.presentationMode) var presentationMode
    var body: some View {
        VStack{
            Divider()
            TextField(text: Binding(
                get: { vm.selectedDetailEdit.value },
                set: { vm.selectedDetailEdit.value = $0 }
            )) {
                Text(vm.selectedDetailEdit.title)
            } .overlay{
                textfieldClearButton
            }.padding()
            
            Divider()
            Text(vm.selectedDetailEdit.shortDes)
            Spacer()
        }
        .navigationTitle(vm.selectedDetailEdit.title)
        .toolbar{
            ToolbarItem {
                Button{
                    presentationMode.wrappedValue.dismiss()
                }label: {
                    Text("Done")
                }
            }
        }
    }
}

extension EditDetailPage{
    private var textfieldClearButton : some View{
        HStack {
            Spacer()
            
            if !vm.selectedDetailEdit.value.isEmpty {
                Button(action: {
                    vm.selectedDetailEdit.value  = ""
                }) {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.gray)
                }
                .padding(.trailing, 8)
            }
        }
    }
}
