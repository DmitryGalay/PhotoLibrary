//
//  Extension+UIImageView.swift
//  PhotoLibrary
//
//  Created by Dima on 16.05.22.
//

import Foundation
import UIKit

extension UIImageView {
    func downloaded(from url: URL, contentMode mode: UIView.ContentMode = .scaleToFill,
                    completion: @escaping ()->()) {
        contentMode = mode
        URLSession.shared.dataTask(with: url) { data, response, error in
            
            DispatchQueue.main.async() { [weak self] in
                completion()
            }
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil,
                let image = UIImage(data: data)
            else {
                return }
            DispatchQueue.main.async() { [weak self] in
                self?.image = image
            }
        }.resume()
    }
    
    func downloaded(from link: String, contentMode mode: UIView.ContentMode = .scaleAspectFit,
                    completion: @escaping()->()) {
        guard let url = URL(string: link) else { return }
        downloaded(from: url, contentMode: mode,
                   completion: completion)
    }
}

