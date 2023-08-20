//
//  StoryPreviewVC.swift
//  Link-Me
//
//  Created by Al-attar on 20/07/2023.
//

import UIKit
import AnimatedCollectionViewLayout
import SGSegmentedProgressBarLibrary


class StoryPreviewVC: BaseWireFrame<MainStoriesViewModel>, UIScrollViewDelegate {
    
    @IBOutlet weak var userPreviewCollV: UICollectionView!
    
    var indexPath: Int = 0
    var currentStory: Int = 0
    var currentUser: Int = 0
    var previousContentOffset: CGFloat = 0.0
    var isScrolled: Bool = false
    var segmentbar: SGSegmentedProgressBar!
    
    
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
        viewModel.storiesData.bind(to: userPreviewCollV.rx.items(cellIdentifier: String(describing: UserPreviewCell.self), cellType: UserPreviewCell.self)){ (row,item,cell) in
            
            cell.stories.accept(item.stories)
            
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
            
        }.disposed(by: disposeBag)
        
        
        userPreviewCollV.rx
            .willDisplayCell
            .subscribe(onNext: { cell, indexPath in
                let cell = cell as! UserPreviewCell
                cell.segmentbar.restart()
                cell.segmentbar.start()
            })
            .disposed(by: disposeBag)
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
        
        
        //uncomment for iPad Support
        //alert.popoverPresentationController?.sourceView = self.view
        
        self.present(alert, animated: true, completion: {
            print("completion block")
        })
    }
    
}



// MARK: - Collection View Configuration -

//UICollectionViewDelegate,UICollectionViewDataSource,
//extension StoryPreviewVC: UICollectionViewDelegate,UICollectionViewDataSource,  UICollectionViewDelegateFlowLayout{
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        self.viewModel.storiesData.value.count
//    }
//
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        let cell = collectionView.dequeue(cell: UserPreviewCell.self, for: indexPath)
//        cell.stories.accept(viewModel.storiesData.value[indexPath.row].stories)
//        print("viewModel.storiesData: \(indexPath.row)")
//        return cell
//    }
//
//    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
//        let cell = cell as? UserPreviewCell
//        cell?.stories.accept(viewModel.storiesData.value[self.indexPath].stories)
//    }
//
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        return collectionView.bounds.size
//    }
//
//    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
//        let currentOffset = (scrollView.contentOffset.x)
//
//        print("currentOffset: \(currentOffset)")
//        if currentOffset > previousContentOffset {
//            // Scrolling Right Increase ++
//            print("Scrolling Right Increase ++")
//            if self.indexPath == viewModel.storiesData.value.count - 1{
//               print("End of Increase ++ End of Sotries")
//            }else{
//                self.indexPath += 1
//                self.userPreviewCollV.reloadData()
//            }
//
//        } else if currentOffset < previousContentOffset {
//            // Scrolling Left Decrease --
//            print("Scrolling Left Decrease --")
//            if self.indexPath == 0{
//                print("End of Decrease -- End of Sotries")
//            }else{
//                self.indexPath -= 1
//                self.userPreviewCollV.reloadData()
//            }
//        }
//        previousContentOffset = currentOffset
//    }

//
//}
//
//
//
