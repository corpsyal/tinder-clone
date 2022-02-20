//
//  HomeNavigationStackView.swift
//  Tinder
//
//  Created by Anthony Lahlah on 13.07.21.
//

import UIKit
import FirebaseAuth

protocol BottomControlsStackViewDelegate: AnyObject {
    func handleDislike()
    func handleSuperLike()
    func handleLike()
}

class BottomControlsStackView: UIStackView {
    
    let backButton = UIButton(type: .system)
    let dislikeButton = UIButton(type: .system)
    let superLikeButton = UIButton(type: .system)
    let likeButton = UIButton(type: .system)
    let boostButton = UIButton(type: .system)
    
    var delegate: BottomControlsStackViewDelegate?
    
    private var onDislike: (() -> Void)?
    
    override init(frame: CGRect){
        super.init(frame: .zero)
        addButtons()
        configureButtons()
    }
    
    
    func addButtons(){
        heightAnchor.constraint(equalToConstant: 100).isActive = true
        
        backButton.setImage(#imageLiteral(resourceName: "refresh_circle").withRenderingMode(.alwaysOriginal), for: .normal)
        dislikeButton.setImage(#imageLiteral(resourceName: "dismiss_circle").withRenderingMode(.alwaysOriginal), for: .normal)
        superLikeButton.setImage(#imageLiteral(resourceName: "super_like_circle").withRenderingMode(.alwaysOriginal), for: .normal)
        likeButton.setImage(#imageLiteral(resourceName: "like_circle").withRenderingMode(.alwaysOriginal), for: .normal)
        boostButton.setImage(#imageLiteral(resourceName: "boost_circle").withRenderingMode(.alwaysOriginal), for: .normal)
        
        [backButton, dislikeButton, superLikeButton, likeButton, boostButton].forEach { (view) in
            addArrangedSubview(view)
        }
        
        distribution = .equalCentering
        isLayoutMarginsRelativeArrangement = true
        //layoutMargins = .init(top: 0, left: 16, bottom: 0, right: 16)
        
        //dislikeButton.addTarget(self, action: #selector(onDislike), for: .touchUpInside)
    }
    
    func configureButtons(){
        dislikeButton.addTarget(self, action: #selector(handleDislike), for: .touchUpInside)
        superLikeButton.addTarget(self, action: #selector(handleSuperlike), for: .touchUpInside)
        likeButton.addTarget(self, action: #selector(handleLike), for: .touchUpInside)
    }
    
    @objc func handleDislike(){
        delegate?.handleDislike()
    }
    
    @objc func handleSuperlike(){
        delegate?.handleSuperLike()
    }
    
    @objc func handleLike(){
        delegate?.handleLike()
    }
   
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
