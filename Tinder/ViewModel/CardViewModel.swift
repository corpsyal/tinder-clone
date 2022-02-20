//
//  CardViewModel.swift
//  Tinder
//
//  Created by Anthony Lahlah on 30.07.21.
//

import UIKit
import SDWebImage


class CardViewModel {
    let user: User
    let userInfoLabel: NSMutableAttributedString
    private var imageIndex: Int = 0
    var index: Int { return imageIndex }
    let imageUrls: [String]
    var imageUrl: URL?
    
    //var imageToShow: UIImage?
    
    init(user: User) {
        self.user = user
        //self.imageToShow = user.images.first
        
        let attributedText = NSMutableAttributedString(string: user.name, attributes: [
            .font: UIFont.systemFont(ofSize: 32, weight: .heavy),
            .foregroundColor: UIColor.white
        ])
        
        attributedText.append(NSAttributedString(string: "  \(user.age)", attributes: [
            .font: UIFont.systemFont(ofSize: 24),
            .foregroundColor: UIColor.white
        ]))
        
        self.userInfoLabel = attributedText
//        if let url = user.imageURLs.first {
//            self.imageUrl = URL(string: url)
//        }
        self.imageUrls = user.imageURLs
        self.imageUrl = URL(string: self.imageUrls.first ?? "")
        
        // Prefetch all image
        let urls: [URL] = self.imageUrls.map({ URL(string: $0)!})
        SDWebImagePrefetcher.shared.prefetchURLs(urls)
    
    }
    
    func showNextPhoto(){
        guard imageIndex < imageUrls.count-1 else {
            return
        }
        imageIndex += 1
        print(imageIndex, imageUrls)
        self.imageUrl = URL(string: imageUrls[imageIndex])
        //self.imageToShow = user.images[imageIndex]
    }
    
    func showPreviousPhoto(){
        guard imageIndex > 0 else {
            return
        }
        imageIndex -= 1
        self.imageUrl = URL(string: imageUrls[imageIndex])
        //self.imageToShow = user.images[imageIndex]
    }
}
