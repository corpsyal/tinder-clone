//
//  ChatView.swift
//  Tinder
//
//  Created by Anthony Lahlah on 24.02.22.
//

import Foundation
import UIKit

class ChatView: UITableView {
    private let match: Match
    private var messages = [Message]()
    
    init(match: Match, messages: [Message]) {
        self.match = match
        self.messages = messages
        super.init(frame: .zero, style: .plain)
        translatesAutoresizingMaskIntoConstraints = false
        dataSource = self
        register(ChatCell.self, forCellReuseIdentifier: reuseMatchCellIdentifier)
        rowHeight = UITableView.automaticDimension
        estimatedRowHeight = 100
        
        print(messages)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension ChatView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseMatchCellIdentifier, for: indexPath) as! ChatCell
        
        return cell
    }
}
