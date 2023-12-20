//
//  PhotoDetailTVController.swift
//  Instagram_Clone
//
//  Created by talha polat on 29.11.2023.
//

import UIKit
import FirebaseFirestore
import FirebaseAuth
import SDWebImage
class MyPhotosTVController: UITableViewController {
    let firestore = Firestore.firestore()
    var sharedPhotos : [SharedPhoto]?{
        didSet{
            tableView.reloadData()
        }
    }
    var indexpath:IndexPath?{
        didSet{
            guard let indexPath = indexpath else{return}
            tableView.scrollToRow(at: indexPath, at: .top, animated: true)
        }
    }
    let refreshController = UIRefreshControl()
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.register(UINib(nibName: "PostCell", bundle: nil), forCellReuseIdentifier: "PostCell")
        
        refreshController.addTarget(self, action: #selector(refreshTableView), for: .valueChanged)
        tableView.refreshControl = refreshController
        navigationController?.navigationBar.tintColor = .label
    }
    @objc func refreshTableView(){
        tableView.reloadData()
        refreshController.endRefreshing()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return sharedPhotos?.count ?? 0
    }
    
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "PostCell", for: indexPath) as? PostCell,
              let sharedPhotos = sharedPhotos
        else{return UITableViewCell()}

        // Configure the cell...
        
        cell.photo = sharedPhotos[indexPath.row]
        print(sharedPhotos[indexPath.row].DowlandUrl)
        cell.delegate = self
        return cell
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 623
    }

}
extension MyPhotosTVController:PostCellDelegate{
    func OptionsClicked(sharedPhoto: SharedPhoto) {
        let alertController = UIAlertController(title: "Options", message: "Please choose what you want", preferredStyle: .actionSheet)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
       
        let deleteAction = UIAlertAction(title: "Delete the photo", style: .destructive){action in
            self.firestore.collection("SharedPhotos").document(sharedPhoto.user.UserID).collection("MyPhotos").document(sharedPhoto.id!).delete { error in
                if let error {
                    print("An error occured when delete the photo: ",error.localizedDescription)
                }
                print("Delete session completed")
                DispatchQueue.main.async {
                    self.refreshTableView()
                }

                //decrease post count
                self.firestore.runTransaction { transaction, error in
                    
                    let documentPath = self.firestore.collection("Users").document(sharedPhoto.user.UserID)
                
                    do{
                        guard let sharedPhotoCount = try transaction.getDocument(documentPath).data()?["PostCount"] as? Int else{
                            print("İt couldnt fetch post count")
                            return}
                        transaction.updateData(["PostCount":sharedPhotoCount-1], forDocument: documentPath)
                    
                    }
                    catch let error {
                        print(error.localizedDescription)
                    }
                    
                    return nil
                } completion: { object, error in
                    if let error {
                        print("An error occured when decrease post count: ",error.localizedDescription)
                        return
                    }
                    print("Post count has changed")
                }

               
            }
        }
        alertController.addAction(cancelAction)
        alertController.addAction(deleteAction)
        present(alertController, animated: true)
        
    }
    
    func commentCountClicked(photo: SharedPhoto) {
        guard let commentCVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "commentCVC") as? CommentsCVC else {return}
        commentCVC.sharedPhoto = photo
        navigationController?.pushViewController(commentCVC, animated: true)
    }
    
    func btnCommentClicked(sharedPhoto: SharedPhoto) {
        guard let commentCVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "commentCVC") as? CommentsCVC else {return}
        commentCVC.modalPresentationStyle = .pageSheet
        commentCVC.sharedPhoto = sharedPhoto
        navigationController?.pushViewController(commentCVC, animated: true)
    }
    
    func userInfosClicked(user: User) {
        guard let profileCVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "profileCVC") as? ProfileCollectionVC ,
            Auth.auth().currentUser?.uid != nil
        else {return}
        profileCVC.btnBack.isHidden = false
        profileCVC.modalPresentationStyle = .pageSheet
        profileCVC.user = user
        navigationController?.pushViewController(profileCVC, animated: true)
    }
}
