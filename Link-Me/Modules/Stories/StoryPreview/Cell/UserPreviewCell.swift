//
//  UserPreviewCell.swift
//  Link-Me
//
//  Created by Breadfast on 06/08/2023.
//

import UIKit
import AnimatedCollectionViewLayout
import RxSwift
import RxCocoa
import SGSegmentedProgressBarLibrary
import IQKeyboardManagerSwift

class UserPreviewCell: UICollectionViewCell {
    
    //MARK: - @IBOutlet -
    
    @IBOutlet weak var storyPreviewCollV: UICollectionView!
    @IBOutlet weak var muteSoundBtn: UIButton!
    @IBOutlet weak var comment_tf: UITextField!
    @IBOutlet weak var keyboardHeightLayoutConstraint: NSLayoutConstraint!
    
    //MARK: - Properties -
    
    var currentStory: Int = 0
    var disposedBag = DisposeBag()
    var stories: BehaviorRelay<[Story]> = .init(value: [])
    var segmentbar: SGSegmentedProgressBar!
    var previousContentOffset: CGFloat = 0.0
    var closeBtn: (()->())?
    var moreMenuBtn: ((Int?)->())?
    var muteSound: (()->())?
    var likeBtn: (()->())?
    var segmentedProgressBarFinished: ((Bool)->())?
    var isDarg: Bool = false
    var storyCount: Int = 0
    var currentIndex: Int = 0
    private var storyID: Int?
    
    
    // MARK: - Life Cycle -
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupView()
        setupStoriesCollV()
        
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        disposedBag = DisposeBag()
        stories.accept([])
        self.contentView.subviews.forEach { view in
            if view == segmentbar{
                view.removeFromSuperview()
            }
        }
        
        setupStoriesCollV()
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.storyPreviewCollV.resizeItem(width: self.frame.size.width, height: self.frame.size.height)
    }
    
    

    
    
    //MARK: - Private Func -
    
    private func setupView(){
        IQKeyboardManager.shared.enable = false
        
        if "lang".localized == "en"{
            comment_tf.setLeftPaddingPoints(5)
        }else{
            comment_tf.setRightPaddingPoints(5)
        }
        
        comment_tf.attributedPlaceholder = NSAttributedString(
            string: "Write Comment ..",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.white]
        )
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.keyboardNotification(notification:)),
                                               name: UIResponder.keyboardWillChangeFrameNotification,
                                               object: nil)
        
        storyPreviewCollV.registerNIB(StoryPreviewCell.self)
        storyPreviewCollV.isScrollEnabled = false
        muteSoundBtn.isHidden = true
            
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
        IQKeyboardManager.shared.enable = true
    }
    
    @objc func keyboardNotification(notification: NSNotification) {
        guard let userInfo = notification.userInfo else { return }
        
        let endFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
        let endFrameY = endFrame?.origin.y ?? 0
        let duration:TimeInterval = (userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue ?? 0
        let animationCurveRawNSN = userInfo[UIResponder.keyboardAnimationCurveUserInfoKey] as? NSNumber
        let animationCurveRaw = animationCurveRawNSN?.uintValue ?? UIView.AnimationOptions.curveEaseInOut.rawValue
        let animationCurve:UIView.AnimationOptions = UIView.AnimationOptions(rawValue: animationCurveRaw)
        
        if endFrameY >= UIScreen.main.bounds.size.height {
            self.keyboardHeightLayoutConstraint?.constant = 30
        } else {
            self.keyboardHeightLayoutConstraint?.constant = (endFrame?.size.height ?? 0.0) + 10
        }
        
        UIView.animate(
            withDuration: duration,
            delay: TimeInterval(0),
            options: animationCurve,
            animations: { self.contentView.layoutIfNeeded() },
            completion: nil)
    }
    
    
    private func CrossFadeAnimationCollectionView(){
        let layout = AnimatedCollectionViewLayout()
        layout.animator = CrossFadeAttributesAnimator()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0.0
        layout.minimumInteritemSpacing = 0.0
        layout.sectionInset = UIEdgeInsets(top: 0.0, left: 0.0, bottom: 0.0, right: 0.0)
        storyPreviewCollV.collectionViewLayout = layout
    }
    
    
    func setupStoriesCollV(){
        
        storyPreviewCollV.rx.setDelegate(self).disposed(by: disposedBag)
                
        self.stories.bind(to: storyPreviewCollV.rx.items(cellIdentifier: String(describing: StoryPreviewCell.self), cellType: StoryPreviewCell.self)){ (row,item,cell) in
            
            cell.update(item)
            self.storyID = self.stories.value[row].id
            
            self.segmentbar.currentIndex = row
            
            cell.nextStory = { [weak self] in
                guard let self = self else {return}
                if self.currentStory == self.stories.value.count - 1{
                    print("no next story")
                }else{
                    self.currentStory += 1
                    print("currentStory: \(self.currentStory)")
                    let indexPath = IndexPath.init(row: self.currentStory, section: 0)
                    self.storyPreviewCollV.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: false)
                    self.segmentbar.nextSegment()
                    self.storyPreviewCollV.reloadData()
                }
            }
            
            
            cell.previousStory = { [weak self] in
                guard let self = self else {return}
                
                if self.currentStory == 0{
                    
                }else{
                    self.currentStory -= 1
                    let indexPath = IndexPath.init(row: self.currentStory, section: 0)
                    self.storyPreviewCollV.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: false)
                    self.segmentbar.previousSegment()
                    self.storyPreviewCollV.reloadData()
                }
            }
        }.disposed(by: disposedBag)
        
        
        
    }
    
    //MARK: - Actoins -
    
    @IBAction func closeTapped(_ sender: Any) {
        closeBtn?()
    }
    
    @IBAction func muteSoundTapped(_ sender: Any) {
        muteSound?()
    }
    
    @IBAction func moreMeunTapped(_ sender: Any) {
        moreMenuBtn?(storyID)
    }
    
    @IBAction func likeTapped(_ sender: Any) {
        likeBtn?()
    }
    
}

