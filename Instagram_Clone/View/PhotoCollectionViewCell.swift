//
//  PhotoCollectionViewCell.swift
//  Instagram_Clone
//
//  Created by talha polat on 2.11.2023.
//

import UIKit

class PhotoCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imgPhoto: UIImageView!
    
    override class func awakeFromNib() {
        super.awakeFromNib()
        print("Çalıştı")
    }
}
