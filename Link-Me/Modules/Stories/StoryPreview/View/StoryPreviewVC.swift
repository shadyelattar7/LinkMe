//
//  StoryPreviewVC.swift
//  Link-Me
//
//  Created by Al-attar on 20/07/2023.
//

import UIKit
import AnimatedCollectionViewLayout
import SGSegmentedProgressBarLibrary
import RxSwift
import RxCocoa

class StoryPreviewVC: BaseWireFrame<MainStoriesViewModel>, UIScrollViewDelegate {
    
    @IBOutlet weak var userPreviewCollV: UICollectionView!
    
    var indexPath: Int = 0
    var currentStory: Int = 0
    var currentUser: Int = 0
    var previousContentOffset: CGFloat = 0.0
    var isScrolled: Bool = false
    var segmentbar: SGSegmentedProgressBar!
    var indexpathRow = 0
    var myStoriesDate = BehaviorRelay<[UserStoryData]>(value: [])
    
    //MARK: - Life Cycle -
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        self.userPreviewCollV.resizeItem(width: self.view.frame.size.width, height: self.view.frame.size.height)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewWillLayoutSubviews()
        if !isScrolled{
            let index = IndexPath(row: self.indexPath, section: 0)
            userPreviewCollV.scrollToItem(at: index, at:  .centeredHorizontally, animated: false)
            isScrolled = true
        }
    }
    
    
    override func bind(viewModel: MainStoriesViewModel) {
        setupView()
        setupUserPreviewCollV()
        CubeAnimationCollectionView()
    }
    
    //MARK: - Private Func -
    
    private func setupView(){
        rgisterCell()
    }
    
    private func CubeAnimationCollectionView(){
        let layout = AnimatedCollectionViewLayout()
        layout.animator = CubeAttributesAnimator()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0.0
        layout.minimumInteritemSpacing = 0.0
        layout.sectionInset = UIEdgeInsets(top: 0.0, left: 0.0, bottom: 0.0, right: 0.0)
        userPreviewCollV.collectionViewLayout = layout
    }
    
    private func rgisterCell(){
        
        userPreviewCollV.registerNIB(UserPreviewCell.self)
    }
    
    private func setupUserPreviewCollV(){
        userPreviewCollV.rx.setDelegate(self).disposed(by: disposeBag)
        self.myStoriesDate.bind(to: userPreviewCollV.rx.items(cellIdentifier: String(describing: UserPreviewCell.self), cellType: UserPreviewCell.self)){ (row, item, cell) in
            
            guard let stories = self.myStoriesDate.value[row].stories else { return }
            cell.stories.accept(stories)
            cell.storyCount = stories.count
            
            let rect = CGRect(x: 10, y: 10, width: self.view.width - 20  , height: 3)
            cell.segmentbar = SGSegmentedProgressBar(frame: rect, delegate: cell.self, dataSource: cell.self)
            cell.contentView.addSubview(cell.segmentbar!)
            
            
            cell.closeBtn = { [weak self] in
                guard let self = self else {return}
                self.dismiss(animated: true)
            }
            
            cell.moreMenuBtn = { [weak self] in
                guard let self = self else {return}
                print("moreMenuBtn")
                self.showAlert()
            }
            
            cell.muteSound = { [weak self] in
                guard let self = self else {return}
                print("muteSound")
            }
            
            cell.segmentedProgressBarFinished = { [weak self] isFinished in
                guard let self = self else {return}
                if isFinished{
                    print("Finish all storeis: \(isFinished)")
                    if row == self.myStoriesDate.value.count - 1 {
                        print("End of Increase ++ End of Sotries")
                        self.dismiss(animated: true)
                    }else{
                        let index = IndexPath(row: row + 1, section: 0)
                        self.userPreviewCollV.scrollToItem(at: index, at:  .centeredHorizontally, animated: true)
                    }
                }
            }
            
        }.disposed(by: disposeBag)
        
        
        userPreviewCollV.rx
            .willDisplayCell
            .subscribe(onNext: { cell, indexPath in
                self.currentUser = indexPath.row
                print("122 indexPath: \(indexPath.row)")
                self.indexpathRow = indexPath.row
                let cell = cell as! UserPreviewCell
                if indexPath.row < 1{
                    self.dismiss(animated: true)
                }else{
                    cell.segmentbar.restartCurrentSegment()
                }
            }).disposed(by: disposeBag)
    }
    
    
    private func showAlert(){
        let alert = UIAlertController(title: "Title", message: "Please Select an Option", preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: "Approve", style: .default , handler:{ (UIAlertAction)in
            print("User click Approve button")
        }))
        
        alert.addAction(UIAlertAction(title: "Edit", style: .default , handler:{ (UIAlertAction)in
            print("User click Edit button")
        }))
        
        alert.addAction(UIAlertAction(title: "Delete", style: .destructive , handler:{ (UIAlertAction)in
            print("User click Delete button")
        }))
        
        alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler:{ (UIAlertAction)in
            print("User click Dismiss button")
        }))
        
        self.present(alert, animated: true, completion: {
            print("completion block")
        })
    }
    
}



// MARK: - Collection View Configuration -

extension StoryPreviewVC{
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        // Pause the segmented progress bar timer when dragging starts.
        if let cell = getCurrentVisibleCell() {
            cell.segmentbar.pause()
        }
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        // Calculate the progress made during manual dragging and update the segmented progress bar.
        if !decelerate, let cell = getCurrentVisibleCell() {
            let contentOffsetX = scrollView.contentOffset.x
            let cellWidth = cell.frame.width
            let progressPercentage = contentOffsetX / cellWidth
            cell.segmentbar.setProgressManually(index: cell.currentIndex, progressPercentage: progressPercentage)
        }
    }
    
    // Helper function to get the currently visible cell.
    private func getCurrentVisibleCell() -> UserPreviewCell? {
        let visibleRect = CGRect(origin: userPreviewCollV.contentOffset, size: userPreviewCollV.bounds.size)
        let visiblePoint = CGPoint(x: visibleRect.midX, y: visibleRect.midY)
        if let indexPath = userPreviewCollV.indexPathForItem(at: visiblePoint) {
            if let cell = userPreviewCollV.cellForItem(at: indexPath) as? UserPreviewCell {
                return cell
            }
        }
        return nil
    }
}

