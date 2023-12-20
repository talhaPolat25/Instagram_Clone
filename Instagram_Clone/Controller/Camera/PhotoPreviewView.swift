//
//  PreviewView.swift
//  Instagram_Clone
//
//  Created by talha polat on 25.11.2023.
//

import UIKit
import Photos
class PhotoPreviewView: UIView {
    
    let btnCancel:UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "Fotograf_Iptal")?.withRenderingMode(.alwaysOriginal), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(nil, action: #selector(btnCancelClicked), for: .touchUpInside)
        return button
    }()
    
    let btnSave:UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "Fotograf_Kaydet")?.withRenderingMode(.alwaysOriginal), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(nil, action: #selector(btnSaveClicked), for: .touchUpInside)
        return button
    }()
    let imgView:UIImageView = {
        let imgView = UIImageView()
        imgView.translatesAutoresizingMaskIntoConstraints = false
        return imgView
    }()

    @objc func btnCancelClicked(){
        self.removeFromSuperview()
    }
    @objc func btnSaveClicked(){
        let library = PHPhotoLibrary.shared()
        guard let photo = imgView.image else{return}
        library.performChanges {
            PHAssetChangeRequest.creationRequestForAsset(from: photo)
        } completionHandler: { result, error in
            if let error = error{
                print("An error occured when save the photo: ",error.localizedDescription)
            }
           print("The save photo proccess is succesfull")
            DispatchQueue.main.async {
                let label = UILabel()
                label.text = "The save photo proccess is succesfull"
                label.font = UIFont.boldSystemFont(ofSize: 17)
                label.numberOfLines = 0
                label.frame = CGRect(x: 0, y: 0, width: 200, height: 120)
                label.backgroundColor = UIColor(white: 0, alpha: 0.3)
                label.center = self.center
                label.textAlignment = .center
                label.layer.transform = CATransform3DMakeScale(0, 0, 0)
                self.addSubview(label)
                
                UIView.animate(withDuration: 0.6, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5 ,animations: {
                    label.layer.transform = CATransform3DMakeScale(1, 1, 1)
                }){
                    result in
                    
                    UIView.animate(withDuration: 0.6, delay: 0.6, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, animations: {
                        label.layer.transform = CATransform3DMakeScale(0.1,0.1,0.1)
                    }){
                        result in
                        label.removeFromSuperview()
                    }
                }
                
            }
            
        }

        
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }
    
    private func configureUI(){
        addSubview(imgView)
        addSubview(btnSave)
        addSubview(btnCancel)
        allignButtons()
    }
    private func allignButtons(){
        let imgViewConstraints = [
            imgView.leadingAnchor.constraint(equalTo: leadingAnchor),
            imgView.trailingAnchor.constraint(equalTo: trailingAnchor),
            imgView.bottomAnchor.constraint(equalTo: bottomAnchor),
            imgView.topAnchor.constraint(equalTo: topAnchor)
        
        ]
        let btnSaveConstraints = [
            btnCancel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 25),
            btnCancel.topAnchor.constraint(equalTo: topAnchor, constant: 35)
        ]
        let btnCancelConstraints = [
            btnSave.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -45),
            btnSave.leadingAnchor.constraint(equalTo: leadingAnchor,constant: 25)
        ]
        NSLayoutConstraint.activate(imgViewConstraints)
        NSLayoutConstraint.activate(btnSaveConstraints)
        NSLayoutConstraint.activate(btnCancelConstraints)
        
        
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
