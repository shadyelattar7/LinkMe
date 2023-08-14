//
//  StoryPreviewVC.swift
//  Link-Me
//
//  Created by Al-attar on 20/07/2023.
//

import UIKit
import AnimatedCollectionViewLayout



class StoryPreviewVC: BaseWireFrame<MainStoriesViewModel>, UIScrollViewDelegate {

    @IBOutlet weak var userPreviewCollV: UICollectionView!
    
    var indexPath: Int = 0
    var currentStory: Int = 0
    var currentUser: Int = 0
    var previousContentOffset: CGFloat = 0.0

    
    override func bind(viewModel: MainStoriesViewModel) {
        setupView()
        setupStoriesCollV()
        CubeAnimationCollectionView()
    }

    private func setupView(){
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
    
    private func setupStoriesCollV(){
        self.userPreviewCollV.delegate = self
        self.userPreviewCollV.dataSource = self
        userPreviewCollV.registerNIB(UserPreviewCell.self)
    }
 
}

extension StoryPreviewVC: UICollectionViewDelegate,UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        self.viewModel.storiesData.value.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeue(cell: UserPreviewCell.self, for: indexPath)
 
        print("IndexPath: \(self.indexPath)")
        print("Data: \(viewModel.storiesData.value[self.indexPath].name)")
        
        cell.stories = viewModel.storiesData.value[self.indexPath].stories
        
        
        
//        cell.nextUser = { [weak self] in
//            guard let self = self else {return}
//            self.currentUser = self.indexPath
//            if self.currentUser == self.viewModel.storiesData.value.count - 1{
//
//            }else{
//                self.currentUser += 1
//
//                print("Name: \(self.viewModel.storiesData.value[self.currentUser].name)")
//
////                let indexPath = IndexPath.init(row: self.currentUser, section: 0)
////                self.storyPreviewCollV.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
//            }
//
//        }
//
//        cell.previousUser = { [weak self] in
//            guard let self = self else {return}
//
//        }
        
        
        return cell
    }

    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return collectionView.bounds.size
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let currentOffset = (scrollView.contentOffset.x)
   
        print("currentOffset: \(currentOffset)")
        if currentOffset > previousContentOffset {
            // Scrolling Right Increase ++
            print("Scrolling Right Increase ++")
            if self.indexPath == viewModel.storiesData.value.count - 1{
               print("End of Increase ++ End of Sotries")
            }else{
                self.indexPath += 1
                self.userPreviewCollV.reloadData()
            }
            
        } else if currentOffset < previousContentOffset {
            // Scrolling Left Decrease --
            print("Scrolling Left Decrease --")
            if self.indexPath == 0{
                print("End of Decrease -- End of Sotries")
            }else{
                self.indexPath -= 1
                self.userPreviewCollV.reloadData()
            }
        }
        previousContentOffset = currentOffset
    }
    

}
