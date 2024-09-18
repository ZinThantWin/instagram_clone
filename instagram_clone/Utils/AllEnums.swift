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

enum CommentSuggestedReaction {
    case like
    case love
    case tornado
    case rainbow
    case bolt
    case game
    case tennis
    case fire
    case cold
    
    var id: String {
            switch self {
            case .like:
                return "like"
            case .love:
                return "love"
            case .tornado:
                return "tornado"
            case .rainbow:
                return "rainbow"
            case .bolt:
                return "bolt"
            case .game:
                return "game"
            case .tennis:
                return "tennis"
            case .fire:
                return "fire"
            case .cold:
                return "cold"
            }
        }
    
    init?(from string: String) {
            switch string.lowercased() {
            case "like", "hand.thumbsup.fill":
                self = .like
            case "love", "heart.fill":
                self = .love
            case "tornado", "tornado.circle.fill":
                self = .tornado
            case "rainbow":
                self = .rainbow
            case "bolt", "bolt.fill":
                self = .bolt
            case "game", "gamecontroller.fill":
                self = .game
            case "tennis", "tennisball.fill":
                self = .tennis
            case "fire", "flame.fill":
                self = .fire
            case "cold", "wind":
                self = .cold
            default:
                self = .love
            }
        }
    
    func name() -> String {
        switch self {
        case .like:
            return "hand.thumbsup.fill"
        case .love:
            return "heart.fill"
        case .tornado:
            return "tornado"
        case .rainbow:
            return "rainbow"
        case .bolt:
            return "bolt.fill"
        case .game:
            return "gamecontroller.fill"
        case .tennis:
            return "tennisball.fill"
        case .fire:
            return "flame.fill"
        case .cold:
            return "wind"
        }
    }
    
    func color() -> UIColor  {
        switch self {
        case .like:
            return #colorLiteral(red: 0, green: 0.5898008943, blue: 1, alpha: 1)
        case .love:
            return #colorLiteral(red: 1, green: 0.1857388616, blue: 0.5733950138, alpha: 1)
        case .tornado:
            return #colorLiteral(red: 0.9999960065, green: 1, blue: 1, alpha: 1)
        case .rainbow:
            return #colorLiteral(red: 1, green: 0.2527923882, blue: 1, alpha: 1)
        case .bolt:
            return #colorLiteral(red: 0.8985771537, green: 0.9752448201, blue: 0, alpha: 1)
        case .game:
            return #colorLiteral(red: 0.9961428046, green: 0.2062371075, blue: 0.004998840857, alpha: 1)
        case .tennis:
            return #colorLiteral(red: 0, green: 0.9768045545, blue: 0, alpha: 1)
        case .fire:
            return #colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1)
        case .cold:
            return #colorLiteral(red: 0, green: 0.9914394021, blue: 1, alpha: 1)
        }
    }
}

enum Reaction: String, CaseIterable {
    case like
    case love
    case haha
    case sad
    case angry
    case all
    
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
        case .all:
            return "ALL"
        }
    }
    
    func systemImage(for state: State) -> String {
        switch self {
        case .like:
            return state == .reacted ? "hand.thumbsup.circle" : "hand.thumbsup"
        case .love:
            return state == .reacted ? "heart.fill" : "heart"
        case .haha:
            return state == .notReacted ? "face.smiling.inverse" : "face.smiling"
        case .sad:
            return state == .notReacted ? "poweroutlet.type.h" : "poweroutlet.type.h.fill"
        case .angry:
            return state == .notReacted ? "bird.circle" : "bird.circle.fill"
        case .all:
            return ""
        }
    }
    
    func color() -> UIColor  {
        switch self {
        case .like:
            return #colorLiteral(red: 0, green: 0.5898008943, blue: 1, alpha: 1)
        case .love:
            return #colorLiteral(red: 1, green: 0.1857388616, blue: 0.5733950138, alpha: 1)
        case .all:
            return #colorLiteral(red: 0.2196078449, green: 0.007843137719, blue: 0.8549019694, alpha: 1)
        case .angry:
            return #colorLiteral(red: 0.7450980544, green: 0.1568627506, blue: 0.07450980693, alpha: 1)
        case .haha:
            return #colorLiteral(red: 0.9686274529, green: 0.78039217, blue: 0.3450980484, alpha: 1)
        case .sad:
            return #colorLiteral(red: 0.9607843161, green: 0.7058823705, blue: 0.200000003, alpha: 1)
        }
    }
}
