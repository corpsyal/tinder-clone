//
//  Service.swift
//  Tinder
//
//  Created by Anthony Lahlah on 17.08.21.
//

import UIKit
import FirebaseAuth
import FirebaseStorage
import FirebaseFirestore


struct Service {
    
    static func fetchUser(withUid uid: String, onCompltete: @escaping (User)-> Void){
        COLLECTION_USERS.document(uid).getDocument { (snapshot, error) in
            if let error = error {
                print("DEBUG: \(error)")
                return
            }
            
            guard let dictionnary = snapshot?.data() else { return }
        
            let user = User(dictionnary: dictionnary)
            
            onCompltete(user)
        }
    }
    
    static func fetchUsers(forUser: User, onComplete: @escaping ([User]) -> Void){
        var users: [User] = []
        let query = COLLECTION_USERS
            //.whereField("uid", isNotEqualTo: forUser.uid)
            .whereField("age", isGreaterThan: forUser.minSeekAge)
            .whereField("age", isLessThanOrEqualTo: forUser.maxSeekAge)
        
        fetchSwipes { userIDs in
            query.getDocuments { (snapshot, error) in
                if let error = error {
                    print("DEBUG: \(error)")
                    return
                }
                
                snapshot?.documents.forEach({ (document) in
                    let dictionnary = document.data()
                    let user = User(dictionnary: dictionnary)
                    guard user.uid != Auth.auth().currentUser?.uid else { return }
                    //guard userIDs[user.uid] == nil else { return }
                    users.append(user)
                })
                
                onComplete(users)
            }
        }
    }
    
    private static func fetchSwipes(completion: @escaping ([String: Int]) -> Void){
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        COLLECTION_SWIPES.document(uid).getDocument { snapshot, error in
            let swipes = snapshot?.data() as? [String: Int] ?? [String: Int]()
            completion(swipes)
        }
    }
    
    static func saveUserData(user: User, completion: @escaping (Error?) -> Void){
        let data: [String: Any] = [
            "fullName": user.name,
            "age": user.age,
            "email": user.email,
            "profession": user.profession,
            "bio": user.bio,
            "imageURLs": user.imageURLs,
            "minSeekAge": user.minSeekAge,
            "maxSeekAge": user.maxSeekAge,
        ]
        
        COLLECTION_USERS.document(user.uid).setData(data, merge: true, completion: completion)
    }
    
    static func uploadPhoto(photo: UIImage, userUid: String, onCompltete: @escaping (String) -> Void){
        guard let jpegData = photo.jpegData(compressionQuality: 0.75) else { return }
        let fileName = NSUUID().uuidString
        
        let storage = Storage.storage()
        let ref = storage.reference(withPath: "/images/\(fileName)")
        
        ref.putData(jpegData, metadata: nil) { (storageData, error) in
            if let error = error {
                print("DEBUG: \(error)")
                return
            }
            
            ref.downloadURL(completion: { (url, error) in
                if let error = error {
                    print("DEBUG: \(error)")
                    return
                }
                
                if let url = url?.absoluteString {
                    //COLLECTION_USERS.document(userUid).setData(["imageURLs" : [url]], merge: true)
                    onCompltete(url)
                }

            })

        }
    }
    
    static func saveSwipe(forUser user: User, liked: Bool, completion: @escaping ((Error?) -> Void)){
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let isLiked = liked ? 1 : 0
        let data: [String: Int] = [
            user.uid: isLiked
        ]
        
        COLLECTION_SWIPES.document(uid).setData(data, merge: true, completion: completion)
    }
    
    static func checkLikeForUser(_ user: User, completion: @escaping (Bool) -> Void){
        guard let currentUid = Auth.auth().currentUser?.uid else { return }
        let uidLiked = user.uid
        print(currentUid, uidLiked)
        
        COLLECTION_SWIPES.document(uidLiked).getDocument { snapshot, error in
            let likesCollection = snapshot?.data() ?? [String: Int]()
            let isMatch = likesCollection[currentUid] as? Int ?? 0
            completion(isMatch == 1)
        }
        
    }
    
    static func saveMatch(forUser: User, withUser: User, completion: @escaping () -> Void){
       // guard let currentUid = Auth.auth().currentUser?.uid else { return }
        let match = [
            "uid": withUser.uid,
            "profileURL": withUser.imageURLs.first!,
            "name": withUser.name
        ]
        
        COLLECTION_USERS.document(forUser.uid).updateData(["matches": FieldValue.arrayUnion([match])]) { _ in
            completion()
        }
    }
    
    static func fetchChatForUserUid(_ uid: String, complete: @escaping (Chat)->Void){
        guard let currentUid = Auth.auth().currentUser?.uid else { return }
        
        let query = COLLECTION_MESSAGES.whereField("users", in: [[uid, currentUid], [currentUid, uid]])
        
        query.getDocuments { querySnapshots, error in
            if error != nil {
                print(error!)
            }
            
            guard let document = querySnapshots!.documents.first else { return }
            
            let chat = Chat(dictionnary: document.data())
            
            complete(chat)
        }
    }
    
}
