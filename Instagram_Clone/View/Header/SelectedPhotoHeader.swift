//
//  SelectedPhotoHeader.swift
//  Instagram_Clone
//
//  Created by talha polat on 6.11.2023.
//

import UIKit

class SelectedPhotoHeader: UICollectionViewCell {
    
    let imageView:UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(imageView)
        imageView.frame = frame
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

}
