//
//  ViewController.swift
//  PhotoLibrary
//
//  Created by Dima on 13.05.22.
//

import UIKit

typealias MainModel = [String: Strain]

enum ParseError: Error {
    case noKeyFound
}


struct OfferModel {
    let name: String
    let tinfo: Strain
}


struct Strain: Codable, Hashable {
//        let name: String!
    let photo_url: String
    let user_name: String
    let user_url: String
    let colors: [String]
//        init(dictionary: [String: Strain]) throws {
//            guard
//                let key = dictionary.keys.randomElement(),
//                let strain = dictionary[key] else { throw ParseError.noKeyFound }
//            name = key
//            photo_url = strain.photo_url
//            user_name = strain.user_name
//            user_url = strain.user_url
//            colors = strain.colors
//        }
}


class PhotoViewController: UIViewController,UICollectionViewDataSource{
    
  
    
    @IBOutlet weak var customCollectionView: UICollectionView!
    
    var massKeys = [String]()
    var massValue = [Strain]()
    var mainModel: MainModel!
    var strain: Strain?
    
    override func viewDidLoad() {
        
        getURL()
        
        customCollectionView.dataSource = self
        customCollectionView.backgroundColor = .gray
    }
    
    func getURl() {
        let url = URL(string: "https://dev.bgsoft.biz/task/credits.json")
        URLSession.shared.dataTask(with: url!) { [self] (data, response, error) in
            if error == nil {
                do {
                    let new = try JSONDecoder().decode(MainModel.self, from: data!)
                    print(new)
                } catch {
                    print(error)
                }
//                DispatchQueue.main.async {
//
//                    self.collectionView.reloadData()
//                }
            }
        }.resume()
    }
    
    
    func getURL() {
        let url = URL(string: "https://dev.bgsoft.biz/task/credits.json")
        var request = URLRequest(url:url!)
        request.httpMethod = "GET"
        let task = URLSession(configuration: .default)
        task.dataTask(with: request) { [self](data,response, error) in
            if error == nil {
                let decoder = JSONDecoder()
                var decoderModel: MainModel?
                if data != nil {
                    decoderModel = try? decoder.decode(MainModel.self, from: data!)
                }

                
                mainModel = decoderModel

                
                massKeys = [String](decoderModel!.keys)
                print(massKeys)
                massValue = [Strain](decoderModel!.values)
                
                
                
                

            }else {
                print(error as Any)
            }
        }.resume()
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return massKeys.count
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoCell", for: indexPath) as! PhotoCell
//        cell.mainImageView.contentMode = .scaleAspectFill
        cell.backgroundColor = .yellow
        let sortedDict = mainModel.sorted{( $0.value.user_name) < ($1.value.user_name) }
        print(sortedDict)
//
        let new = sortedDict[indexPath.item].key
        print(new)
//        let news = sortedDict
        
        
        
        cell.userName.text = "user_name:\(String(describing: mainModel[new]!.user_name ))"
        cell.userUrl.text = "user_url:\(String(describing: mainModel[new]!.user_url ))"
        cell.photoUrl.text = "photo_url:\(String(describing: mainModel[new]!.photo_url ))"
//
//        print("--------------------\(sortedDict)")
        cell.mainImageView.downloaded(from: "https://dev.bgsoft.biz/task/\(new).jpg"
                                    , completion: {})
        
        return cell
    }
}
    
    
//extension PhotoViewController: UICollectionViewDelegateFlowLayout {
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        return CGSize(width: collectionView.frame.width - 10, height: collectionView.frame.height / 1.58)
//    }
//
//}

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



