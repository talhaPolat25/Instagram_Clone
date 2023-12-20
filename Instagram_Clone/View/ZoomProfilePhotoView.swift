//
//  ZoomProfilePhotoView.swift
//  Instagram_Clone
//
//  Created by talha polat on 16.12.2023.
//

import UIKit
import SDWebImage
class ZoomProfilePhotoView: UIView {

    let imageView:UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    let btnCancel:UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "Fotograf_Iptal")?.withRenderingMode(.alwaysOriginal), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(nil, action: #selector(btnCancelClicked), for: .touchUpInside)
        return button
    }()
    @objc func btnCancelClicked(){
        self.removeFromSuperview()
        
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
        imageView.layer.cornerRadius = 50
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate func CreateGradientLayer() {
                
                gradientLayer.colors = [
                    UIColor.darkGray.cgColor,
                    UIColor.black.cgColor,
                    UIColor.darkGray.cgColor
                ]
        
        layer.addSublayer(gradientLayer)
        
        gradientLayer.locations = [0.0, 0.7, 1.0]
        
    }
    
    private func configureUI(){
        
        CreateGradientLayer()
        
        addSubview(imageView)
        addSubview(btnCancel)
        layer.insertSublayer(btnCancel.layer, above: gradientLayer)
        layer.insertSublayer(imageView.layer, above: gradientLayer)
        setupConstraints()
        
        
        
    }
    let gradientLayer = CAGradientLayer()
           
    override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer.frame = bounds
    }
    private func setupConstraints(){
        let imgProfileConstraints = [
            imageView.centerXAnchor.constraint(equalTo:  centerXAnchor) ,
            imageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            imageView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.5),
            imageView.heightAnchor.constraint(equalTo: widthAnchor, multiplier: 0.5)
            
        ]
        let btnCancelConstraints = [
            btnCancel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 25),
            btnCancel.topAnchor.constraint(equalTo: topAnchor, constant: 45)
        ]
        NSLayoutConstraint.activate(btnCancelConstraints)
        NSLayoutConstraint.activate(imgProfileConstraints)
    }
    func setupProfilePhoto(url:String){
        guard let profilePhotoUrl = URL(string: url) else{return}
        imageView.sd_setImage(with: profilePhotoUrl)
        
    }
}
