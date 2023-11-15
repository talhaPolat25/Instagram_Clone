//
//  PhotoChoosingCell.swift
//  Instagram_Clone
//
//  Created by talha polat on 4.11.2023.
//

import UIKit
import SDWebImage
class PhotoChoosingCell: UICollectionViewCell {

    @IBOutlet weak var imgPhoto: UIImageView!
    var photo:SharedPhoto?{

        didSet{
            let url = URL(string: photo?.DowlandUrl ?? "")
            self.imgPhoto.sd_setImage(with:url )
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
       // imgPhoto.contentMode = .scaleAspectFill
       // imgPhoto.clipsToBounds = true
    }

}
