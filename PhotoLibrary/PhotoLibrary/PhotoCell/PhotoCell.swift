//
//  PhotoCell.swift
//  PhotoLibrary
//
//  Created by Dima on 16.05.22.
//

import UIKit

class PhotoCell: UICollectionViewCell {
    
    override var reuseIdentifier: String? {
        return "PhotoCell"
    }
    
    @IBOutlet weak var mainImageView: UIImageView!
    
    @IBOutlet weak var userName: UILabel!
    
    @IBOutlet weak var photoUrl: UIButton!
    
    @IBOutlet weak var userUrl: UIButton!
    
      
}
