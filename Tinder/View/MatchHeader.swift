//
//  MatchHeader.swift
//  Tinder
//
//  Created by Anthony Lahlah on 15.02.22.
//

import UIKit

let resuseIdentifierCell = "matchCell"

protocol MatchHeaderDelegate: AnyObject {
    func startChatWith(_ match: Match)
}

class MatchHeader: UIView {
    private let user: User
    weak var delegate: MatchHeaderDelegate?
    
    private let newMatchesLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "New matches"
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.textColor = #colorLiteral(red: 0.9826375842, green: 0.3476698399, blue: 0.447683692, alpha: 1)
        return label
    }()
    
    private lazy var collectionView: UICollectionView = {
       let layout = UICollectionViewFlowLayout()
        layout.headerReferenceSize = CGSize(width: 16, height: 0)
        layout.footerReferenceSize = CGSize(width: 16, height: 0)
        layout.scrollDirection = .horizontal
        //layout.minimumLineSpacing = 0
        
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.showsHorizontalScrollIndicator = false
        cv.delegate = self
        cv.dataSource = self
        cv.register(MatchCell.self, forCellWithReuseIdentifier: resuseIdentifierCell)
        cv.translatesAutoresizingMaskIntoConstraints = false
        //cv.backgroundColor = .systemPink
        return cv
    }()
    
    init(user: User) {
        self.user = user
        //let screen = UIScreen.main.bounds.width
        //super.init(frame: .zero)
        super.init(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 200))
//        print(UIScreen.main.bounds)
//        print(frame.width)
        //backgroundColor = .systemBlue
        
        addSubview(newMatchesLabel)
        NSLayoutConstraint.activate([
            newMatchesLabel.topAnchor.constraint(equalTo: topAnchor, constant: 12),
            newMatchesLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12)
        ])
        
        addSubview(collectionView)
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: newMatchesLabel.bottomAnchor, constant: 12),
            collectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -24),
            collectionView.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension MatchHeader: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return user.matches.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: resuseIdentifierCell, for: indexPath) as! MatchCell
        cell.match = user.matches[indexPath.row]
        //cell.backgroundColor = .yellow
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! MatchCell
        guard let chatWith = cell.match else { return }
        delegate?.startChatWith(chatWith)
        
    }
    
}

extension MatchHeader: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 80, height: 104)
    }
}
