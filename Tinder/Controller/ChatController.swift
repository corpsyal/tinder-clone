//
//  ChatController.swift
//  Tinder
//
//  Created by Anthony Lahlah on 20.02.22.
//

import UIKit

let reuseMatchCellIdentifier = "ChatCell"

class ChatController: UIViewController {
    
    private let match: Match
    private var chat: Chat = Chat(dictionnary: [:])  {
        didSet {
            configUI()
        }
    }
    
    init(match: Match) {
        self.match = match
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        navigationItem.title = match.name
        view.backgroundColor = .white
        initMessages()
    }
    
    func initMessages(){
        Service.fetchChatForUserUid(match.uid) { chat in
            self.chat = chat
        }
    }
    
    func configUI(){
        let chatView = ChatView(match: match, messages: chat.messages)
        view.addSubview(chatView)
        NSLayoutConstraint.activate([
            chatView.topAnchor.constraint(equalTo: view.topAnchor),
            chatView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            chatView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            chatView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
}

