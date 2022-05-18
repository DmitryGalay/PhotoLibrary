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
    var scrolingtimer = Timer()
    
    override func viewDidLoad() {
        getNetwork()

        customCollectionView.dataSource = self
        customCollectionView.delegate = self
        customCollectionView.register(UINib(nibName: "PhotoCell", bundle: nil), forCellWithReuseIdentifier: "PhotoCell")
        
        customCollectionView.collectionViewLayout = CollectionViewFlowLayout(itemSize: PhotoCell.cellSize);
        customCollectionView.decelerationRate = UIScrollView.DecelerationRate.fast
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
      
        cell.addRadius(amount: 25, withBorderAmount: 1, andColor: .clear)
//        cell.addShadow()
        let sortedKey = mainModel.sorted{($0.value.user_name) < ($1.value.user_name)}[indexPath.row].key

        cell.userName.text = "\(String(describing: mainModel[sortedKey]!.user_name ))"
        cell.userName.textColor = .black
        cell.photoUrl.setTitle("Photo_url", for: .normal)
        cell.photoUrl.tintColor = .red
        cell.userUrl.setTitle("User_url", for: .normal)
        cell.userUrl.tintColor = .red
        cell.photoUrl.addTarget(self, action:  #selector(connectedPhoto(sender:)), for: UIControl.Event.touchUpInside)
        cell.userUrl.addTarget(self, action:  #selector(connectedUser(sender:)), for: UIControl.Event.touchUpInside)
        cell.clipsToBounds = true
        
        cell.mainImageView.image = nil
        cell.backgroundColor = .clear
        cell.spinner.startAnimating()
        DispatchQueue.main.async { [self] in
            tapPhotoUrl = "\(String(describing: mainModel[sortedKey]!.photo_url))"
            tapUserUrl = "\(String(describing: mainModel[sortedKey]!.user_url ))"
            let new: () =  cell.mainImageView.downloaded(from: "https://dev.bgsoft.biz/task/\(sortedKey).jpg"
                                          ,completion: {
                
               
                cell.spinner.stopAnimating()
                cell.spinner.hidesWhenStopped = true
            })
            
            cell.mainImageView.image = UIImage(named: "\(new)")
            
            let yOffset:CGFloat = ((customCollectionView.contentOffset.x - view.frame.origin.x) / 12)
            cell.imageOffset = CGPoint(x: 0, y: yOffset)
            cell.addShadow()
            cell.mainImageView.contentMode = .scaleAspectFill
//            cell.mainImageView.contentMode = .scaleAspectFit
//            cell.mainImageView.addRadius(amount: 25, withBorderAmount: 1, andColor: .clear)
        }
            var rowIndex = indexPath.row
                        let number = self.mainModel.count - 1
            
                        if rowIndex < number {
                            rowIndex = rowIndex + 1
                        } else {
                            rowIndex = 0
                        }
            
                        scrolingtimer = Timer.scheduledTimer(timeInterval: 5.0, target: self, selector: #selector(startTimer), userInfo: rowIndex, repeats: true)
            
            
            
            
        }
    
    @objc func startTimer(theTimer: Timer) {
           UIView.animate(withDuration: 10.0, delay: 0, options: .curveEaseOut) {
               self.customCollectionView.scrollToItem(at: IndexPath(row: theTimer.userInfo! as! Int, section: 0), at: .centeredHorizontally, animated: true)
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
    
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        // MARK : - Add Paralax Effect
        
        for view in customCollectionView.visibleCells{
            let view:PhotoCell = view as! PhotoCell
           let yOffset:CGFloat = ((customCollectionView.contentOffset.x - view.frame.origin.x) / 12)
            view.setImageOffset(imageOffset: CGPoint(x: yOffset, y: 0))
          }
    }
    
}

extension PhotoViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if dataIsReady {
            return self.mainModel.count 
        }else {
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoCell", for: indexPath) as? PhotoCell else { return UICollectionViewCell() }
        configureCell(cell: cell, for: indexPath)
        cell.configure(with: collectionView, index: indexPath.row)
        
        return cell
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedCell = collectionView.cellForItem(at: indexPath)! as! PhotoCell
        selectedCell.toggle()
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

