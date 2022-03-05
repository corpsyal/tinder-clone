//
//  AuthButton.swift
//  Tinder
//
//  Created by Anthony Lahlah on 05.08.21.
//

import UIKit

class AuthButton: UIButton {
    static let disableBackgroundColor = #colorLiteral(red: 0.9098039269, green: 0.4784313738, blue: 0.6431372762, alpha: 1)
    static let enableBackgroundColor = #colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 1)
    
    override init(frame: CGRect){
        super.init(frame: frame)
        setTitleColor(.white, for: .normal)
        backgroundColor = AuthButton.disableBackgroundColor
        layer.cornerRadius = 5
        
        heightAnchor.constraint(equalToConstant: 50).isActive = true
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
