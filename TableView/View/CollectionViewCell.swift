//
//  CollectionViewCell.swift
//  TableView
//
//  Created by Zeinab on 11/10/20.
//  Copyright © 2020 Zeinab. All rights reserved.
//

import UIKit
import SDWebImage

class CollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var image: UIImageView!
    static let collectionCell = "CollectionViewCell"
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configure(imageUrl: String) {
        image.sd_setImage(with: URL(string: imageUrl), placeholderImage: #imageLiteral(resourceName: "24f355"))
    }
    
    static func nibCollection() -> UINib {
        return UINib(nibName: collectionCell, bundle: nil)
    }

}
