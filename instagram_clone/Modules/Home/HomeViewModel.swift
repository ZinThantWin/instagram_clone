//
//  HomeViewModel.swift
//  instagram_clone
//
//  Created by ကင်ဇို on 10/09/2024.
//

import Foundation
import SwiftUI

final class HomeViewModel : ObservableObject {
    @Published var selectedTab : Tab = .home
    
    func editFeed(destination : Tab,viewModel : AddFeedsViewModel){
        viewModel.editingAddedFeed = true
        selectedTab = destination
    }
}
