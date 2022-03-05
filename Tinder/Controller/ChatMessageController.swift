//
//  ChatMessageController.swift
//  Tinder
//
//  Created by Anthony Lahlah on 24.02.22.
//

import UIKit
import MessageKit
import InputBarAccessoryView
import FirebaseAuth
import FirebaseFirestore

class ChatMessageController: MessagesViewController {
    
    private let user: User
    private let match: Match
    private var messages: [MessageType] = []
    private var chat: Chat?
    
    init(user: User, match: Match){
        self.user = user
        self.match = match
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTitle()
        messagesCollectionView.messagesDataSource = self
        messagesCollectionView.messagesLayoutDelegate = self
        messagesCollectionView.messagesDisplayDelegate = self
        messageInputBar.delegate = self
        
        if let layout = messagesCollectionView.collectionViewLayout as? MessagesCollectionViewFlowLayout {
          //layout.setMessageIncomingAvatarSize(.zero)
          layout.setMessageOutgoingAvatarSize(.zero)
        }
        
        initMessages()
        
        Service.waitForNewMessage(uid: match.uid) { chat in
            self.messages = self.mapMessages(messages: chat.messages)
            self.messagesCollectionView.reloadData()
        }
        
    }
    
    
    func configureTitle(){
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = (navigationController?.navigationBar.frame.size.height)!/2
        imageView.clipsToBounds = true

        NSLayoutConstraint.activate([
            imageView.widthAnchor.constraint(equalToConstant: (navigationController?.navigationBar.frame.size.height)!),
            imageView.heightAnchor.constraint(equalToConstant: (navigationController?.navigationBar.frame.size.height)!)
        ])
        imageView.sd_setImage(with: URL(string: match.profileURL), completed: nil)
        
        let label = UILabel()
        label.text = match.name
        
        let paddingView = UIView()
        paddingView.widthAnchor.constraint(equalToConstant: 10).isActive = true

        let stackView = UIStackView(arrangedSubviews: [
            imageView,
            paddingView,
            label])
        
        navigationItem.titleView = stackView
    }
    
    func initMessages(){
        Service.fetchChatForUserUid(match.uid) { chat in
            self.messages = self.mapMessages(messages: chat.messages)
            self.messagesCollectionView.reloadData()
            
        }
    }
    
    func mapMessages(messages: [Message]) -> [MessageType]{
        return messages.map({
            ChatMessage(
                sender: Sender(senderId: $0.from, displayName: self.getDisplayName(message: $0)),
                messageId: $0.id,
                sentDate: $0.time.dateValue(),
                kind: .text($0.content)
            )
            
        })

    }
    
    func sendMessage(_ content: String){
        let messageID = UUID().uuidString
        let message = Message(
            id: messageID,
            content: content,
            from: user.uid,
            read: false,
            time: Timestamp(date: Date())
        )
        
        Service.saveMessage(uid: match.uid, message: message) {
            self.initMessages()
        }
    }
    
    func getDisplayName(message: Message) -> String {
        return message.from == user.uid ? user.name : match.name
    }
    
    func getAvatarUrl(){
        
    }
}

struct Sender: SenderType {
    var senderId: String
    var displayName: String
}

struct ChatMessage: MessageType {
    var sender: SenderType
    var messageId: String
    var sentDate: Date
    var kind: MessageKind
}

extension ChatMessageController: MessagesDataSource {

    func currentSender() -> SenderType {
        return Sender(senderId: user.uid , displayName: user.name)
    }

    func numberOfSections(in messagesCollectionView: MessagesCollectionView) -> Int {
        return messages.count
    }

    func messageForItem(at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageType {
        return messages[indexPath.section]
    }
}

extension ChatMessageController: MessagesDisplayDelegate {
    func configureAvatarView(_ avatarView: AvatarView, for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) {
    
        if (message.sender.senderId == user.uid){
            avatarView.isHidden = true
        } else {
            avatarView.isHidden = false // because of cells are reused
            avatarView.sd_setImage(with: URL(string: match.profileURL), completed: nil)
        }
      
    }
}

extension ChatMessageController: MessagesLayoutDelegate {}

extension ChatMessageController: InputBarAccessoryViewDelegate {
    func inputBar(_ inputBar: InputBarAccessoryView, didPressSendButtonWith text: String) {
        sendMessage(text)
        inputBar.inputTextView.text = ""
    }
    
}
