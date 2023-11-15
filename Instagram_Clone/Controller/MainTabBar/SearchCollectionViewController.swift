//
//  SearchUserCollectionViewController.swift
//  Instagram_Clone
//
//  Created by talha polat on 15.11.2023.
//

import UIKit
import Firebase
private let reuseIdentifier = "Cell"

class SearchCollectionViewController: UICollectionViewController {
    lazy var searchBar: UISearchBar = {
        let searchbar = UISearchBar()
        searchbar.placeholder = "Search"
        UITextField.appearance(whenContainedInInstancesOf:[UISearchBar.self]).backgroundColor = .lightGray
        searchbar.translatesAutoresizingMaskIntoConstraints = false
        searchbar.delegate = self
        return searchbar
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        self.collectionView.register(UINib(nibName: "SearchUserCell", bundle: nil), forCellWithReuseIdentifier: "SearchUserCell")
        collectionView.alwaysBounceVertical = true
        navigationController?.navigationBar.addSubview(searchBar)
        allignSearchBar()
        collectionView.keyboardDismissMode = .onDrag
        GetUsers()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        searchBar.isHidden = false
    }
   
    
    private func allignSearchBar (){
        guard let navigationBar = navigationController?.navigationBar else {return}
        let constraintsOfSearchBar = [
            searchBar.leadingAnchor.constraint(equalTo: navigationBar.leadingAnchor, constant: 10),
            searchBar.trailingAnchor.constraint(equalTo: navigationBar.trailingAnchor, constant: -10),
            searchBar.topAnchor.constraint(equalTo: navigationBar.topAnchor),
            searchBar.bottomAnchor.constraint(equalTo: navigationBar.bottomAnchor)
        ]
        NSLayoutConstraint.activate(constraintsOfSearchBar)
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
        return filteredUsers.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SearchUserCell.identifier, for: indexPath) as? SearchUserCell 
        else {print("Bura baba ------------------------")
            return UICollectionViewCell()}
        cell.user = filteredUsers[indexPath.row]
        // Configure the cell
        print("Çalıştı")
        return cell
    }
    var filteredUsers = [User]()
    var users = [User]()
    
    fileprivate func GetUsers(){
        users.removeAll()
        Firestore.firestore().collection("Users").getDocuments { snapshot, error in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            guard let snapshot = snapshot else{return}
            
            snapshot.documentChanges.forEach { documentChange in
                
                if documentChange.type == .added{
                    let userDocumentSnapshot = documentChange.document
                    let user = decodeFirebase(type: User.self, snapshot: userDocumentSnapshot)
                    print(user)
                    self.users.append(user!)
                }
                
            }//for döngü sonu
            print("Toplam user sayısı : --->",self.users.count)
            self.filteredUsers = self.users
            self.collectionView.reloadData()
        }
    }
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        searchBar.isHidden = true
        searchBar.resignFirstResponder()
        let kullanici = users[indexPath.row]
        guard let profileCVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "profileCVC") as? ProfileCollectionVC else{return}
        profileCVC.user = kullanici
        navigationController?.pushViewController(profileCVC, animated: true)
        
    }

    // MARK: UICollectionViewDelegate
    

}

extension SearchCollectionViewController:UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 70)
    }
}
extension SearchCollectionViewController:UISearchBarDelegate{
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.count == 0{
            self.filteredUsers = self.users
        }else{
            self.filteredUsers = users.filter({ user in
                return user.Username.contains(searchText.lowercased())
            })
        }
        self.collectionView.reloadData()
    }
}
