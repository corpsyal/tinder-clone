//
//  User.swift
//  Tinder
//
//  Created by Anthony Lahlah on 30.07.21.
//

import UIKit

struct User {
    var name: String
    var age: Int
    var email: String
    let uid: String
    var imageURLs: [String]
    var profession: String
    var bio: String
    var images: [UIImage]
    var minSeekAge: Int
    var maxSeekAge: Int
    let matches: [Match]
    
    init(dictionnary: [String: Any]) {
        self.name = dictionnary["fullName"] as? String ?? ""
        self.age = dictionnary["age"] as? Int ?? 0
        self.email =  dictionnary["email"] as? String ?? ""
        self.uid = dictionnary["uid"] as! String
        self.profession = dictionnary["profession"] as? String ?? ""
        self.bio = dictionnary["bio"] as? String ?? ""
        self.imageURLs = dictionnary["imageURLs"] as? [String] ?? []
        self.images = []
        self.minSeekAge = dictionnary["minSeekAge"] as? Int ?? 18
        self.maxSeekAge = dictionnary["maxSeekAge"] as? Int ?? 50
        self.matches = (dictionnary["matches"] as? [[String: String]] ?? []).map({ Match($0)})
    }
}
