//
//  ProfileVC.swift
//  Instagram_Clone
//
//  Created by talha polat on 1.11.2023.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore
class ProfileCollectionVC: UICollectionViewController {
    var user : User?
    let firestore = Firestore.firestore()
    var myPhotos = [SharedPhoto]()

    override func viewDidLoad() {
        super.viewDidLoad()

        
        collectionView.register(UINib(nibName: "ProfileHeaderView", bundle: nil), forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "ProfileHeaderView")
        self.collectionView.register(UINib(nibName: "PhotoChoosingCell", bundle: nil), forCellWithReuseIdentifier: "photoCvc")
        GetUserInfo()
        print("dikatt ---------------------",user?.Username)
    }
    

   private func GetUserInfo () {
       guard let userId = user?.UserID ?? Auth.auth().currentUser?.uid else {return}
        
        Firestore.firestore().collection("Users").document(userId).getDocument { snapshot, error in
            self.user = decodeFirebase(type:User.self, snapshot: snapshot)
            self.getSharedPhotos()
        }
    }
    private func GetUser(){
        guard let userId = user?.UserID ?? Auth.auth().currentUser?.uid else {return}
        
        self.firestore.collection("Users").document(userId).getDocument { snapshot, error in
            if let error = error{
                print("Can get user info: ",error.localizedDescription)
                return
            }
            guard let snapshot = snapshot else{return}
            
            self.user =  decodeFirebase(type: User.self, snapshot: snapshot)
            
        }
    }
       
     func getSharedPhotos(){
         guard let userId = user?.UserID ?? Auth.auth().currentUser?.uid else {return}
       
        
        Firestore.firestore().collection("SharedPhotos").document(userId).collection("MyPhotos").order(by: "AddingDate", descending: false).addSnapshotListener { snapshot, error in
            
            if let error = error {
                print("An error occured when fetch data from firestore : ",error)
            }
            
            snapshot?.documentChanges.forEach{ documentChange in
                
                if documentChange.type == .added{
                    
                    let photoData = documentChange.document.data()
                    guard let userID = photoData["UserID"] as? String else{return}
                    
                    let photo = SharedPhoto(uploaderUser:self.user!, photoData: photoData)
                        self.myPhotos.append(photo)
                    }//if end
                }
                self.myPhotos = self.myPhotos.reversed()
                self.collectionView.reloadData()
            }
    }
    /*private func  decodeFirebase<T:Decodable> (type: T.Type,snapshot: DocumentSnapshot?) -> T?{
        
        guard let userData = snapshot?.data() else{
            print("Userdata")
            return nil }
        print(userData)
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: userData, options: [])
            let jsonString = String(data: jsonData, encoding: .utf8)
           
            if let jsonData = jsonString?.data(using: .utf8) {
               
                 let  decodedObject = try JSONDecoder().decode(T.self, from: jsonData)
                print("Dönüşüm başarılı: \(decodedObject)")
               return decodedObject
            }else{
                print("Json false")
                return nil
            }
                } catch  let error{
                    print(error.localizedDescription)
                    
                }

        
        return nil
    }*/
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let heardView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "ProfileHeaderView", for: indexPath) as! ProfileHeaderView
        if let user = user {
            heardView.user = user}
        //heardView.backgroundColor = .black
        return heardView
    }
    
    @IBAction func btnOptionsClicked(_ sender: UIBarButtonItem) {
        let alertController = UIAlertController(title: "Options", message: "Do you want to exit?", preferredStyle: .actionSheet)
        let logoutAction = UIAlertAction(title: "Log out", style: .destructive){_ in
            do {
                try Auth.auth().signOut()
                
                guard  let authNVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "AuthenticationNVC") as? UINavigationController else{return}
                authNVC.modalPresentationStyle = .fullScreen
               // self.navigationController?.pushViewController(authNVC, animated: true)
            } catch let logoutError {
                print("An error occured when sign out ",logoutError)
            }
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        alertController.addAction(logoutAction)
        alertController.addAction(cancelAction)
        present(alertController, animated: true)
    }
    
}

extension ProfileCollectionVC:UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: self.view.frame.width, height: 181)
    }
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return myPhotos.count
        
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = self.view.frame.width / 3 - 1
        return CGSize(width: size, height: size)
        
    }
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "photoCvc", for: indexPath) as? PhotoChoosingCell {
            
            cell.photo = self.myPhotos[indexPath.row]
            return cell
        }
            return UICollectionViewCell()
        
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
}
