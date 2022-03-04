//
//  Message.swift
//  Tinder
//
//  Created by Anthony Lahlah on 20.02.22.
//

import Foundation
import FirebaseFirestore

struct Message {
    let id: String
    let content: String
    let from: String
    let read: Bool
    let time: Timestamp
}

extension Message {
    init(dictionnary: [String: Any]){
        id = dictionnary["id"] as? String ?? ""
        content = dictionnary["content"] as? String ?? ""
        from = dictionnary["from"] as? String ?? ""
        read = dictionnary["read"] as? Bool ?? false
        time = dictionnary["time"] as! Timestamp
    }
}
