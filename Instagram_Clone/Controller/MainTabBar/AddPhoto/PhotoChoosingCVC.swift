//
//  PhotoChoosingCVC.swift
//  Instagram_Clone
//
//  Created by talha polat on 3.11.2023.
//

import UIKit
import Photos
private let reuseIdentifier = "photoCvc"

class PhotoChoosingCVC: UICollectionViewController {
    let headerIdentifier = "HeaderID"
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Register cell classes
        self.collectionView.register(UINib(nibName: "PhotoChoosingCell", bundle: nil), forCellWithReuseIdentifier: reuseIdentifier)
        self.collectionView.register(SelectedPhotoHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerIdentifier)

        // Do any additional setup after loading the view.
        getPhotos()
    }
    
    
   
    private func setFetchOptionsForImageRequest() -> PHFetchOptions{
        let fetchOptions = PHFetchOptions()
        fetchOptions.fetchLimit = 10
        let sorter = NSSortDescriptor(key: "creationDate", ascending: false)
        fetchOptions.sortDescriptors = [sorter]
        
        return fetchOptions
    }
    private var selectedPhoto : UIImage?
    var photos = [UIImage]()
    var assets = [PHAsset]()
   
    private func getPhotos(){
        DispatchQueue.global(qos: .background).async {
            let photoAssets = PHAsset.fetchAssets(with: .image, options: self.setFetchOptionsForImageRequest())
            
            photoAssets.enumerateObjects{asset, counter, stayedAdress in
              //asset fotoğrafların bilgilerini taşıyor
                
              //photo manager ile asset bilgilerinden fotoları çekecez
                let manager = PHImageManager.default()
                let photoSize = CGSize(width: 200, height: 200)
                let options = PHImageRequestOptions()
                options.isSynchronous = true
                manager.requestImage(for: asset, targetSize: photoSize, contentMode: .aspectFit, options: options) { image, imageInfos in
                    
                    guard let photo = image else{
                        print("Sıkıntı var baba")
                        return}
                    self.photos.append(photo)
                    self.assets.append(asset)
                    
                    print(photo)
                    
                }
                DispatchQueue.main.async {
                    self.selectedPhoto = self.photos[0]
                    self.collectionView.reloadData()
                }
                
            }
        }
       
        
    }
   
    @IBAction func cancelBtnClicked(_ sender: UIBarButtonItem) {
        dismiss(animated: true)
    }
    
    @IBAction func btnNextClicked(_ sender: UIBarButtonItem) {
        guard let photoSharingCntroller = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "PhotoSharingController") as? PhotoSharingController else{return}
        photoSharingCntroller.selectedImage = self.selectedPhoto
        navigationController?.pushViewController(photoSharingCntroller, animated: true)
    }
    
  
}
extension PhotoChoosingCVC{
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let photo = photos[indexPath.row]
        self.selectedPhoto = photo
        collectionView.reloadData()
    }
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return photos.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! PhotoChoosingCell
    
       // cell.imgPhoto.image = photos[indexPath.row]
        cell.imgPhoto.image = photos[indexPath.row]
        
        return cell
    }
}

extension PhotoChoosingCVC:UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let genislik = (view.frame.width-5)/4
        return CGSize(width: genislik, height: genislik)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
       
        let genislik = view.frame.width
        return CGSize(width: genislik, height: genislik)
        
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
         let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerIdentifier, for: indexPath) as! SelectedPhotoHeader
        
        if let selectedPhoto = selectedPhoto {
            if let index = photos.firstIndex(of: selectedPhoto){
                let asset = assets[index]
                let imageManager = PHImageManager()
                let photoSize = CGSize(width:600, height: 600)
                imageManager.requestImage(for: asset, targetSize: photoSize, contentMode: .default, options: nil) { image, imageInfo in
                    header.imageView.image = image
                    self.selectedPhoto = image
                }
                
            }
           
        }
        return header
    }
  
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    //Örneğin 2. sectionla 1. section arasınadaki içten verilen boşluğu belirtir.
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 1, left: 0, bottom: 0, right: 0)
    }
}
