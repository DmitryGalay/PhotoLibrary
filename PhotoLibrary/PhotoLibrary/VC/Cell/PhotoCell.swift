//
//  PhotoCell.swift
//  PhotoLibrary
//
//  Created by Dima on 16.05.22.
//

import UIKit





private enum State {
    case expanded
    case collapsed
    
    var change: State {
        switch self {
        case .expanded: return .collapsed
        case .collapsed: return .expanded
        }
    }
}










class PhotoCell: UICollectionViewCell,UIGestureRecognizerDelegate {
    
    @IBOutlet weak var mainImageView: UIImageView!
    
    @IBOutlet weak var userName: UILabel!
    
    @IBOutlet weak var photoUrl: UIButton!
    
    @IBOutlet weak var userUrl: UIButton!
    
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    static let cellSize = CGSize(width: 250, height: 350)
    
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
        self.addGestureRecognizer(panRecognizer)
    }
    
    func setImageOffset(imageOffset:CGPoint) {
        self.imageOffset = imageOffset
        let frame:CGRect = mainImageView.bounds
        let offsetFrame:CGRect = frame.offsetBy(dx: self.imageOffset.x, dy: self.imageOffset.y)
        mainImageView.frame = offsetFrame
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    private let popupOffset: CGFloat = (UIScreen.main.bounds.height - cellSize.height)/2.0
    
    
    private lazy var panRecognizer: UIPanGestureRecognizer = {
        let recognizer = UIPanGestureRecognizer()
        recognizer.addTarget(self, action: #selector(popupViewPanned(recognizer:)))
        recognizer.delegate = self
        
        return recognizer
        
    }()
    
    
    private var animationProgress: CGFloat = 0
    
    private var initialFrame: CGRect?
    
    private var state: State = .collapsed
    
    private lazy var animator: UIViewPropertyAnimator = {
        let cubicTiming = UICubicTimingParameters(controlPoint1: CGPoint(x: 0.17, y: 0.67), controlPoint2: CGPoint(x: 0.76, y: 1.0))
        
        return UIViewPropertyAnimator(duration: 0.3, timingParameters: cubicTiming)
    }()
    
    private var cornerRadius: CGFloat = 25
    
//    static let cellSize = CGSize(width: 250, height: 350)
    static let identifier = "CityCollectionViewCell"
    
    
    private var collectionView: UICollectionView?
    private var index: Int?
    
    func configure(with collectionView: UICollectionView, index: Int) {
      
        
        self.collectionView = collectionView
        self.index = index
    }
    
    

    
    
    @objc func popupViewPanned(recognizer: UIPanGestureRecognizer) {
        switch recognizer.state {
        case .began:
            
            toggle()
            animator.pauseAnimation()
            animationProgress = animator.fractionComplete
            
        case .changed:
            let translation = recognizer.translation(in: collectionView)
            var fraction = -translation.y / popupOffset
            if state == .expanded { fraction *= -1 }
            if animator.isReversed { fraction *= -1 }
            animator.fractionComplete = fraction + animationProgress
            
        case .ended:
            let velocity = recognizer.velocity(in: self)
            let shouldComplete = velocity.y > 0
            if velocity.y == 0 {
                animator.continueAnimation(withTimingParameters: nil, durationFactor: 0)
                break
            }
            switch state {
            case .expanded:
                if !shouldComplete && !animator.isReversed { animator.isReversed = !animator.isReversed }
                if shouldComplete && animator.isReversed { animator.isReversed = !animator.isReversed }
            case .collapsed:
                if shouldComplete && !animator.isReversed { animator.isReversed = !animator.isReversed }
                if !shouldComplete && animator.isReversed { animator.isReversed = !animator.isReversed }
            }
            animator.continueAnimation(withTimingParameters: nil, durationFactor: 0)
            
        default:
            ()
        }
    }
    
    
 
    
    func toggle() {
        switch state {
        case .expanded:
            collapse()
        case .collapsed:
            expand()
        }
    }

    private func expand() {
        guard let collectionView = self.collectionView, let index = self.index else { return }
        animator.addAnimations { [self] in
            self.initialFrame = self.frame

            self.frame = CGRect(x: collectionView.contentOffset.x, y:0 , width: collectionView.frame.width, height: collectionView.frame.height / 1.8)
            
            self.userName.frame = CGRect(x: collectionView.frame.midX  , y: collectionView.frame.height / 1.2, width: self.userName.frame.width, height: self.userName.frame.height)
            
            
            
            
            
//            self.photoUrl.frame = CGRect(x: collectionView.frame.width - 50 , y: collectionView.frame.minY + 50  , width: self.userName.frame.width, height: self.userName.frame.height)
//
//            self.userUrl.frame = CGRect(x: -collectionView.frame.width + 50 , y: collectionView.frame.minY + 50  , width: self.userName.frame.width, height: self.userName.frame.height)
            
            
            self.userUrl.alpha = 1
            self.userName.alpha = 1
            self.photoUrl.alpha = 1
            
            if let leftCell = collectionView.cellForItem(at: IndexPath(row: index - 1, section: 0)) {
                leftCell.center.x -= 50
            }
            
            if let rightCell = collectionView.cellForItem(at: IndexPath(row: index + 1, section: 0)) {
                rightCell.center.x += 50
            }
            
            self.layoutIfNeeded()
        }
        
        animator.addCompletion { position in
            switch position {
            case .end:
                self.state = self.state.change
                collectionView.isScrollEnabled = false
                collectionView.allowsSelection = false
            default:
                ()
            }
        }
        
        animator.startAnimation()
    }
    
    
    private func collapse() {
        guard let collectionView = self.collectionView, let index = self.index else { return }
        
        animator.addAnimations {
            
//
            self.userUrl.alpha = 0
            self.userName.alpha = 0
            self.photoUrl.alpha = 0
            
            self.layer.cornerRadius = self.cornerRadius
            self.frame = self.initialFrame!
            
            if let leftCell = collectionView.cellForItem(at: IndexPath(row: index - 1, section: 0)) {
                leftCell.center.x += 50
            }
            
            if let rightCell = collectionView.cellForItem(at: IndexPath(row: index + 1, section: 0)) {
                rightCell.center.x -= 50
            }
            
            self.layoutIfNeeded()
        }
        
        animator.addCompletion { position in
            switch position {
            case .end:
                self.state = self.state.change
                collectionView.isScrollEnabled = true
                collectionView.allowsSelection = true
            default:
                ()
            }
        }
        
        animator.startAnimation()
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    override func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return abs((panRecognizer.velocity(in: panRecognizer.view)).y) > abs((panRecognizer.velocity(in: panRecognizer.view)).x)
    }
}
    

