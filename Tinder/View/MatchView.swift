//
//  MatchView.swift
//  Tinder
//
//  Created by Anthony Lahlah on 07.02.22.
//

import UIKit

protocol MatchViewDelegate: AnyObject {
    func sendMessageTo(_ user: User) -> Void
}

class MatchView: UIView {
    
    // MARK: - Properties
    private let viewModel: MatchViewViewModel
    
    weak var delegate: MatchViewDelegate?
    
    private let matchImageView: UIImageView = {
        let iv = UIImageView(image: #imageLiteral(resourceName: "itsamatch"))
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.contentMode = .scaleAspectFill
        
        return iv
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 20)
        label.numberOfLines = 0
        return label
    }()
    
    private let currentUserImageView: UIImageView = {
        let iv = UIImageView(image: #imageLiteral(resourceName: "jane2"))
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.layer.cornerRadius = 140/2
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.layer.borderWidth = 2
        iv.layer.borderColor = UIColor.white.cgColor
        
        return iv
    }()
    
    private let matchUserImageView: UIImageView = {
        let iv = UIImageView(image: #imageLiteral(resourceName: "kelly1"))
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.layer.cornerRadius = 140/2
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.layer.borderWidth = 2
        iv.layer.borderColor = UIColor.white.cgColor
        
        return iv
    }()
    
    private let sendMessageButton: UIButton = {
        let button = SendMessageButton(type: .system)
        //button.backgroundColor = .green
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("SEND MESSAGE", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.addTarget(self, action: #selector(didTapSendMessage), for: .touchUpInside)
        return button
    }()
    
    private let keepSwipingButton: UIButton = {
        let button = KeepSwipingButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("KEEP SWIPING", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.addTarget(self, action: #selector(handledismiss), for: .touchUpInside)
        return button
    }()
    
    let visualEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .dark))
    
    lazy var views = [
        matchImageView,
        descriptionLabel,
        currentUserImageView,
        matchUserImageView,
        matchImageView,
        sendMessageButton,
        keepSwipingButton
    ]
    
    // MARK: - Lifecycle
    
    init(viewModel: MatchViewViewModel){
        self.viewModel = viewModel
        super.init(frame: .zero)
        
        loadUsersData()
        configureBlurView()
        configView()
        configureAnimations()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configView(){
        views.forEach { view in
            addSubview(view)
            //view.alpha = 0
        }
        
        NSLayoutConstraint.activate([
            currentUserImageView.centerXAnchor.constraint(equalTo: centerXAnchor, constant: (-140/2)-16),
            currentUserImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            currentUserImageView.widthAnchor.constraint(equalToConstant: 140),
            currentUserImageView.heightAnchor.constraint(equalToConstant: 140)
        ])
        
        NSLayoutConstraint.activate([
            matchUserImageView.centerXAnchor.constraint(equalTo: centerXAnchor, constant: (140/2)+16),
            matchUserImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            matchUserImageView.widthAnchor.constraint(equalToConstant: 140),
            matchUserImageView.heightAnchor.constraint(equalToConstant: 140)
        ])
        
        NSLayoutConstraint.activate([
            sendMessageButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            sendMessageButton.topAnchor.constraint(equalTo: currentUserImageView.bottomAnchor, constant: 32),
            sendMessageButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            sendMessageButton.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        NSLayoutConstraint.activate([
            keepSwipingButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            keepSwipingButton.topAnchor.constraint(equalTo: sendMessageButton.bottomAnchor, constant: 16),
            keepSwipingButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            keepSwipingButton.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        NSLayoutConstraint.activate([
            descriptionLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            descriptionLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            //descriptionLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            descriptionLabel.bottomAnchor.constraint(equalTo: currentUserImageView.topAnchor, constant: -32)
        ])
        
        NSLayoutConstraint.activate([
            matchImageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            matchImageView.bottomAnchor.constraint(equalTo: descriptionLabel.topAnchor, constant: -32)
        ])
    }
    
    // MARK: - Actions
    
    @objc func didTapSendMessage(){
        delegate?.sendMessageTo(viewModel.getMatchedUser())
    }
    
    @objc func handledismiss(){
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.alpha = 0
        }, completion: {_ in
            self.removeFromSuperview()
        })
    }
    
    // MARK: - Hekpers
    
    func loadUsersData(){
        descriptionLabel.text = viewModel.matchLabel
        //descriptionLabel.sizeToFit()
        currentUserImageView.sd_setImage(with: viewModel.currentUserImageUrl)
        matchUserImageView.sd_setImage(with: viewModel.matchedUserImageUrl)
    }
    
    func configureAnimations(){
        //views.forEach({ $0.alpha = 1 })
        
        let angle = 30 * CGFloat.pi / 180
        
        
        currentUserImageView.transform = CGAffineTransform(rotationAngle: -angle).concatenating(CGAffineTransform(translationX: 200, y: 0))
        
        matchUserImageView.transform = CGAffineTransform(rotationAngle: angle).concatenating(CGAffineTransform(translationX: -200, y: 0))
        
        sendMessageButton.transform = CGAffineTransform(translationX: -500, y: 0)
        keepSwipingButton.transform = CGAffineTransform(translationX: 500, y: 0)
        
            
        
        UIView.animateKeyframes(withDuration: 1.3, delay: 0, options: .calculationModeCubic, animations:  {
            
                UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 0.6) {
                    // En appliquant uniquement la rotation comme transformastion, le translate
                    // s'annule et donc la view revient à sa position de départ
                    self.currentUserImageView.transform = CGAffineTransform(rotationAngle: -angle)
                    self.matchUserImageView.transform = CGAffineTransform(rotationAngle: -angle)
                }
            
            UIView.addKeyframe(withRelativeStartTime: 0.6, relativeDuration: 0.4) {
                self.currentUserImageView.transform = .identity
                self.matchUserImageView.transform = .identity
                }
            }, completion: nil)

        UIView.animate(withDuration: 1.3, delay: 0.6*1.3, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.1, options: .curveEaseOut, animations:  {
            self.sendMessageButton.transform = .identity
            self.keepSwipingButton.transform = .identity
        }, completion: nil)

    }
    
    func configureBlurView(){
        let tap = UITapGestureRecognizer(target: self, action: #selector(handledismiss))
        visualEffectView.addGestureRecognizer(tap)
        visualEffectView.translatesAutoresizingMaskIntoConstraints = false
        visualEffectView.alpha = 0
        addSubview(visualEffectView)
        NSLayoutConstraint.activate([
            visualEffectView.topAnchor.constraint(equalTo: topAnchor),
            visualEffectView.leadingAnchor.constraint(equalTo: leadingAnchor),
            visualEffectView.trailingAnchor.constraint(equalTo: trailingAnchor),
            visualEffectView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.visualEffectView.alpha = 1
        }, completion: nil)

    }
}
