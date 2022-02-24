//
//  Message.swift
//  Tinder
//
//  Created by Anthony Lahlah on 20.02.22.
//

import Foundation


struct Message {
    let content: String
    let from: String
    let read: Bool
    //let time: Date
    
    init(dictionnary: [String: Any]){
        content = dictionnary["content"] as? String ?? ""
        from = dictionnary["from"] as? String ?? ""
        read = dictionnary["read"] as? Bool ?? false
    }
}
