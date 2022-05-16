//
//  ViewController.swift
//  PhotoLibrary
//
//  Created by Dima on 13.05.22.
//

import UIKit


class PhotoViewController: UIViewController,UICollectionViewDataSource, UICollectionViewDelegate {
   
    @IBOutlet weak var customCollectionView: UICollectionView!
    
    var  dataIsReady: Bool = false
    var massKeys = [String]()
    var massValue = [Strain]()
    var mainModel: MainModel!
    var strain: Strain?
    var tapPhotoUrl : String?
    var tapUserUrl: String?

    
    override func viewDidLoad() {
//        customCollectionView.reloadData()
        getNetwork()

        
        customCollectionView.dataSource = self
        customCollectionView.delegate = self
        customCollectionView.backgroundColor = .yellow
        customCollectionView.register(UINib(nibName: "PhotoCell", bundle: nil), forCellWithReuseIdentifier: "PhotoCell")
    }
    
    func getNetwork() {
        NetworkService.shared.getURL(result: { (model) in
            if model != nil {
                self.dataIsReady = true
                self.mainModel = model
            }
        })
    }
    
    

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if dataIsReady {
            return self.mainModel.count
        }else {
            return 0
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoCell", for: indexPath) as! PhotoCell
        cell.mainImageView.contentMode = .scaleAspectFit
        cell.backgroundColor = .black
        let sortedDict = mainModel.sorted{( $0.value.user_name) < ($1.value.user_name) }
//        print(sortedDict)
//
        let new = sortedDict[indexPath.item].key
//        print(new)
//        let news = sortedDict
        
        
        
//        cell.userName.text = "user_name:\(String(describing: mainModel[new]!.user_name ))"
        
        cell.photoUrl.setTitle("Photo_url", for: .normal)
        cell.photoUrl.tintColor = .white
        cell.userUrl.setTitle("User_url", for: .normal)
        cell.userUrl.tintColor = .white
        cell.photoUrl.addTarget(self, action:  #selector(connectedPhoto(sender:)), for: UIControl.Event.touchUpInside)
        cell.userUrl.addTarget(self, action:  #selector(connectedUser(sender:)), for: UIControl.Event.touchUpInside)
//        userNameTextField.addTarget(self, action: #selector(LoginViewController.userCheck(textField:)), for: .editingChanged)
    
        tapPhotoUrl = "\(String(describing: mainModel[new]!.photo_url))"
        tapUserUrl = "\(String(describing: mainModel[new]!.user_url ))"
//        photoUrll = string
//        print(string)
//        print(photoUrll)
//        cell.userUrl.text = "\(String(describing: mainModel[new]!.user_url ))"
//        cell.photoUrl.text = "photo_url:\(String(describing: mainModel[new]!.photo_url ))"
//
//
        cell.mainImageView.downloaded(from: "https://dev.bgsoft.biz/task/\(new).jpg"
                                    , completion: {})
        
        return cell
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


    
extension PhotoViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width  , height: collectionView.frame.height)
    }

}
