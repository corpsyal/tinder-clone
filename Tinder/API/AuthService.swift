//
//  AuthService.swift
//  Tinder
//
//  Created by Anthony Lahlah on 17.08.21.
//

import UIKit
import FirebaseAuth
import FirebaseStorage
import FirebaseFirestore

struct AuthCredentials {
    let email: String
    let fullName: String
    let password: String
}

struct AuthService {
    
    static func loginUser(email: String, password: String, completion: @escaping (AuthDataResult?, Error?) -> Void){
        Auth.auth().signIn(withEmail: email, password: password, completion: completion)
    }
    
    static func registerUser(_ credentials: AuthCredentials, onComplete: @escaping (String) -> Void) {
        Auth.auth().createUser(withEmail: credentials.email, password: credentials.password) { authResult, error in
            if let error = error {
                print("DEBUG: \(error)")
                return
            } else if let authResult = authResult {
                let userUid = authResult.user.uid
                let data: [String: Any] = [
                    "uid": userUid,
                    "fullName": credentials.fullName,
                    "email": credentials.email,
                    "age": 28
                ]
                Firestore.firestore().collection("users").document(userUid).setData(data)
                onComplete(userUid)
            }
        }
    }
    
    
}
