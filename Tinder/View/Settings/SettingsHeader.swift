//
//  SettingsHeader.swift
//  Tinder
//
//  Created by Anthony Lahlah on 05.09.21.
//

import UIKit
import SDWebImage

protocol SettingsHeaderDelegate: AnyObject {
    func settingsHeader(_ settingsHeader: SettingsHeader, didSelect index: Int)
}

class SettingsHeader: UIView {
    
    // MARK: - Properties
    
    let user: User
    var buttons: [UIButton] = []
    weak var delegate: SettingsHeaderDelegate?
    
    // MARK: - Initalizers
    
    init(user: User) {
        self.user = user
        super.init(frame: .zero)
        //translatesAutoresizingMaskIntoConstraints = false
        
        backgroundColor = .systemGroupedBackground
        
        let button1 = createButton(0)
        let button2 = createButton(1)
        let button3 = createButton(2)
        
        buttons.append(button1)
        buttons.append(button2)
        buttons.append(button3)
        
        addSubview(button1)
        
        NSLayoutConstraint.activate([
            button1.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            button1.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            button1.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16),
            button1.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.45)
        ])
        
        let stackView = UIStackView(arrangedSubviews: [button2, button3])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.spacing = 16
        addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16),
            stackView.leadingAnchor.constraint(equalTo: button1.trailingAnchor, constant: 16),
            stackView.rightAnchor.constraint(equalTo: rightAnchor, constant: -16)
        ])
        
        loadUserPhotos()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Helpers
    
    func createButton(_ index: Int) -> UIButton {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Select photo", for: .normal)
        button.layer.cornerRadius = 10
        button.clipsToBounds = true
        button.backgroundColor = .white
        button.addTarget(self, action: #selector(handleSelectPhoto), for: .touchUpInside)
        button.imageView?.contentMode = .scaleAspectFill
        button.tag = index
        
        return button
    }
    
    func loadUserPhotos(){
        let imageURLs = user.imageURLs.map({ URL(string: $0) })
        
        for (index, url) in imageURLs.enumerated() {
            //SDWebImageManager.shared().load
            SDWebImageManager.shared.loadImage(with: url, options: .continueInBackground, progress: nil) { image, _, _, _, _, _ in
                self.buttons[index].setImage(image?.withRenderingMode(.alwaysOriginal), for: .normal)
            }
        }
    }
    
    // MARK: - Handlers
    
    @objc func handleSelectPhoto(button: UIButton){
        delegate?.settingsHeader(self, didSelect: button.tag)
    }
}
