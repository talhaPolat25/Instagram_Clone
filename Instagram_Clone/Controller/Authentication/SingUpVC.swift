//
//  SingUpVC.swift
//  InstagramClone
//
//  Created by talha polat on 30.10.2023.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore
import FirebaseStorage
class SingUpVC: UIViewController {

    @IBOutlet weak var imgAddImage: UIImageView!
    @IBOutlet var btnAddImageTapRecogniser: UITapGestureRecognizer!
    
    @IBOutlet weak var btnSignUp: UIButton!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var txtUsername: UITextField!
    @IBOutlet weak var txtEmail: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        // Do any additional setup after loading the view.
    }
    
    private func configureUI(){
        imgAddImage.isUserInteractionEnabled = true
        imgAddImage.addGestureRecognizer(btnAddImageTapRecogniser)
        imgAddImage.contentMode = .scaleAspectFill
    }
   
    @IBAction func btnAddImageClicked(_ sender: UITapGestureRecognizer) {
       // Utilities.ShowMessageAndDismissAlert(viewController: navigationController ?? UINavigationController(), message: "Oldu", title: "oldu baba")
        //We take photo from device with UIImagePickerController
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        present(pickerController, animated: true)
    }
    @IBAction func isFormValid(_ sender: UITextField) {
        if (txtEmail.text?.count ?? 0) > 0  && txtUsername.text!.count>0 && txtPassword.text!.count>0{
            btnSignUp.isEnabled = true
        }else{
            btnSignUp.isEnabled = false
        }
    }
    
    @IBAction func btnSignUpClicked(_ sender: UIButton) {
        guard let email = txtEmail.text ,
        let pasword = txtPassword.text ,
        let username = txtUsername.text else{return}
            
        Auth.auth().createUser(withEmail: email, password: pasword){(result,error) in
            if let error = error{
                print("An error occured when create an user :",error.localizedDescription)
                return
            }
            
            let imageID = UUID().uuidString
            guard let userID = result?.user.uid else{return}
            
            let ref = Storage.storage().reference(withPath: "/ProfilePhotos/\(imageID)")
            let imgData = self.imgAddImage.image?.jpegData(compressionQuality: 0.8) ?? Data()
            ref.putData(imgData) { _,error in
                if let error = error {
                    print("An error occured when put data to storage :",error.localizedDescription)
                    return
                }
                
                ref.downloadURL { url, error in
                    print(url?.absoluteString)
                    if let error = error {
                        print("An error occured when get the image url :",error.localizedDescription)
                        return
                    }
                    let userInfo = ["UserID":userID,
                                    "ProfilePhotoUrl":url?.absoluteString ?? "",
                                    "Username":username
                    ]
                    Firestore.firestore().collection("Users").document(userID).setData(userInfo){error in
                        if let error = error {
                            print("An error occured when add the user's info")
                            return
                        }
                        print("Registration is completed")
                        self.txtEmail.text = ""
                        self.txtPassword.text = ""
                        self.txtUsername.text = ""
                        
                    }
                   
                }
            }
           
        }
    }
    
    
    
}

extension SingUpVC:UIImagePickerControllerDelegate,UINavigationControllerDelegate{
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        print("Choosing")
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image = info[.originalImage] as? UIImage
        imgAddImage.layer.cornerRadius = imgAddImage.frame.width / 2
        imgAddImage.image = image
        imgAddImage.clipsToBounds = true
        imgAddImage.layer.borderColor = UIColor.lightGray.cgColor
        imgAddImage.layer.borderWidth = 3
        dismiss(animated: true)
    }
}
