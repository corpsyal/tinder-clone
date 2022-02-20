//
//  SettingsFooter.swift
//  Tinder
//
//  Created by Anthony Lahlah on 03.10.21.
//

import UIKit

protocol SettingsFooterDelegate: AnyObject {
    func handleLogout()
}

class SettingsFooter: UIView {
    
    weak var delegate: SettingsFooterDelegate?
    
    private lazy var logoutButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Logout", for: .normal)
        button.setTitleColor(.red, for: .normal)
        button.backgroundColor = .white
        button.addTarget(self, action: #selector(self.handleLogout), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
       
        let spacer = UIView()
        spacer.translatesAutoresizingMaskIntoConstraints = false
        spacer.backgroundColor = .systemGroupedBackground
        addSubview(spacer)
        NSLayoutConstraint.activate([
            spacer.widthAnchor.constraint(equalTo: widthAnchor),
            spacer.heightAnchor.constraint(equalToConstant: 32),
        ])
        
        addSubview(logoutButton)
        NSLayoutConstraint.activate([
            logoutButton.topAnchor.constraint(equalTo: spacer.bottomAnchor),
            logoutButton.widthAnchor.constraint(equalTo: widthAnchor),
            logoutButton.heightAnchor.constraint(equalToConstant: 50),
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func handleLogout(){
        delegate?.handleLogout()
    }
}
