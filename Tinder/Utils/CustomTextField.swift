//
//  CustomTextField.swift
//  Tinder
//
//  Created by Anthony Lahlah on 05.08.21.
//

import UIKit

class CustomTextField: UITextField {
    init(placeholder: String, isSecureTextEntry: Bool = false) {
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        self.isSecureTextEntry = isSecureTextEntry
        
        
        borderStyle = .none
        textColor = .white
        backgroundColor = UIColor(white: 1, alpha: 0.2)
        layer.cornerRadius = 5
        attributedPlaceholder = NSAttributedString(string: placeholder, attributes: [
            .foregroundColor: UIColor(white: 1, alpha: 0.7)
        ])
        clearButtonMode = .whileEditing
        autocorrectionType = .no
        
        
        let paddingView = UIView()
        paddingView.widthAnchor.constraint(equalToConstant: 16).isActive = true
        leftView = paddingView
        leftViewMode = .always
        
        heightAnchor.constraint(equalToConstant: 50).isActive = true
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}








