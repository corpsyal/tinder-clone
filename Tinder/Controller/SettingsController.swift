//
//  SettingsController.swift
//  Tinder
//
//  Created by Anthony Lahlah on 05.09.21.
//

import UIKit
import JGProgressHUD
import FirebaseAuth

private let reuseIdentifier = "SettingsCell"

protocol SettingsControllerDelegate: AnyObject {
    func settingsController(_ controller: SettingsController, wantsToUpdate user: User)
    func handleLogout(settingsController: SettingsController)
}

class SettingsController: UITableViewController {
    
    private var user: User
    
    private lazy var headerView = SettingsHeader(user: user)
    private let footerView = SettingsFooter()
    private let imagePicker = UIImagePickerController()
    private var imageIndex: Int = 0
    
    weak var delegate: SettingsControllerDelegate?
    
    init(user: User){
        self.user = user
        super.init(style: .plain)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        headerView.delegate = self
        imagePicker.delegate = self
    }
    
    // MARK: - Handlers
    
    @objc func handleCancel(){
        dismiss(animated: true, completion: nil)
    }
    
    @objc func handleDone(){
        view.endEditing(true)
        let hud = JGProgressHUD(style: .dark)
        hud.textLabel.text = "Saving user data"
        hud.show(in: view)
        Service.saveUserData(user: user) { error in
            hud.dismiss(animated: true)
            self.delegate?.settingsController(self, wantsToUpdate: self.user)
        }
        
    }
    
    // MARK: - Helpers
    
    func configureUI(){
        navigationItem.title = "Settings"
        navigationController?.navigationBar.tintColor = .black
        navigationController?.navigationBar.prefersLargeTitles = true
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(handleCancel))
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(handleDone))
        
        tableView.separatorStyle = .none
        tableView.allowsSelection = false
        tableView.tableHeaderView = headerView
        
      
        tableView.backgroundColor = .systemGroupedBackground
        tableView.register(SettingsCell.self, forCellReuseIdentifier: reuseIdentifier)
        headerView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 300)
        
        tableView.tableFooterView = footerView
        footerView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 88)
        footerView.delegate = self
        //tableView.tableFooterView = headerView
        
    }
    
    func setButtonImage(_ image: UIImage){
        guard let button = headerView.buttons[imageIndex] as UIButton? else { return }
    
        button.setImage(image.withRenderingMode(.alwaysOriginal), for: .normal)
        button.setTitle(nil, for: .normal)
    }
    
    // MARK: - API

    func uploadImage(image: UIImage) {
        let hud = JGProgressHUD(style: .dark)
        hud.textLabel.text = "Saving image"
        hud.show(in: view)
        guard let userUID = Auth.auth().currentUser?.uid else { return }
        Service.uploadPhoto(photo: image, userUid: userUID) { imageUrl in
            print(imageUrl)
            if(self.user.imageURLs.indices.contains(self.imageIndex)){
                self.user.imageURLs[self.imageIndex] = imageUrl
            } else {
                self.user.imageURLs.append(imageUrl)
            }

            hud.dismiss(animated: true)
        }
    }
    
}

// MARK: - SettingsHeaderDelegate

extension SettingsController: SettingsHeaderDelegate {
    func settingsHeader(_ settingsHeader: SettingsHeader, didSelect index: Int) {
        imageIndex = index
        present(imagePicker, animated: true, completion: nil)
    }
}

// MARK: - UITableViewDataSource

extension SettingsController {
    override func numberOfSections(in tableView: UITableView) -> Int {
        return SettingsSections.allCases.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! SettingsCell
        guard let section = SettingsSections(rawValue: indexPath.section) else { return cell }
        cell.viewModel = SettingsViewModel(user: self.user, section: section)
        cell.delegate = self
        return cell
    }
    
}


// MARK: - UITableViewDelegate

extension SettingsController {
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 32
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        guard let section = SettingsSections(rawValue: section) else { return nil }
        return section.description
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let section = SettingsSections(rawValue: indexPath.section) else { return 0 }
        return section == SettingsSections.ageRange ? 96 : 44
    }
    
}

// MARK: - UIImagePickerControllerDelegate

extension SettingsController: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
         
        guard let image = info[.originalImage] as? UIImage else { return }
        
        uploadImage(image: image)
        
        setButtonImage(image)
        
        // update photo
        
        dismiss(animated: true, completion: nil)
    }
    
}

extension SettingsController: SettingCellDelegate {
    
    func settingsCell(_ cell: SettingsCell, wantsToUpdateUserWith value: String, for section: SettingsSections) {
        
        switch section {
            case .name:
                user.name = value
            case .profession:
                user.profession = value
            case .age:
                user.age = Int(value) ?? user.age
            case .bio:
                user.bio = value
            case .ageRange:
                break
        }
    }
    
    func settingsCell(_ cell: SettingsCell, wantsToUpdateAgeWith sender: UISlider) {
        if sender === cell.minSlider {
            user.minSeekAge = Int(sender.value)
        }
        
        if sender === cell.maxSlider {
            user.maxSeekAge = Int(sender.value)
        }
            
    }
    
}

extension SettingsController: SettingsFooterDelegate {
    func handleLogout() {
        delegate?.handleLogout(settingsController: self)
    }
}
