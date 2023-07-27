//
//  StoryPreviewVC.swift
//  Link-Me
//
//  Created by Al-attar on 20/07/2023.
//

import UIKit
import AnimatedCollectionViewLayout



class StoryPreviewVC: BaseWireFrame<MainStoriesViewModel>, UIScrollViewDelegate {

    @IBOutlet weak var storyPreviewCollV: UICollectionView!
    
    var isGoNextOrBackClicked: Bool = false
    var stories: [UIImage] = []
    
    override func bind(viewModel: MainStoriesViewModel) {
        setupView()
        setupStoriesCollV()
    }

    private func setupView(){
        let layout = AnimatedCollectionViewLayout()
        layout.animator = CrossFadeAttributesAnimator()
        //CubeAttributesAnimator()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0.0
        layout.minimumInteritemSpacing = 0.0
        layout.sectionInset = UIEdgeInsets(top: 0.0, left: 0.0, bottom: 0.0, right: 0.0)
        storyPreviewCollV.collectionViewLayout = layout

    }
    
    private func setupStoriesCollV(){
        self.storyPreviewCollV.delegate = self
        self.storyPreviewCollV.dataSource = self
        storyPreviewCollV.registerNIB(StoryPreviewCell.self)
//        storyPreviewCollV.rx.setDelegate(self).disposed(by: disposeBag)
//        viewModel.stories.bind(to: storyPreviewCollV.rx.items(cellIdentifier: String(describing: StoryPreviewCell.self), cellType: StoryPreviewCell.self)){ (row,item,cell) in
//
//
//            cell.imageView_iv.image = item
//
//            cell.goNext = { [weak self] in
//                guard let self = self else {return}
//                print("index: \(row)")
//                self.isGoNextOrBackClicked = true
//
////                guard let visibleIndexPath = self.storyPreviewCollV.indexPathsForVisibleItems.first else {
////                    return
////                }
////
////                let nextItem = visibleIndexPath.item + 1
////                let nextIndexPath = IndexPath(item: nextItem, section: visibleIndexPath.section)
////
////                // Scroll to the next cell with animation
////                self.storyPreviewCollV.scrollToItem(at: nextIndexPath, at: .centeredHorizontally, animated: true)
//            }
//
//        }.disposed(by: disposeBag)
        
    }
 
}

extension StoryPreviewVC: UICollectionViewDelegate,UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        stories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeue(cell: StoryPreviewCell.self, for: indexPath)
        cell.imageView_iv.image = stories[indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return collectionView.bounds.size
    }
}
