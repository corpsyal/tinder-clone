//
//  SegmentedBarView.swift
//  Tinder
//
//  Created by Anthony Lahlah on 27.11.21.
//

import UIKit

class SegmentedBarView: UIStackView {
    
    init(number: Int) {
        super.init(frame: CGRect.zero)
        
        (0..<number).forEach { _ in
            let bar = UIView()
            bar.translatesAutoresizingMaskIntoConstraints = false
            bar.backgroundColor = .barDeselectedColor
            addArrangedSubview(bar)
        }
        
        translatesAutoresizingMaskIntoConstraints = false
        spacing = 5
        
        arrangedSubviews.first?.backgroundColor = .white
        distribution = .fillEqually
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func highlight(index: Int){
        for (i, barView) in arrangedSubviews.enumerated(){
            barView.backgroundColor = i == index ? .white : .barDeselectedColor
        }
    }
    
    func configure(view: UIView) {
        view.addSubview(self)
        NSLayoutConstraint.activate([
            self.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8),
            self.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8),
            self.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -8),
            self.heightAnchor.constraint(equalToConstant: 4),
        ])

        highlight(index: 0)
    }
    
}
