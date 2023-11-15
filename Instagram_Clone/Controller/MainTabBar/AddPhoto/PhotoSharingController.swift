//
//  PhotoSharingController.swift
//  Instagram_Clone
//
//  Created by talha polat on 6.11.2023.
//

import UIKit
import FirebaseStorage
import FirebaseFirestore
import FirebaseAuth

class PhotoSharingController: UIViewController {
    var selectedImage:UIImage?
    @IBOutlet weak var imgSelectedPhoto: UIImageView!
    
    @IBOutlet weak var txtImageThought: UITextView!
  
    override func viewDidLoad() {
        super.viewDidLoad()
        imgSelectedPhoto.image = selectedImage
        
    }
    
    
    
    @IBAction func btnShareClicked(_ sender: UIBarButtonItem) {
        self.navigationItem.rightBarButtonItem?.isEnabled = false
      
        guard let image = imgSelectedPhoto.image else {return}
        let imageData = image.jpegData(compressionQuality: 0.8) ?? Data()
        
        let randomImageID = UUID().uuidString
        var ref = Storage.storage().reference(withPath: "/SharedPhotos/\(randomImageID)")
        
        ref.putData(imageData) { _, error in
            if let error = error {
                print("An error occured when upload photo :",error.localizedDescription)
               
                return
            }
            
            ref.downloadURL { url, error in
                if let error = error {
                    print("An error occured when get url : ",error.localizedDescription)
                }
                guard let url = url else{return}
                self.uploadDataToFirestore(url: url.absoluteString)
                self.dismiss(animated: true)
            }
        }
    }
   
    private func uploadDataToFirestore(url: String){
        let db = Firestore.firestore()
        guard let thought = self.txtImageThought.text,
              self.txtImageThought.text.trimmingCharacters(in: .whitespacesAndNewlines).count>0 ,let image = imgSelectedPhoto.image else{return}
        guard let userID = Auth.auth().currentUser?.uid else{return}
        var firestoreRef = Firestore.firestore().collection("SharedPhotos").document(userID).collection("MyPhotos")
        
        let infoPhoto = ["DowlandUrl": url,
                         "UserID": userID,
                         "Thought": thought,
                         "PhotoHeight": image.size.height,
                         "PhotoWidth": image.size.width,
                         "AddingDate" : Timestamp(date: Date())
                
        ]  as [String:Any]
        let userRef = Firestore.firestore().collection("Users").document(userID)
        
        db.runTransaction { transaction, error -> Any? in
            
            do{
                let UserDocumentSnapshot = try transaction.getDocument(userRef)
                
                guard let userData = UserDocumentSnapshot.data() else{
                    print("Cant get user data")
                    return}
                
                let postCount = userData["PostCount"] as? Int ?? 0
                transaction.updateData(["PostCount": postCount+1], forDocument: userRef)
               
                firestoreRef.addDocument(data: infoPhoto) { error in
                    if let error = error{
                        print("It couldnt create a document: ",error)
                    }
                    print("Adding photo is succesfull")
                }
            }
            catch let error {
                print(error.localizedDescription)
            }
            return nil
        }
    completion: { object, error in
            
        } 
    }
    
}
