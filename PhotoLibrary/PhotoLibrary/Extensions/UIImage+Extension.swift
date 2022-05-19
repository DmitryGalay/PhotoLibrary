//
//  Extension+UIImageView.swift
//  PhotoLibrary
//
//  Created by Dima on 16.05.22.
//

import Foundation
import UIKit

var imageToCache = NSCache<NSString,UIImage>()

extension UIImageView {
    
    func loadImagesWithCache(_ urlString: String, completion: @escaping ()->()) {
        
        self.image = nil
        
        if let  cacheImage = imageToCache.object(forKey: NSString(string: urlString)){
            self.image = cacheImage
        }
        guard let url = URL(string: urlString) else{return}
        URLSession.shared.dataTask(with: url) { data, _, error in
            
            DispatchQueue.main.sync {
                completion()
            }
            
            if let error = error {
                print(error)
            }
            
            if let data = data, let downloadImage = UIImage(data: data) {
                DispatchQueue.main.async {
                    self.image = downloadImage
                    imageToCache.setObject(downloadImage, forKey: NSString(string: urlString))
                }
            }
        }.resume()
    }
}
