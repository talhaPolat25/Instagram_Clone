//
//  InstagramStoryTableViewCell.swift
//  Instagram_Clone
//
//  Created by talha polat on 12.11.2023.
//

import UIKit

class InstagramStoryTableViewCell: UITableViewCell {

    static let identifier = "InstagramStoryTableViewCell"
    
    let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: 100, height: 100)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(InstagramStoryCVC.self, forCellWithReuseIdentifier: InstagramStoryCVC.identifier)
        return collectionView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(collectionView)
        collectionView.delegate = self
        collectionView.dataSource = self
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        collectionView.frame = contentView.bounds
    }
  /*  override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        addSubview(collectionView)
      
        collectionView.frame = bounds
        collectionView.delegate = self
        collectionView.dataSource = self
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }*/

}
extension InstagramStoryTableViewCell:UICollectionViewDelegate,UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: InstagramStoryCVC.identifier, for: indexPath) as? InstagramStoryCVC else{return UICollectionViewCell()}
       // cell.layer.cornerRadius = cell.frame.width / 2
       // cell.clipsToBounds = true
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        10
    }
    
}
