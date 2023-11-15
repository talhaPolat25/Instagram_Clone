//
//  SearchUserCell.swift
//  Instagram_Clone
//
//  Created by talha polat on 15.11.2023.
//

import UIKit
import SDWebImage
class SearchUserCell: UICollectionViewCell {
    var user: User?{
        didSet{
            lblUsername.text = user?.Username
            guard let url = URL(string: user?.ProfilePhotoUrl ?? "") else{ return}
            imgProfilePhoto.sd_setImage(with: url)
        }
    }
    
    static let identifier = "SearchUserCell"
    
    @IBOutlet weak var lblUsername: UILabel!
    @IBOutlet weak var imgProfilePhoto: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        configureCell()
    }

    func configureCell(){
        imgProfilePhoto.layer.cornerRadius = imgProfilePhoto.frame.width / 2
    }
}
