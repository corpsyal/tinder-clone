//
//  MatchViewViewModel.swift
//  Tinder
//
//  Created by Anthony Lahlah on 13.02.22.
//

import Foundation

struct MatchViewViewModel {
    
    private let currentUser: User
    private let matchedUser: User
    
    let matchLabel: String
    
    let currentUserImageUrl: URL
    let matchedUserImageUrl: URL
    
    init(currentUser: User, matchedUser: User){
        self.currentUser = currentUser
        self.matchedUser = matchedUser
        
        self.matchLabel = "You and \(matchedUser.name) have liked each other !"
        
        self.currentUserImageUrl = URL(string: currentUser.imageURLs.first ?? "")!
        self.matchedUserImageUrl = URL(string: matchedUser.imageURLs.first ?? "")!
    }
    
    func getMatchedUser() -> User {
        return matchedUser
    }
}
