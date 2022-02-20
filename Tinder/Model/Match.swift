//
//  Match.swift
//  Tinder
//
//  Created by Anthony Lahlah on 18.02.22.
//

import Foundation


struct Match {
    let uid: String
    let profileURL: String
    let name: String
    
    init(_ match: [String: String]){
        uid = match["uid"]!
        profileURL = match["profileURL"]!
        name = match["name"]!
    }
}
