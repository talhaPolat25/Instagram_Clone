//
//  HomeTableViewController.swift
//  Instagram_Clone
//
//  Created by talha polat on 11.11.2023.
//

import UIKit
import FirebaseFirestore
import FirebaseAuth
class HomeTableViewController: UITableViewController {
    let reuseIdentifier = "PostCell"
    var sharedPhotos = [SharedPhoto]()
    let firestore = Firestore.firestore()
    var user : User?
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.register(UINib(nibName: "PostCell", bundle: nil), forCellReuseIdentifier: reuseIdentifier)
        tableView.register(InstagramStoryTableViewCell.self, forCellReuseIdentifier: InstagramStoryTableViewCell.identifier)
        let instagramLogo = UIImage(named: "Logo_Instagram")?.withRenderingMode(.alwaysTemplate)
        navigationItem.titleView = UIImageView(image: instagramLogo)
       // getPostCount()
        getUser()
        
        //GetAllPhotos()
    }
    fileprivate func getUser(){
        guard let userID = Auth.auth().currentUser?.uid else{return}
        self.firestore.collection("Users").document(userID).getDocument { snapshot, error in
            if let error = error{
                print("Can get user info: ",error.localizedDescription)
                return
            }
            guard let snapshot = snapshot else{return}
            self.user = decodeFirebase(type: User.self, snapshot: snapshot)
            print("Burasııı\n\n",self.user)
            self.getPhotos()
        }
       
    }
    //düzenlenecek tüm verilerden bizim ait olduklarımızı farklı ait olmayanları farklı getirecek.
    fileprivate func getPhotos (){
        self.sharedPhotos.removeAll()
        if  user == nil{
            print("-------------Nil geldi babaaa")
        }
        guard let userID = Auth.auth().currentUser?.uid else {return }
            
        self.firestore.collection("SharedPhotos").document(userID).collection("MyPhotos").order(by: "AddingDate", descending: false).addSnapshotListener { snapshot, error in
            
            if let error = error {
                print("An error occured : ",error.localizedDescription)
                return           }
            
            guard let snapshot = snapshot else{return}
            
                snapshot.documentChanges.forEach { documentChange in
                    if documentChange.type == .added{
                        
                        guard let photoData = documentChange.document.data() as? [String:Any]
                        else{
                            print("Cant take data from docuement")
                        }
                        guard let user = self.user else{return}
                        let photo = SharedPhoto(uploaderUser:user, photoData: photoData)
                            self.sharedPhotos.append(photo)
                        
                    }//if end
            }//for end
                DispatchQueue.main.async {
                    self.sharedPhotos = self.sharedPhotos.reversed()
                    self.tableView.reloadData()
                }
            }
            
        
    }
    
    // MARK: - Table view data source
   /* private func getPostCount(){
        guard let userID = Auth.auth().currentUser?.uid else {return }
        Firestore.firestore().collection("Users").document(userID).addSnapshotListener{(snapshotListener,error)in
            
            if let error = error{
                print("An error occured when fetch data of user :",error.localizedDescription)
                return
            }
            
             let userData = snapshotListener?.data()
            
            guard let postCount = userData?["PostCount"] as? Int else{
                print("Can get post count")
                return}
            
            self.postCount = postCount
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
        return 
    }*/

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if section == 0{
            return 1
        }else{return sharedPhotos.count}
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            
            guard let cell = tableView.dequeueReusableCell(withIdentifier: InstagramStoryTableViewCell.identifier, for: indexPath) as? InstagramStoryTableViewCell else{return UITableViewCell()}
            
            
            return cell
        }
        else{
            guard let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as? PostCell else{return
                UITableViewCell()}
            cell.photo = self.sharedPhotos[indexPath.row]
            return cell}
      
    }
    
  /*  private func GetAllPhotos(){
        if let userID = Auth.auth().currentUser?.uid {
            print(userID)
            let sharedPhotosRef = Firestore.firestore().collection("SharedPhotos").getDocuments{ photosSnapshot,error in
               
                if let error = error {
                    print("An error occured when get collection from firebase: ",error)
                    return
                }
                print(photosSnapshot?.count)
                guard let sharedPhotosDocuments = photosSnapshot?.documents else{
                    print("Babab dökümanları alırken sıkıntı oldu")
                    return}
                print(sharedPhotosDocuments)
                for userPhotoDocuments in sharedPhotosDocuments {
                    print(userPhotoDocuments.reference.documentID)
                }
                
                // artık çektiğimiz veriyi kullanabiliriz
            
            }
        }
    }*/
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 0.3))
        view.backgroundColor = .darkGray
        return view
    }
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {return 0}
        else{return 0.5}
        
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {return 100}
        else{return 623}
        
    }
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
