//
//  LoginController.swift
//  Tinder
//
//  Created by Anthony Lahlah on 02.08.21.
//

import UIKit
import JGProgressHUD

class LoginController: UIViewController {
    
    private let iconImageView: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.image = #imageLiteral(resourceName: "app_icon").withRenderingMode(.alwaysTemplate)
        iv.tintColor = .white
        return iv
    }()
    
    private let emailTextField = CustomTextField(placeholder: "Email")
    
    private let passwordTextField = CustomTextField(placeholder: "Password", isSecureTextEntry: true)
    
    private let loginButton: AuthButton = {
        let button = AuthButton(type: .system)
        button.setTitle("Login", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .bold)
        button.isEnabled = false
        button.addTarget(self, action: #selector(handleLogin), for: .touchUpInside)
        return button
    }()
    
    private var viewModel = LoginViewModel()
    
    private let goToRegistrationButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        let attributedString = NSMutableAttributedString(string: "Don't have an account ? ", attributes: [
            .foregroundColor: UIColor.white,
            .font: UIFont.systemFont(ofSize: 16)
        ])
        
        attributedString.append(NSMutableAttributedString(string: "Sign up", attributes: [
            .foregroundColor: UIColor.white,
            .font: UIFont.boldSystemFont(ofSize: 16)
        ]))
        
        button.setAttributedTitle(attributedString, for: .normal)
        
        button.addTarget(self, action: #selector(handleShowRegistration), for: .touchUpInside)
        
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hideKeyboardWhenTappedAround()
        enableFormObserver()
        configureUI()
        checkFormStatus()
    }
    
    func enableFormObserver(){
        emailTextField.addTarget(self, action: #selector(onEmailChange), for: .editingChanged)
        passwordTextField.addTarget(self, action: #selector(onPasswordChange), for: .editingChanged)
    }
    
    @objc func handleLogin(){
        guard let email = viewModel.email else { return }
        guard let password = viewModel.password else { return }
        
        let hud = JGProgressHUD(style: .dark)
        hud.show(in: view)
        
        AuthService.loginUser(email: email, password: password) { (authResult, error) in
            if let error = error {
                print("DEBUG: error during login \(error)")
                hud.dismiss(animated: true)
                return
            }
            
            hud.dismiss(animated: true)
            print("User logged in !")
            
            guard let window = self.view.window else { return }
            let home = HomeController()
            home.modalPresentationStyle = .fullScreen

            window.rootViewController = HomeController()
            
            UIView.transition(with: window, duration: 0.2, options: [.transitionCrossDissolve], animations: nil, completion: nil)
            
        }
    }
    
    @objc func handleShowRegistration(){
        navigationController?.pushViewController(RegistrationController(), animated: true)
    }
    
    func configureUI(){
        emailTextField.keyboardType = .emailAddress
        navigationController?.navigationBar.isHidden = true
        navigationController?.navigationBar.barStyle = .black
        configureGradientLayer()
        
        view.addSubview(iconImageView)
        iconImageView.widthAnchor.constraint(equalToConstant: 100).isActive = true
        iconImageView.heightAnchor.constraint(equalToConstant: 100).isActive = true
        iconImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 32).isActive = true
        iconImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        let stackView = UIStackView(arrangedSubviews: [emailTextField, passwordTextField, loginButton])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 16
        
        view.addSubview(stackView)
        stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32).isActive = true
        stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -32).isActive = true
        stackView.topAnchor.constraint(equalTo: iconImageView.bottomAnchor, constant: 24).isActive = true
        
        view.addSubview(goToRegistrationButton)
        goToRegistrationButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        goToRegistrationButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
    }
    
    @objc func onEmailChange(sender: UITextField){
        viewModel.email = sender.text
        print(viewModel.formIsValid)
        checkFormStatus()
    }
    
    @objc func onPasswordChange(sender: UITextField){
        viewModel.password = sender.text
        print(viewModel.formIsValid)
        checkFormStatus()
    }
    
    func checkFormStatus(){
        if viewModel.formIsValid {
            loginButton.isEnabled = true
            loginButton.backgroundColor = AuthButton.enableBackgroundColor
        } else {
            loginButton.isEnabled = false
            loginButton.backgroundColor = AuthButton.disableBackgroundColor
        }
    }
    
    
}

extension LoginController: UITextFieldDelegate {
    func textFieldDidChangeSelection(_ textField: UITextField) {
        print(textField == emailTextField)
    }
}

