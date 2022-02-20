//
//  MessagesController.swift
//  Tinder
//
//  Created by Anthony Lahlah on 15.02.22.
//

import UIKit

private let reuseIdentifier = "Cell"

class MessagesController: UITableViewController {
    
    // MARK: Properties
    
    private let user: User
    
    init(user: User){
        self.user = user
        super.init(style: .plain)
    }
    
    override func viewDidLoad() {
        configureTableView()
        configureNavigationBar()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Helpers
    
    func configureTableView(){
        tableView.rowHeight = 80
        
        let matchHeader = MatchHeader(user: user)
        matchHeader.delegate = self
        tableView.tableHeaderView = matchHeader
        tableView.tableFooterView = UIView()
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: reuseIdentifier)
    }
    
    func configureNavigationBar(){
        let image = UIImageView(image: #imageLiteral(resourceName: "app_icon").withRenderingMode(.alwaysTemplate))
        image.tintColor = .lightGray
        
        //image.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            image.widthAnchor.constraint(equalToConstant: 28),
            image.heightAnchor.constraint(equalToConstant: 28),
        ])
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleDismiss))
        image.addGestureRecognizer(tap)
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: image)
        
        let icon = UIImageView(image: #imageLiteral(resourceName: "top_messages_icon").withRenderingMode(.alwaysTemplate))
        icon.tintColor = .systemPink
        
        navigationItem.titleView = icon
        //navigationItem.title = "Match"
        //navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    @objc func handleDismiss(){
        dismiss(animated: true, completion: nil)
    }
}

// MARK: UITableViewDataSource

extension MessagesController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath)
        
        return cell
    }
}

// MARK: UITableViewDelegate

extension MessagesController {
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = .white
        
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = #colorLiteral(red: 0.9826375842, green: 0.3476698399, blue: 0.447683692, alpha: 1)
        label.text = "Messages"
        label.font = UIFont.boldSystemFont(ofSize: 18)
        
        view.addSubview(label)
        NSLayoutConstraint.activate([
            label.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            label.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16)
        ])
        
        return view
    }
}

extension MessagesController: MatchHeaderDelegate {
    func startChatWith(_ match: Match) {
        print("start chat with \(match.name)")
        let chatController = ChatController(match: match)
        navigationController?.pushViewController(chatController, animated: true)
//        let nav = UINavigationController(rootViewController: ChatController())
//        present(nav, animated: true, completion: nil)
    }
}
