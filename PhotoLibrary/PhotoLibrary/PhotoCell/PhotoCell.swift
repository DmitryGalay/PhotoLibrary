//
//  PhotoCell.swift
//  PhotoLibrary
//
//  Created by Dima on 16.05.22.
//

import UIKit

class PhotoCell: UICollectionViewCell {
    
    @IBOutlet weak var mainImageView: UIImageView!
    
    @IBOutlet weak var userName: UILabel!
    
    @IBOutlet weak var photoUrl: UIButton!
    
    @IBOutlet weak var userUrl: UIButton!
    
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    var imageOffset:CGPoint!
    
    var image:UIImage!{
        get{
            return self.image
        }
        set{
            self.mainImageView.image = newValue
            if imageOffset != nil{
                setImageOffset(imageOffset: imageOffset)
            }else{
                setImageOffset(imageOffset: CGPoint(x: 0, y: 0))
            }
        }
    }

    override var reuseIdentifier: String? {
        return "PhotoCell"
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        clipsToBounds = false
        addShadow()
    }
    
    func setImageOffset(imageOffset:CGPoint) {
        self.imageOffset = imageOffset
        let frame:CGRect = mainImageView.bounds
        let offsetFrame:CGRect = frame.offsetBy(dx: self.imageOffset.x, dy: self.imageOffset.y)
        mainImageView.frame = offsetFrame
    }
}
