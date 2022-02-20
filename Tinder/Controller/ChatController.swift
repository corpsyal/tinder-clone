//
//  ChatController.swift
//  Tinder
//
//  Created by Anthony Lahlah on 20.02.22.
//

import UIKit

private let reuseMatchCellIdentifier = "MessageCell"

class ChatController: UITableViewController {
    
    init(match: Match) {
        super.init(style: .plain)
    
        navigationItem.title = match.name
        
        tableView.register(MessageCell.self, forCellReuseIdentifier: reuseMatchCellIdentifier)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension ChatController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseMatchCellIdentifier, for: indexPath) as! MessageCell
        
        return cell
    }
}
