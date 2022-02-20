//
//  ProfileController.swift
//  Tinder
//
//  Created by Anthony Lahlah on 10.10.21.
//


import UIKit

private let reuseIdentifier = "ProfileCell"

class ProfileController: UIViewController {
    
    private let user: User
    
    private lazy var viewModel = ProfileViewModel(user: user)
    
    private let blurView: UIVisualEffectView = {
        let blur  = UIBlurEffect(style: .regular)
        let view = UIVisualEffectView(effect: blur)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var barStackView = SegmentedBarView(number: viewModel.imageCount)
    
    private lazy var collectionView: UICollectionView =  {
        let frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.width + 100)
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        
        let cv = UICollectionView(frame: frame, collectionViewLayout: layout)
        cv.backgroundColor = .black
        cv.isPagingEnabled = true
        cv.delegate = self
        cv.dataSource = self
        cv.showsHorizontalScrollIndicator = true
        print(frame.height)
        //cv.horizontalScrollIndicatorInsets = UIEdgeInsets(top: 0, left: 0, bottom: frame.height - 70, right: 0)
        cv.register(ProfileCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        return cv
    }()
    
    private let dissmissButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.translatesAutoresizingMaskIntoConstraints = false
        let image: UIImage = #imageLiteral(resourceName: "dismiss_down_arrow")
        btn.setImage(image.withRenderingMode(.alwaysOriginal), for: .normal)
        btn.addTarget(self, action: #selector(handleDismiss), for: .touchUpInside)
        return btn
    }()
    
    private let infoLabel : UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        return label
    }()
    
    private let professionLabel : UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 20)
        return label
    }()
    
    private let bioLabel : UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 20)
        return label
    }()
    
    private lazy var disLikeButton: UIButton = {
        let button = createButton(withImage: #imageLiteral(resourceName: "dismiss_circle").withRenderingMode(.alwaysOriginal))
        return button
    }()

    private lazy var superLikeButton: UIButton = {
        let button = createButton(withImage: #imageLiteral(resourceName: "super_like_circle").withRenderingMode(.alwaysOriginal))
        return button
    }()

    private lazy var likeButton: UIButton = {
        let button = createButton(withImage: #imageLiteral(resourceName: "like_circle").withRenderingMode(.alwaysOriginal))
        return button
    }()
   
    
    init(user: User){
        self.user = user
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        view.backgroundColor = .white
        view.addSubview(collectionView)
        
        view.addSubview(dissmissButton)
        NSLayoutConstraint.activate([
            dissmissButton.widthAnchor.constraint(equalToConstant: 40),
            dissmissButton.heightAnchor.constraint(equalToConstant: 40),
            dissmissButton.topAnchor.constraint(equalTo: collectionView.bottomAnchor, constant: -20),
            dissmissButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        ])
        
        let infosStack = UIStackView(arrangedSubviews: [infoLabel, professionLabel, bioLabel])
        infosStack.axis = .vertical
        infosStack.spacing = 4
        infosStack.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(infosStack)
        
        NSLayoutConstraint.activate([
            infosStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 12),
            infosStack.topAnchor.constraint(equalTo: collectionView.bottomAnchor, constant: 12)
        ])
        
        view.addSubview(blurView)
        NSLayoutConstraint.activate([
            blurView.topAnchor.constraint(equalTo: view.topAnchor),
            blurView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            blurView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            blurView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor)
        ])
        
        barStackView.configure(view: view)
        
        configureBottomControls()
        loadUserData()
        
    }
    
    @objc func handleDismiss(){
        dismiss(animated: true, completion: nil)
    }
    
    func configureBottomControls (){
        let stackView = UIStackView(arrangedSubviews: [disLikeButton, superLikeButton, likeButton])
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -32),
        ])
    }
    
    func loadUserData(){
        infoLabel.attributedText = viewModel.userDetailsAttributedString
        professionLabel.text = viewModel.profession
        bioLabel.text = viewModel.bio
    }
    
    func createButton(withImage: UIImage) -> UIButton {
        let button = UIButton(type: .system)
        button.setImage(withImage, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }
}


extension ProfileController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.imageCount
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! ProfileCell
        cell.imageView.sd_setImage(with: viewModel.images[indexPath.row])
        //cell.contentView.frame = cell.bounds
        return cell
    }
    
    
}

extension ProfileController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        barStackView.highlight(index: indexPath.row)
    }
}

extension ProfileController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return .init(width: view.frame.width, height: view.frame.width+100)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}
