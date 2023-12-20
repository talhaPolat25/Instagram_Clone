//
//  YorumlarCVC.swift
//  Instagram_Clone
//
//  Created by talha polat on 27.11.2023.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore
private let reuseIdentifier = "CommentCell"

class CommentsCVC: UICollectionViewController {
    var sharedPhoto:SharedPhoto?
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Comments"
        navigationController?.navigationBar.tintColor = .label
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        collectionView.keyboardDismissMode = .onDrag
        collectionView.alwaysBounceVertical = true
        // Register cell classes
        self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        collectionView.register(UINib(nibName: "CommentCell", bundle: nil), forCellWithReuseIdentifier:"commentCell")
        
        
        // Do any additional setup after loading the view.
        getAllComments()
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        tabBarController?.tabBar.isHidden = false
    }
    
    var comments = [Comment]()
    private func getAllComments(){
        comments.removeAll()
        guard let sharedPhotoID = sharedPhoto?.id else{return}
       
        Firestore.firestore().collection("Comments").document(sharedPhotoID).collection("AddedComments").addSnapshotListener { snapshot, error in
            if let error = error {
                print("An error occured when fetch comments from firestore: ", error.localizedDescription)
                return
            }
            guard let snapshot = snapshot else{return}
            
            snapshot.documentChanges.forEach { documentChange in
                
                if documentChange.type == .added {
                    let commentData = documentChange.document.data()
                    do{
                        let commentJson = try JSONSerialization.data(withJSONObject: commentData)
                        let comment = try JSONDecoder().decode(Comment.self, from: commentJson)
                        self.comments.append(comment)
                      }catch let error{
                        print("An error occured when serialize comment data: ",error.localizedDescription)
                                    }
                    
                }
            }
            
            self.collectionView.reloadData()
        }
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return comments.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "commentCell", for: indexPath)  as? CommentCell else{return UICollectionViewCell()}
        
        // Configure the cell
        let comment = comments[indexPath.row]
        cell.configureCell(comment: comment)
        return cell
    }
    
     lazy var containerView : UIView = {
        let containerView = UIView()
         containerView.frame = CGRect(x: 0, y: 0, width: 150, height: 60)
         containerView.backgroundColor = .systemBackground
         
         containerView.addSubview(txtComment)
        
         let btnShareComment = UIButton(type: .system)
         btnShareComment.setTitle("Send", for: .normal)
         btnShareComment.setTitleColor(.label, for: .normal)
         btnShareComment.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
         btnShareComment.addTarget(self, action:#selector(btnShareCommentClicked), for: .touchUpInside)
         btnShareComment.translatesAutoresizingMaskIntoConstraints = false
         containerView.addSubview(btnShareComment)
         
         let btnConstraints = [
             btnShareComment.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -10),
             btnShareComment.topAnchor.constraint(equalTo: containerView.topAnchor),
             btnShareComment.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
             btnShareComment.widthAnchor.constraint(equalToConstant: 60)
         ]
         let txtConstraints = [
             txtComment.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
             txtComment.topAnchor.constraint(equalTo: containerView.safeAreaLayoutGuide.topAnchor),
             txtComment.bottomAnchor.constraint(equalTo: containerView.bottomAnchor,constant: -10),
             txtComment.trailingAnchor.constraint(equalTo: btnShareComment.leadingAnchor)
         ]
         NSLayoutConstraint.activate(btnConstraints)
         NSLayoutConstraint.activate(txtConstraints)
        return containerView
    }()
    
    let txtComment:UITextField = {
        let txtComment = UITextField()
        txtComment.placeholder = "Comment"
        txtComment.translatesAutoresizingMaskIntoConstraints = false
        txtComment.textColor = UIColor.label
        txtComment.layer.borderWidth = 1.5
        txtComment.layer.borderColor = UIColor.lightGray.cgColor
        txtComment.layer.cornerRadius = 5
        return txtComment
    }()
    
    @objc private func btnShareCommentClicked(){
        guard let yorum = txtComment.text,
              !yorum.isEmpty else{return}
        guard let userID = Auth.auth().currentUser?.uid,
        let sharedPhoto = sharedPhoto,
              let photoDocumentID = sharedPhoto.id
        else{return}
        
        let addingData = [
            "Comment":yorum,
            "AddingDate":Date().timeIntervalSince1970,
            "UserID":userID
        ] as [String:Any]
        Firestore.firestore().runTransaction { transaction, error in
            
            let photoPath = Firestore.firestore().collection("SharedPhotos").document(sharedPhoto.user.UserID).collection("MyPhotos").document(photoDocumentID)
            
            do{
                let photoData = try transaction.getDocument(photoPath).data()
                guard let CommentCount = photoData?["CommentCount"] as? Int else{
                    return
                }
                
                transaction.updateData(["CommentCount" : CommentCount+1], forDocument: photoPath)
            }
            catch let error{
                print("An error occured when fetch photo from firebase: ",error.localizedDescription)
            }
            return nil
        } completion: { object, error in
            if let error = error {
                print("An error occured when add comment:",error.localizedDescription)
                return
            }
            
            Firestore.firestore().collection("Comments").document(sharedPhoto.id ?? "").collection("AddedComments").document().setData(addingData){error in
                if let error = error {
                    print("An error occured when upload comment to firestore",error.localizedDescription)
                    return
                }
                print("Adding comment is successfull")
                self.txtComment.text = ""
            }
        }  
    }
    override var inputAccessoryView: UIView?{
        get{
            containerView.layer.cornerRadius = 5
            return containerView
        }
    }
    override var canBecomeFirstResponder: Bool {
        return true
    }
  

}
extension CommentsCVC:UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.width, height: 65)
    }
}
