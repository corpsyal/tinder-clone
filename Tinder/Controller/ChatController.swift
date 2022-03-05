//
//  ChatController.swift
//  Tinder
//
//  Created by Anthony Lahlah on 20.02.22.
//

import UIKit

let reuseMatchCellIdentifier = "ChatCell"

class ChatController: UIViewController {
    
    private let match: Match
    private var chat: Chat? {
        didSet {
            configUI()
        }
    }
    
    private var testView: UIView = {
       let v = UIView()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.backgroundColor = .red
        return v
    }()
    
    private lazy var testViewBottomConstraint = testView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
    
    
    init(match: Match) {
        self.match = match
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        navigationItem.title = match.name
        view.backgroundColor = .white
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        view.addGestureRecognizer(tap)
        
        initMessages()
    }
    
    @objc func hideKeyboard(){
        view.endEditing(true)
    }
    
    @objc func keyboardWillShow(notification: NSNotification){
        guard let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else {  return }
        
        if(testViewBottomConstraint.constant == 0){
            self.testView.frame.origin.y = keyboardSize.height + self.testView.frame.height
            self.testViewBottomConstraint.constant = -keyboardSize.height + self.view.safeAreaInsets.bottom
        }

            
    }
    
    @objc func keyboardWillHide(notification: NSNotification){
        testView.frame.origin.y = view.frame.height - testView.frame.height
        testViewBottomConstraint.constant = 0
    }
    
    func initMessages(){
        Service.fetchChatForUserUid(match.uid) { chat  in
            print(chat)
            self.chat = chat
        }
    }
    
    func configUI(){
        guard let messages = chat?.messages else { return }
        let chatView = ChatView(match: match, messages: messages)
        view.addSubview(chatView)
        NSLayoutConstraint.activate([
            chatView.topAnchor.constraint(equalTo: view.topAnchor),
            chatView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            chatView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            chatView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        
        view.addSubview(testView)
        NSLayoutConstraint.activate([
            testViewBottomConstraint,
            testView.heightAnchor.constraint(equalToConstant: 100),
            testView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            testView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        
        let textF = CustomTextField(placeholder: "Test")
        testView.addSubview(textF)
        
        NSLayoutConstraint.activate([
            textF.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32),
            textF.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -32)
        ])
    }
}

