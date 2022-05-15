//
//  PhotoCell.swift
//  PhotoLibrary
//
//  Created by Dima on 13.05.22.
//

import UIKit

class PhotoCell: UICollectionViewCell {
    
    @IBOutlet weak var mainImageView: UIImageView!
    
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var photoUrl: UILabel!
    @IBOutlet weak var userUrl: UILabel!
    //    override func prepareForReuse() {
//        super.prepareForReuse()
//        mainImageView.image = nil
//    }
}