//MARK: - SGSegmented Progress Bar Library Configuration -
extension UserPreviewCell: SGSegmentedProgressBarDelegate, SGSegmentedProgressBarDataSource{
    func segmentedProgressBarFinished(finishedIndex: Int, isLastIndex: Bool) {
    
        
//        guard finishedIndex < stories.value.count - 1 else {
//            if storyCount == segmentbar.numberOfSegments {
//                print("Last segment reached")
//                self.segmentedProgressBarFinished?(true)
//            }
//            return
//        }
//        
//        if UDHelper.isDrag {
//            if finishedIndex != storyCount {
//                scrollToNextItemIfNeeded(at: finishedIndex + 1)
//            }
//            UDHelper.isDrag = false
//        } else {
//            self.segmentedProgressBarFinished?(true)
//            UDHelper.isDrag = false
//             scrollToNextItemIfNeeded(at: finishedIndex + 1)
//        }
        
        print("227 finishedIndex: \(finishedIndex),isLastIndex: \(isLastIndex) ")
        
        if finishedIndex != self.stories.value.count - 1{
            if UDHelper.isDrag{
                if finishedIndex != storyCount{
                    let indexPath = IndexPath.init(row: finishedIndex + 1, section: 0)
                    self.storyPreviewCollV.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: false)
                  //  self.storyPreviewCollV.reloadData()
                    UDHelper.isDrag = false
                }
            }else{
                let indexPath = IndexPath.init(row: finishedIndex + 1, section: 0)
                self.storyPreviewCollV.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: false)
              //  self.storyPreviewCollV.reloadData()
            }
        }else{
            if storyCount == segmentbar.numberOfSegments{
                print("is last ya basha")
                self.segmentedProgressBarFinished?(true)
            }
            print("number of segment: \(segmentbar.numberOfSegments)")
        }
        
        
    }
    
    private func scrollToNextItemIfNeeded(at index: Int) {
                let indexPath = IndexPath(row: index, section: 0)
                self.storyPreviewCollV.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: false)
                self.storyPreviewCollV.reloadData()
    }
    
    var numberOfSegments: Int {
        return stories.value.count
    }
    
    var segmentDuration: TimeInterval {
        return 5
    }
    
    var paddingBetweenSegments: CGFloat {
        return 3
    }
    
    var trackColor: UIColor {
        return UIColor.systemGray2.withAlphaComponent(0.2)
    }
    
    var progressColor: UIColor {
        return UIColor.systemGreen
    }
    
    var roundCornerType: SGSegmentedProgressBarLibrary.SGCornerType {
        return .roundCornerBar(cornerRadious: 2)
    }
}

extension UserPreviewCell: UIScrollViewDelegate{
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        self.currentIndex = Int(scrollView.contentOffset.x / storyPreviewCollV.frame.size.width)
        
        
    }
}

// this old version to solve segmentedProgressBarFinished
/*
 //        if finishedIndex != self.stories.value.count - 1{
 //            if UDHelper.isDrag{
 //                if finishedIndex != storyCount{
 //                    let indexPath = IndexPath.init(row: finishedIndex + 1, section: 0)
 //                    self.storyPreviewCollV.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: false)
 //                    self.storyPreviewCollV.reloadData()
 //                }
 //                UDHelper.isDrag = false
 //            }else{
 //                let indexPath = IndexPath.init(row: finishedIndex + 1, section: 0)
 //                self.storyPreviewCollV.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: false)
 //                self.storyPreviewCollV.reloadData()
 //            }
 //        }else{
 //            if storyCount == segmentbar.numberOfSegments{
 //                print("is last ya basha")
 //            }
 //            print("number of segment: \(segmentbar.numberOfSegments)")
 //        }
 */
