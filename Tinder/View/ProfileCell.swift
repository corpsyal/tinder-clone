//
//  ProfileCell.swift
//  Tinder
//
//  Created by Anthony Lahlah on 31.10.21.
//

import UIKit


class ProfileCell: UICollectionViewCell {
    
    let imageView = UIImageView()
    var barStackView: SegmentedBarView?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        imageView.contentMode = .scaleAspectFill
        addSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        print(imageView.superview!)

        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: imageView.superview!.topAnchor),
            imageView.bottomAnchor.constraint(equalTo: imageView.superview!.bottomAnchor),
            imageView.leadingAnchor.constraint(equalTo: imageView.superview!.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: imageView.superview!.trailingAnchor),
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
