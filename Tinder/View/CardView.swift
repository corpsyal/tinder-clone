//
//  CardView.swift
//  Tinder
//
//  Created by Anthony Lahlah on 14.07.21.
//

import UIKit
import SDWebImage

enum SwipeDirection: Int {
    case left = -1
    case right = 1
}

protocol CardViewDelegate: AnyObject {
    func showProfile(_ cardView: CardView, wantsToShowProfileFor: User)
    func saveLikeAfterAnim(user: User, like: Bool)
}

class CardView: UIView {
    lazy var barStackView = SegmentedBarView(number: viewModel.imageUrls.count)
    private let gradientLayer = CAGradientLayer()
    let viewModel: CardViewModel
    
    var delegate: CardViewDelegate?
    
    private let imageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        return iv
    }()
    
    private var infoLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
        
        return label
    }()
    
    private let infoButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "info_icon").withRenderingMode(.alwaysOriginal), for: .normal)
        button.addTarget(self, action: #selector(handleInfoButton), for: .touchUpInside)
        return button
    }()
    
    @objc func handleInfoButton(sender: UIButton!) {
        delegate?.showProfile(self, wantsToShowProfileFor: viewModel.user)
    }
    
    init(viewModel: CardViewModel) {
        self.viewModel = viewModel
        super.init(frame: .zero)
        
        backgroundColor = .white
        
        translatesAutoresizingMaskIntoConstraints = false
        
        imageView.sd_setImage(with: viewModel.imageUrl)
        infoLabel.attributedText = viewModel.userInfoLabel
        
        layer.cornerRadius = 10
        clipsToBounds = true
        
        addSubview(imageView)
        imageView.fillSuperview()
        
        configureGradientLayer()
        
        addSubview(infoLabel)
        infoLabel.anchor(left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingLeft: 16, paddingBottom: 16, paddingRight: 16)
        
        addSubview(infoButton)
        infoButton.setDimensions(height: 40, width: 40)
        infoButton.centerY(inView: infoLabel)
        infoButton.anchor(right: rightAnchor, paddingRight: 16)
        
        configureGestureRecognizer()
        
        barStackView.configure(view: self)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        gradientLayer.frame = self.frame
    }
    
    func configureGradientLayer() {
        gradientLayer.colors = [UIColor.clear.cgColor, UIColor.black.cgColor]
        gradientLayer.locations = [0.5, 1.1]
        layer.addSublayer(gradientLayer)
    }
    
    func configureGestureRecognizer() {
        let pan = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture))
        addGestureRecognizer(pan)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTapGesture))
        addGestureRecognizer(tap)
    }
    
    @objc func handlePanGesture(sender: UIPanGestureRecognizer) {
        switch sender.state {
            case .began:
                print("began")
                superview?.subviews.forEach({ (subview) in
                    subview.layer.removeAllAnimations()
                })
            case .changed:
                panCard(sender: sender)
            case .ended:
                resetCardPosition(sender: sender)
            default: break
        }
    }
    
    @objc func handleTapGesture(sender: UITapGestureRecognizer) {
        let location = sender.location(in: nil).x
        let shouldDisplayNext = location > frame.width/2
        
        if shouldDisplayNext {
            viewModel.showNextPhoto()
        } else {
            viewModel.showPreviousPhoto()
        }
        
        imageView.sd_setImage(with: viewModel.imageUrl, completed: nil)
        barStackView.highlight(index: viewModel.index)
    }
    
    func panCard(sender: UIPanGestureRecognizer){
        let translation = sender.translation(in: nil)
        let degree = translation.x / 20
        let angle = degree * (.pi/180)
        let rotationalTransform = CGAffineTransform(rotationAngle: -angle)
        self.transform = rotationalTransform.translatedBy(x: translation.x, y: translation.y)
    }
    
    func resetCardPosition(sender: UIPanGestureRecognizer){
        let x = sender.translation(in: nil).x
        let direction: SwipeDirection = x < 0 ? .left : .right
        let shouldDismissCard = abs(x) > 100
        
        UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.1, options: .curveEaseOut) {
            
            if(shouldDismissCard){
                print(self.transform)
                let xTranslation = CGFloat(direction.rawValue) * 1000
                let offScreenTransform = self.transform.translatedBy(x: xTranslation, y: 0)
                self.transform = offScreenTransform
            } else {
                self.transform = .identity // reset position
            }
        } completion: { (Bool) in
            if (shouldDismissCard) {
                self.delegate?.saveLikeAfterAnim(user: self.viewModel.user, like: direction == .right)
                self.removeFromSuperview()
                
            }
        }

    }
    
}
