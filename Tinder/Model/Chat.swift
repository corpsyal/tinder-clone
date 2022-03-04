//
//  Chat.swift
//  Tinder
//
//  Created by Anthony Lahlah on 20.02.22.
//

import Foundation


struct Chat {
    
    let messages: [Message]
    
    init(dictionnary: [String: Any]){
        messages = (
            (dictionnary["messages"] as? [[String: Any]]) ?? []
        ).map({ Message(dictionnary: $0)})
    }
}
