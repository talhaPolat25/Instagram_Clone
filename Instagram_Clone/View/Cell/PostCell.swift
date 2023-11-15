//
//  PostCell.swift
//  Instagram_Clone
//
//  Created by talha polat on 11.11.2023.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore
import SDWebImage
class PostCell: UITableViewCell {

  
    
    var photo:SharedPhoto?{
        didSet{
            print("fotoğraf yüklendi----------------")
            print(photo)
            guard let url1 = photo?.DowlandUrl,
                  let downloadUrl = URL(string: url1)
            else{return}
                imgPost.sd_setImage(with: downloadUrl)
           
            guard let url2 = photo?.user.ProfilePhotoUrl,
                  let downloadUrl = URL(string: url2)
            else{return}
            imgProfilePhoto.sd_setImage(with: downloadUrl)
               /* let userID = Auth.auth().currentUser?.uid
                if self?.photo?.UserID == userID{
                    self?.btnFollow.isHidden = true
                }*/
            }
            
        }
    
    @IBOutlet weak var lblUsername: UILabel!
    @IBOutlet weak var imgPost: UIImageView!
    @IBOutlet weak var imgProfilePhoto: UIImageView!
    @IBOutlet weak var btnMessage: UIButton!
    @IBOutlet weak var btnComment: UIButton!
    @IBOutlet weak var btnFollow: UIButton!
    @IBOutlet weak var lblThoughtPhoto: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        imgProfilePhoto.layer.cornerRadius = imgProfilePhoto.frame.width / 2
        imgPost.contentMode = .scaleToFill
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
