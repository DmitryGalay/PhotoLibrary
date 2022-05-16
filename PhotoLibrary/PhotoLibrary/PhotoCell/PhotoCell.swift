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
    
    override func awakeFromNib() {
        super.awakeFromNib()
        addShadow()
    }
    
    @IBOutlet weak var mainImageView: UIImageView!
    
    @IBOutlet weak var userName: UILabel!
    
    @IBOutlet weak var photoUrl: UIButton!
    
    @IBOutlet weak var userUrl: UIButton!
    
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
}
