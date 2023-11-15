//
//  PhotoChoosingCell.swift
//  Instagram_Clone
//
//  Created by talha polat on 4.11.2023.
//

import UIKit

class PhotoChoosingCell: UICollectionViewCell {

    @IBOutlet weak var imgPhoto: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
       // imgPhoto.contentMode = .scaleAspectFill
       // imgPhoto.clipsToBounds = true
    }

}
