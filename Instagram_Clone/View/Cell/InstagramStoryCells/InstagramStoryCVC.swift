//
//  InstagramStoryCVC.swift
//  Instagram_Clone
//
//  Created by talha polat on 12.11.2023.
//

import UIKit

class InstagramStoryCVC: UICollectionViewCell {
    static let identifier = "InstagramStoryCVC"
    
    let imageView:UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.masksToBounds = true
        imageView.image = UIImage(named: "AppIcon")
        imageView.layer.borderColor = UIColor.white.cgColor
        imageView.layer.borderWidth = 1
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(imageView)
        
       
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        imageView.frame = self.bounds
        imageView.layer.cornerRadius = contentView.frame.width / 2
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
