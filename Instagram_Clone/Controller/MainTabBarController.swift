//
//  MainTabBarController.swift
//  Instagram_Clone
//
//  Created by talha polat on 3.11.2023.
//

import UIKit

class MainTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        delegate = self
       // tabBar.layer.borderColor = UIColor.white.cgColor
       // tabBar.layer.borderWidth = 1
        customizeTabBarAppearance()
    }
    
    private func customizeTabBarAppearance() {
        // Kenarlık (border) kalınlığı ve rengi
        let borderThickness: CGFloat = 1
        let borderColor = UIColor.darkGray// Kenarlık rengi
        
        // Tab bar üst kısmına kenarlık eklemek için aşağıdaki kodu kullanabilirsiniz
        let borderView = UIView()
        borderView.translatesAutoresizingMaskIntoConstraints = false
        borderView.backgroundColor = borderColor
        view.addSubview(borderView)
        
        let borderViewConstraints = [
            borderView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            borderView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            borderView.heightAnchor.constraint(equalToConstant: borderThickness),
            borderView.bottomAnchor.constraint(equalTo: tabBar.topAnchor)
        ]
        NSLayoutConstraint.activate(borderViewConstraints)
        
    }
}

extension MainTabBarController:UITabBarControllerDelegate{
    
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
       
        guard let index = viewControllers?.firstIndex(of: viewController) else{return false}
        if index == 2{
            guard let photoChoosingNVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "photoChoosingNVC") as? UINavigationController  else{return false}
           
            photoChoosingNVC.modalPresentationStyle = .fullScreen
            
            present(photoChoosingNVC, animated: true)
            return false
        }
        return true
    }
    
        
}
