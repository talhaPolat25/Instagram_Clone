//
//  ProfileHeaderView.swift
//  Instagram_Clone
//
//  Created by talha polat on 1.11.2023.
//

import UIKit
import SDWebImage
import Firebase
import FirebaseFirestore
class ProfileHeaderView: UICollectionViewCell {
    @IBOutlet weak var btnProfilDuzenle: UIButton!
    
    @IBOutlet weak var txtUsername: UITextField!
    @IBOutlet weak var txtFollowing: UITextField!
    @IBOutlet weak var txtFollowers: UITextField!
    @IBOutlet weak var txtShare: UITextField!
    @IBOutlet weak var stackSections: UIStackView!
    var user : User?{
        didSet{
            guard let url = URL(string: user!.ProfilePhotoUrl) else {return}
            self.imgProfilePhoto.sd_setImage(with: url)
            txtUsername.text = user?.Username
            txtFollowers.text = "\(user?.FollowersCount ?? 0)"
            txtFollowing.text = "\(user?.FollowingCount ?? 0)"
            txtShare.text = "\(user?.PostCount ?? 0)"
            print("Hayırlı olsun brom")
        }
    }
    @IBOutlet weak var imgProfilePhoto: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
       // backgroundColor = .darkGray
        // Initialization code
        configureHeaderUI()
        //  setProfilePhoto()
    }
    
    fileprivate func configureHeaderUI(){
        imgProfilePhoto.layer.cornerRadius = imgProfilePhoto.frame.width / 2
        imgProfilePhoto.clipsToBounds = true
        imgProfilePhoto.contentMode = .scaleAspectFill
        
        stackSections.layer.borderColor = UIColor.lightGray.cgColor
        stackSections.layer.borderWidth = 2
        
        btnProfilDuzenle.layer.borderColor = UIColor.lightGray.cgColor
        btnProfilDuzenle.layer.borderWidth = 2
        btnProfilDuzenle.layer.cornerRadius = 5
    }
   /* override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .darkGray
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    */
    private func setProfilePhoto(){
        
        guard let userID = Auth.auth().currentUser?.uid else{return}
        
        Firestore.firestore().collection("Users").document(userID).getDocument { snapshot, error in
            
            if let error = error {
                print("An error occured when get user's document: ",error.localizedDescription)
            }
            guard let snapshot = snapshot else {return}
            guard let userData = snapshot.data() else{return}
            
            guard let profileUrl = userData["ProfilePhotoUrl"] as? String else{
                print("There is no data as you wait")
                return}
            
            guard let url = URL(string: profileUrl) else{
                print("It couldnt create url")
                return}
            
           /* URLSession.shared.dataTask(with: URLRequest(url: url)){data,response,error in
                
                if let error = error {
                    print("It couldnt fetch profile photo data : ",error.localizedDescription)
                                        }
                print(data)
                guard let data = data else{return}
                
                let image = UIImage(data: data)
                DispatchQueue.main.async {
                    self.imgProfilePhoto.image = image
                }
                
            }.resume() */
           
        }
    }
}
