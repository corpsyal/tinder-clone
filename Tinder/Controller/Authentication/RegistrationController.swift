//
//  LoginController.swift
//  Tinder
//
//  Created by Anthony Lahlah on 02.08.21.
//

import UIKit
import JGProgressHUD

class RegistrationController: UIViewController {
    
    private let selectPhotoButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "plus_photo"), for: .normal)
        button.tintColor = .white
        button.clipsToBounds = true
        button.addTarget(self, action: #selector(handleSelectPhoto), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private var viewModel = RegistrationViewModel()
    
    private let emailTextField = CustomTextField(placeholder: "Email")
    
    private let fullNameTextField = CustomTextField(placeholder: "Full name")
    
    private let passwordTextField = CustomTextField(placeholder: "Password", isSecureTextEntry: true)
    
    private let registerButton: AuthButton = {
        let button = AuthButton(type: .system)
        button.setTitle("Register", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .bold)
        button.isEnabled = false
        button.addTarget(self, action: #selector(handleRegister), for: .touchUpInside)
        return button
    }()
    
    private let goToLoginButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        let attributedString = NSMutableAttributedString(string: "Already have an account ? ", attributes: [
            .foregroundColor: UIColor.white,
            .font: UIFont.systemFont(ofSize: 16)
        ])
        
        attributedString.append(NSMutableAttributedString(string: "Sign in", attributes: [
            .foregroundColor: UIColor.white,
            .font: UIFont.boldSystemFont(ofSize: 16)
        ]))
        
        button.setAttributedTitle(attributedString, for: .normal)
        
        button.addTarget(self, action: #selector(handleGoToLogin), for: .touchUpInside)
        
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hideKeyboardWhenTappedAround()
        checkFormStatus()
        emailTextField.addTarget(self, action: #selector(onEmailChange), for: .editingChanged)
        fullNameTextField.addTarget(self, action: #selector(onFullNameChange), for: .editingChanged)
        passwordTextField.addTarget(self, action: #selector(onPasswordChange), for: .editingChanged)
        configureUI()
    }
    
    @objc func handleSelectPhoto(){
        let picker = UIImagePickerController()
        picker.delegate = self
        present(picker, animated: true, completion: nil)
    }
    
    @objc func handleRegister(){
        guard let email = viewModel.email else { return }
        guard let fullName = viewModel.fullName else { return }
        guard let password = viewModel.password else { return }
        guard let selectedPhoto = viewModel.selectedPhoto else { return }
        
        let hud = JGProgressHUD(style: .dark)
        hud.show(in: view)
        
        let credentials = AuthCredentials(email: email, fullName: fullName, password: password)
        
        AuthService.registerUser(credentials) { (userUid) in
            Service.uploadPhoto(photo: selectedPhoto, userUid: userUid) { (url) in
                hud.dismiss(animated: true)
            }
        }
        
    }
    
    @objc func handleGoToLogin(){
        navigationController?.popViewController(animated: true)
    }
    
    @objc func onEmailChange(sender: UITextField){
        viewModel.email = sender.text
        checkFormStatus()
    }
    
    @objc func onFullNameChange(sender: UITextField){
        viewModel.fullName = sender.text
        checkFormStatus()
    }
    
    @objc func onPasswordChange(sender: UITextField){
        viewModel.password = sender.text
        checkFormStatus()
    }
    
    func checkFormStatus(){
        if viewModel.formIsValid {
            registerButton.isEnabled = true
            registerButton.backgroundColor = AuthButton.enableBackgroundColor
        } else {
            registerButton.isEnabled = false
            registerButton.backgroundColor = AuthButton.disableBackgroundColor
        }
    }
    
    func configureUI(){
        navigationController?.navigationBar.isHidden = true
        navigationController?.navigationBar.barStyle = .black
        
        configureGradientLayer()
        
        view.addSubview(selectPhotoButton)
        let stackView = UIStackView(arrangedSubviews: [emailTextField, fullNameTextField, passwordTextField, registerButton])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 16
        
        view.addSubview(stackView)
        view.addSubview(goToLoginButton)
        
        NSLayoutConstraint.activate([
            selectPhotoButton.heightAnchor.constraint(equalToConstant: 275),
            selectPhotoButton.widthAnchor.constraint(equalToConstant: 275),
            selectPhotoButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            selectPhotoButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8),
            
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -32),
            stackView.topAnchor.constraint(equalTo: selectPhotoButton.bottomAnchor, constant: 8),
            
            goToLoginButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            goToLoginButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)

        ])
    }
    
    
}

extension RegistrationController: UIImagePickerControllerDelegate ,UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image = info[.originalImage] as? UIImage
        viewModel.selectedPhoto = image
        
        selectPhotoButton.setImage(image?.withRenderingMode(.alwaysOriginal), for: .normal)

        selectPhotoButton.layer.borderColor = UIColor(white: 1, alpha: 1).cgColor
        selectPhotoButton.layer.borderWidth = 2
        selectPhotoButton.layer.cornerRadius = 10
        
        checkFormStatus()
        
        dismiss(animated: true, completion: nil)
    }
}
