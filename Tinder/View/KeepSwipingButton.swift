//
//  KeepSwipingButton.swift
//  Tinder
//
//  Created by Anthony Lahlah on 12.02.22.
//

import UIKit

class KeepSwipingButton: UIButton {
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        let gradientLayer = CAGradientLayer()
        let leftColor = #colorLiteral(red: 1, green: 0.01176470588, blue: 0.4470588235, alpha: 1)
        let rightColor = #colorLiteral(red: 1, green: 0.3921568627, blue: 0.3176470588, alpha: 1)
        
        gradientLayer.colors = [leftColor.cgColor, rightColor.cgColor]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1, y: 0.5)
        
        let shape = CAShapeLayer()
        let path = CGMutablePath()
        
        path.addPath(UIBezierPath(roundedRect: rect, cornerRadius: rect.height / 2).cgPath)
        
        path.addPath(UIBezierPath(roundedRect: rect.insetBy(dx: 2, dy: 2), cornerRadius: rect.height / 2).cgPath)
        
        shape.path = path
        shape.fillRule = .evenOdd
        
        self.layer.insertSublayer(gradientLayer, at: 0)
        gradientLayer.mask = shape
        
        gradientLayer.frame = rect
        
        
    }
    
}
