//
//  MessageCell.swift
//  Tinder
//
//  Created by Anthony Lahlah on 20.02.22.
//

import UIKit

class ChatCell: UITableViewCell {
    
    var message = ""
    
    private let selfMessageView: UIView = {
       let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .yellow
        view.layer.cornerRadius = 5
        view.clipsToBounds = true
        view.widthAnchor.constraint(equalToConstant: 100).isActive = true
        
        return view
    }()
    
    private let messageLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.textColor = .darkText
        label.backgroundColor = .green
        label.text = "TOTO \n test \n fdlgkdf"
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = UIColor.cyan
        
        selfMessageView.addSubview(messageLabel)
        contentView.addSubview(selfMessageView)
        NSLayoutConstraint.activate([
            selfMessageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            selfMessageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16),
            selfMessageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16)
        ])
        
        
        NSLayoutConstraint.activate([
            messageLabel.topAnchor.constraint(equalTo: selfMessageView.topAnchor),
            messageLabel.bottomAnchor.constraint(equalTo: selfMessageView.bottomAnchor),
            messageLabel.leadingAnchor.constraint(equalTo: selfMessageView.leadingAnchor),
            messageLabel.trailingAnchor.constraint(equalTo: selfMessageView.trailingAnchor)
        ])
        
        
     
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
