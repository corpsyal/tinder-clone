//
//  ProfileViewModel.swift
//  Tinder
//
//  Created by Anthony Lahlah on 27.11.21.
//

import Foundation
import UIKit

struct ProfileViewModel {
    
    let user: User
    
    let userDetailsAttributedString: NSAttributedString
    let profession: String
    let bio: String
    
    var imageCount: Int  {
        return user.imageURLs.count
    }
    
    var images: [URL] {
        return user.imageURLs.map {URL(string: $0)!}
    }
    
    
    
    init(user: User){
        self.user = user
        
        let attributedString = NSMutableAttributedString(string: user.name, attributes: [
            .font: UIFont.systemFont(ofSize: 24, weight: .semibold)
        ])
        
        attributedString.append(NSAttributedString(string: " \(user.age)", attributes: [
            .font: UIFont.systemFont(ofSize: 22)
        ]))
        
        userDetailsAttributedString = attributedString
        
        profession = user.profession
        bio = user.bio
    }
}
