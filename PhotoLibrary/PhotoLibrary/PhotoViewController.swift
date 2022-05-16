//
//  ViewController.swift
//  PhotoLibrary
//
//  Created by Dima on 13.05.22.
//

import UIKit


class PhotoViewController: UIViewController, UICollectionViewDelegate {
    
    @IBOutlet weak var customCollectionView: UICollectionView!
    
    var  dataIsReady: Bool = false
    var massKeys = [String]()
    var massValue = [Strain]()
    var mainModel: MainModel!
    var strain: Strain?
    var tapPhotoUrl : String?
    var tapUserUrl: String?
    
    
    
    override func viewDidLoad() {
        getNetwork()
        
        
        customCollectionView.dataSource = self
        customCollectionView.delegate = self
        customCollectionView.register(UINib(nibName: "PhotoCell", bundle: nil), forCellWithReuseIdentifier: "PhotoCell")
    }
    
    func getNetwork() {
        NetworkService.shared.getURL(result: { (model) in
            if model != nil {
                DispatchQueue.main.async {
                    self.customCollectionView.reloadData()
                }
                self.dataIsReady = true
                self.mainModel = model
            }
        })
    }
    
    
    
    private func configureCell(cell: PhotoCell, for indexPath: IndexPath) {
      
//        cell.mainImageView.contentMode = .scaleToFill
//        cell.mainImageView.contentMode = .scaleAspectFit
//        cell.mainImageView.contentMode = .scaleAspectFill
//        cell.backgroundColor = .lightGray
        
        cell.addRadius(amount: 25, withBorderAmount: 1, andColor: .clear)
        cell.addShadow()
        let sortedKey = mainModel.sorted{($0.value.user_name) < ($1.value.user_name)}[indexPath.row].key
//        print(indexPath.row)
//        print(sortedKey)
        cell.userName.text = "\(String(describing: mainModel[sortedKey]!.user_name ))"
        cell.userName.textColor = .black
        cell.photoUrl.setTitle("Photo_url", for: .normal)
        cell.photoUrl.tintColor = .red
        cell.userUrl.setTitle("User_url", for: .normal)
        cell.userUrl.tintColor = .red
        cell.photoUrl.addTarget(self, action:  #selector(connectedPhoto(sender:)), for: UIControl.Event.touchUpInside)
        cell.userUrl.addTarget(self, action:  #selector(connectedUser(sender:)), for: UIControl.Event.touchUpInside)
        
        
        cell.mainImageView.image = nil
        cell.backgroundColor = UIColor(white: 0,alpha: 0.15)
        cell.spinner.startAnimating()
        DispatchQueue.main.async { [self] in
            tapPhotoUrl = "\(String(describing: mainModel[sortedKey]!.photo_url))"
            tapUserUrl = "\(String(describing: mainModel[sortedKey]!.user_url ))"
            
//            = UIImage(named: "Parallax \(indexPath.row + 1)")
            
            let new: () =  cell.mainImageView.downloaded(from: "https://dev.bgsoft.biz/task/\(sortedKey).jpg"
                                          ,completion: {
                
               
                cell.spinner.stopAnimating()
                cell.spinner.hidesWhenStopped = true
            })
            
            cell.mainImageView.image = UIImage(named: "\(new)")

//            cell.mainImageView.contentMode = .scaleAspectFit
            cell.mainImageView.contentMode = .scaleAspectFill
            cell.mainImageView.addRadius(amount: 25, withBorderAmount: 1, andColor: .clear)
            
            
        }
    }
    
    @objc func connectedPhoto(sender: UIButton!) {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let editScreen = storyboard.instantiateViewController(withIdentifier:
                                                                "WebViewController") as! WebViewController
        editScreen.text = tapPhotoUrl!
        self.present(editScreen, animated: true, completion: nil)
    }
    
    @objc func connectedUser(sender: UIButton!) {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let editScreen = storyboard.instantiateViewController(withIdentifier:
                                                                "WebViewController") as! WebViewController
        editScreen.text = tapUserUrl!
        self.present(editScreen, animated: true, completion: nil)
    }
    
    
}
extension PhotoViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if dataIsReady {
            return self.mainModel.count - 1
        }else {
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoCell", for: indexPath) as? PhotoCell else { return UICollectionViewCell() }
        configureCell(cell: cell, for: indexPath)
        
        return cell
    }
}

extension PhotoViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        40
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: collectionView.frame.width - 40 , height: collectionView.frame.height - 50)
        
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
    }
}
