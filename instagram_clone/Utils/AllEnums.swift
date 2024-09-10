//
//  AllEnums.swift
//  instagram_clone
//
//  Created by ကင်ဇို on 05/09/2024.
//

import Foundation
import SwiftUI

enum Tab {
    case home
    case search
    case add
    case list
    case profile
}

enum EditDetailEnum {
    case name
    case email
    case bio
}
enum Reaction: String, CaseIterable {
    case like
    case love
    case haha
    case sad
    case angry
    
    enum State {
        case reacted
        case notReacted
    }
    
    func name(for state: State) -> String {
        switch self {
        case .like:
            return "LIKE"
        case .love:
            return "LOVE"
        case .haha:
            return "HAHA"
        case .sad:
            return "SAD"
        case .angry:
            return "ANGRY"
        }
    }
    
    func systemImage(for state: State) -> String {
        switch self {
        case .like:
            return state == .reacted ? "hand.thumbsup.fill" : "hand.thumbsup"
        case .love:
            return state == .reacted ? "heart.fill" : "heart"
        case .haha:
            return state == .notReacted ? "face.smiling.inverse" : "face.smiling"
        case .sad:
            return state == .notReacted ? "poweroutlet.type.h" : "poweroutlet.type.h.fill"
        case .angry:
            return state == .notReacted ? "bird.circle" : "bird.circle.fill"
        }
    }
}
