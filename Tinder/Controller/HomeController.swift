//
//  HomeController.swift
//  Tinder
//
//  Created by Anthony Lahlah on 13.07.21.
//

import UIKit
import Firebase

class HomeController: UIViewController {
    
    private var settingsController: SettingsController?
    private var messagesController: MessagesController?
    
    private var user: User? {
        didSet {
            if let user = self.user {
                settingsController = SettingsController(user: user)
                messagesController = MessagesController(user: user)
            }
        }
    }
    private let topStack = HomeNavigationStackView()
    private let bottomStack = BottomControlsStackView()
    private let deckView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 5
        view.backgroundColor = .white
        return view
        
    }()
    
    private var viewModels: [CardViewModel] = [] {
        didSet {  configureCards() }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        configureCards()
        fetchUser { user in
            self.fetchUsers(forUser: user)
        }
        
        topStack.navigationDelegate = self
        bottomStack.delegate = self
        
    }
    
    func fetchUser(onComplete: ((User) -> Void)? = nil){
        guard let userUid = Auth.auth().currentUser?.uid else { return }
        Service.fetchUser(withUid: userUid) { (user) in
            self.user = user
            guard let onComplete = onComplete else { return }
            onComplete(user)
        }
    }
    
    func fetchUsers(forUser user: User){
        Service.fetchUsers(forUser: user) { (users) in
            self.viewModels = users.map({CardViewModel(user: $0)})
        }
    }
    
    func saveSwipeAndCheck(forUser user: User, like: Bool){
        guard let currentUser = self.user else { return }
        if !like { return }
        Service.saveSwipe(forUser: user, liked: like) { error in
            print("Like save !")
            Service.checkLikeForUser(user) { match in
                if match {
                    Service.saveMatch(forUser: currentUser, withUser: user) {
                        Service.saveMatch(forUser: user, withUser: currentUser) {
                            self.presentMatchView(matchedUser: user)
                            self.fetchUser()
                        }
                    }
                }
            }
        }
    }
    
    
    func configureCards() {
        
        self.viewModels.forEach { (cardViewModel) in
            let cardView = CardView(viewModel: cardViewModel)
            cardView.delegate = self
            deckView.addSubview(cardView)
            cardView.fillSuperview()
        }
    }
    
    
    func configureUI() {
        view.backgroundColor = .white
    
        let stack = UIStackView(arrangedSubviews: [topStack, deckView, bottomStack])
        stack.axis = .vertical
        
        view.addSubview(stack)
        
        
        stack.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.rightAnchor)
        stack.isLayoutMarginsRelativeArrangement = true
        stack.layoutMargins = .init(top: 0, left: 12, bottom: 0, right: 12)
    }
    
    func checkIfUserIsLoggedIn() -> Bool{
        return Auth.auth().currentUser != nil
    }
    
    func logout(){
        do {
            try Auth.auth().signOut()
        } catch {
            print("Debug: error during signout \(error)")
        }
    }
    
    func presentLoginController(){
            let controller = LoginController()
            let nav = UINavigationController(rootViewController: controller)
            nav.modalPresentationStyle = .fullScreen
            self.present(nav, animated: true, completion: nil)
    }
    
    func getTopCardView() -> CardView? {
        return deckView.subviews.last as? CardView
    }
    
    func performSwipeAnimation(shouldLike: Bool){
        let translation: CGFloat = shouldLike ? 700 : -700
        
        if let topCardView = getTopCardView() {
            UIView.animate(withDuration: 1.0, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.1, options: .curveEaseOut) {
                topCardView.frame = CGRect(x: translation,
                                           y: 0,
                                            width: topCardView.frame.width,
                                            height: topCardView.frame.height)

            } completion: { _ in
                let processedUser = topCardView.viewModel.user
                topCardView.removeFromSuperview()
                self.saveSwipeAndCheck(forUser: processedUser, like: shouldLike)
                
            }
        } else {
            print("no view")
        }
        
    }
    
    func presentMatchView(matchedUser: User){
        guard let currentUser = self.user else { return }
        let matchViewModel = MatchViewViewModel(currentUser: currentUser, matchedUser: matchedUser)
        let matchView = MatchView(viewModel: matchViewModel)
        matchView.delegate = self
        matchView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(matchView)

        NSLayoutConstraint.activate([
            matchView.topAnchor.constraint(equalTo: view.topAnchor),
            matchView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            matchView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            matchView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}

extension HomeController: HomeNavigationStackViewDelegate {
    
    func showMessages() {
        guard let messageController = messagesController else { return }
        let nav = UINavigationController(rootViewController: messageController)
        nav.modalPresentationStyle = .fullScreen
        present(nav, animated: true, completion: nil)
    }
    
    func showSettings() {
        guard let settingsController = settingsController else { return }
        settingsController.delegate = self
        let nav = UINavigationController(rootViewController: settingsController)
        nav.modalPresentationStyle = .fullScreen
        present(nav, animated: true, completion: nil)
        
    }
    
}

extension HomeController: SettingsControllerDelegate {
    func handleLogout(settingsController: SettingsController) {
        try! Auth.auth().signOut()
        
        guard let window = settingsController.view.window else { return }
        
        window.rootViewController = UINavigationController(rootViewController: LoginController())
        UIView.transition(with: window, duration: 0.2, options: [.transitionCrossDissolve], animations: nil, completion: nil)
    }
    
    func settingsController(_ controller: SettingsController, wantsToUpdate user: User) {
        self.user = user
        controller.dismiss(animated: true, completion: nil)
    }
    
}

extension HomeController: CardViewDelegate {
    func saveLikeAfterAnim(user: User, like: Bool) {
        saveSwipeAndCheck(forUser: user, like: like)
    }
    
    func showProfile(_ cardView: CardView, wantsToShowProfileFor: User) {
        let vc = ProfileController(user: wantsToShowProfileFor)
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true, completion: nil)
    }
    
}

extension HomeController: BottomControlsStackViewDelegate {
    func handleDislike() {
        performSwipeAnimation(shouldLike: false)
    }
    
    func handleSuperLike() {
        print("Super Like !")
    }
    
    func handleLike() {
        performSwipeAnimation(shouldLike: true)
    }
    
    
}

extension HomeController: MatchViewDelegate {
    func sendMessageTo(_ user: User) {
        print("SEND MESSAGE TO \(user.name)")
    }
}
