//
//  AuthentificationViewModel.swift
//  Tinder
//
//  Created by Anthony Lahlah on 15.08.21.
//

import UIKit

protocol AuthentificationViewModel {
    var formIsValid: Bool { get }
}

struct LoginViewModel: AuthentificationViewModel {
    var email: String?
    var password: String?
    
    var formIsValid: Bool {
        return email?.isEmpty == false && password?.isEmpty == false
    }
}

struct RegistrationViewModel: AuthentificationViewModel {
    var email: String?
    var fullName: String?
    var password: String?
    var selectedPhoto: UIImage?
    
    var formIsValid: Bool {
        return email?.isEmpty == false
            && password?.isEmpty == false
            && fullName?.isEmpty == false
            && selectedPhoto != nil
    }
}
