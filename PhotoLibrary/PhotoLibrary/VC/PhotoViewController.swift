//
//  ViewController.swift
//  PhotoLibrary
//
//  Created by Dima on 13.05.22.
//

import UIKit

class PhotoViewController: UIViewController {
    
    @IBOutlet weak var customCollectionView: UICollectionView!
    
    var dataIsReady: Bool = false
    var pictureModel: PictureModel?
    var mainModel: MainModel!
    var tapPhotoUrl : String?
    var tapUserUrl: String?
    var scrolingtimer = Timer()
    var noTouch: Bool = true
    var picture = [PictureModel]()
    
    
    override func viewDidLoad() {
        config()
    }
    
    func config() {
        getNetwork()
        collectionSettings()
    }
    
    func collectionSettings() {
        customCollectionView.dataSource = self
        customCollectionView.delegate = self
        customCollectionView.register(UINib(nibName: "PhotoCell", bundle: nil), forCellWithReuseIdentifier: "PhotoCell")
        customCollectionView.collectionViewLayout = CollectionViewFlowLayout(itemSize: PhotoCell.cellSize);
        customCollectionView.decelerationRate = UIScrollView.DecelerationRate.normal
    }
}

// MARK : - dataSourse

extension PhotoViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if dataIsReady {
            return self.picture.count
        }else {
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoCell", for: indexPath) as? PhotoCell else { return UICollectionViewCell() }
        configureCell(cell: cell, for: indexPath)
        cell.changeToTopCell(with: collectionView)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let selectedCell = collectionView.cellForItem(at: indexPath)! as! PhotoCell
        tapUserUrl = picture[indexPath.item].user_url
        tapPhotoUrl = picture[indexPath.item].photo_url
        selectedCell.toggle()
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
            let pageFloat = (scrollView.contentOffset.x / scrollView.frame.size.width)
            let pageInt = Int(round(pageFloat))
        
            switch pageInt {
            case 0:
                customCollectionView.scrollToItem(at: [0, picture.count - 1], at:.left, animated: false)
            case picture.count - 1:
                customCollectionView.scrollToItem(at: [0, 0], at: .right, animated: true)
            default:
                break
            }
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
// MARK : - scroll

extension PhotoViewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        // MARK : - paralax Effect
        
        for view in customCollectionView.visibleCells{
            let view:PhotoCell = view as! PhotoCell
            let yOffset:CGFloat = ((customCollectionView.contentOffset.x - view.frame.origin.x) / 12)
            view.setImageOffset(imageOffset: CGPoint(x: yOffset, y: 0))
        }
    }
}
// MARK : - private func

private extension PhotoViewController {
    
    func getNetwork() {
        
        NetworkService.shared.getURL(result: { (model) in
            if model != nil {
                
                self.dataIsReady = true
                self.mainModel = model
                let array = Array(model!.map{ $0 })
                for model in array {
                    guard let id = model.key as? String,
                          let user_name = model.value.user_name as? String,
                          let user_url = model.value.user_url as? String,
                          let colors = model.value.colors as? [String],
                          let photo_url = model.value.photo_url as? String
                    else {
                        print("Something is not well")
                        continue
                    }
                    let object = PictureModel(id:id,photo_url: photo_url,user_name: user_name,user_url:user_url, colors: colors)
                    self.picture.append(object)
                    self.picture = self.picture.sorted{($0.user_name) < ($1.user_name)}
                }
            }
            DispatchQueue.main.async {
                self.customCollectionView.reloadData()
            }
        })
    }
    
    // MARK : - cell settings
    
    func settingsForCell(cell: PhotoCell) {
        
        cell.backgroundColor = .clear
        cell.mainImageView.image = nil
        cell.mainImageView.layer.cornerRadius = 25
        cell.userName.textColor = .white
        cell.photoUrl.setTitle("Photo_url", for: .normal)
        cell.photoUrl.tintColor = .white
        cell.userUrl.setTitle("User_url", for: .normal)
        cell.userUrl.tintColor = .white
        cell.addShadow()
        cell.mainImageView.contentMode = .scaleAspectFill

    }
    
    func configureCell(cell: PhotoCell, for indexPath: IndexPath) {
        
        let path = picture[indexPath.row ]
        let ImageUrl = "https://dev.bgsoft.biz/task/\(path.id).jpg"
        let yOffset:CGFloat = ((customCollectionView.contentOffset.x - view.frame.origin.x) / 12)
        cell.userName.text = "\(String(describing: path.user_name ))"
        cell.spinner.startAnimating()
        cell.mainImageView.loadImagesWithCache(ImageUrl, completion: {
            cell.spinner.stopAnimating()
            cell.spinner.hidesWhenStopped = true
        })
            self.settingsForCell(cell: cell)
        cell.imageOffset = CGPoint(x: 0, y: yOffset)
        cell.photoUrl.addTarget(self, action:  #selector(connectedPhoto(sender:)), for: UIControl.Event.touchUpInside)
        cell.userUrl.addTarget(self, action:  #selector(connectedUser(sender:)), for: UIControl.Event.touchUpInside)
    }
    
    // MARK : - timer
    
    @objc func startTimer(theTimer: Timer) {
        
        UIView.animate(withDuration: 10.0, delay: 0, options: .curveEaseOut) {
            self.customCollectionView.scrollToItem(at: IndexPath(row: theTimer.userInfo! as! Int, section: 0), at: .centeredHorizontally, animated: true)
        }
    }
    
    // MARK : - move to webVC for links
    
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
    
    // MARK : - autoscroll
    
    func autoScrolling(indexPath: IndexPath) {
        if noTouch {
            var rowIndex = indexPath.row
            let number = self.mainModel.count - 1
            if rowIndex < number {
                rowIndex = rowIndex + 1
            } else {
                rowIndex = 0
            }
            scrolingtimer = Timer.scheduledTimer(timeInterval: 5.0, target: self, selector: #selector(startTimer), userInfo: rowIndex, repeats: false)
        }
    }
}
