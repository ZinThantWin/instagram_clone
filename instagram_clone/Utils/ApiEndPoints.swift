//
//  ApiEndPoints.swift
//  instagram_clone
//
//  Created by ကင်ဇို on 20/08/2024.
//

import Foundation


class ApiEndPoints {
    // Image
    static let imageBaseUrl : String = "https://social.petsentry.info"
    
    // Auth
    static let registerUser : String = "auth/register"
    static let validateUser : String = "auth/validate"
    static let logInUser : String = "auth/login"
    
    // Feed
    static let posts : String = "posts"
    static let followedPosts : String = "posts/followers"
    
    // Users
    static let users : String = "users"
    
    // Reactions
    static let reaction : String = "likes/reactions"
    
    // Comments
    static let comment : String = "comments"
    
    // Suggested Friend
    static let suggestedFriend : String = "users/suggested"
    
    // Follow
    static let follow : String = "follows/follow"
    static let unfollow : String = "follows/unfollow"
    
    // Share
    static let share : String = "shares"
}
