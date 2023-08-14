//
//  UserPreviewCell.swift
//  Link-Me
//
//  Created by Breadfast on 06/08/2023.
//

import UIKit
import AnimatedCollectionViewLayout

class UserPreviewCell: UICollectionViewCell {
    
    @IBOutlet weak var storyPreviewCollV: UICollectionView!
    
    var currentStory: Int = 0
    var stories: [UIImage] = []{
        didSet{
            storyPreviewCollV.reloadData()
        }
    }

    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupView()
        setupStoriesCollV()
    }
    
    private func setupView(){
        storyPreviewCollV.isScrollEnabled = false
    }
    
    private func setupStoriesCollV(){
        self.storyPreviewCollV.delegate = self
        self.storyPreviewCollV.dataSource = self
        storyPreviewCollV.registerNIB(StoryPreviewCell.self)
    }
    
    private func CrossFadeAnimationCollectionView(){
        let layout = AnimatedCollectionViewLayout()
        layout.animator = CrossFadeAttributesAnimator()
        //CubeAttributesAnimator()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0.0
        layout.minimumInteritemSpacing = 0.0
        layout.sectionInset = UIEdgeInsets(top: 0.0, left: 0.0, bottom: 0.0, right: 0.0)
        storyPreviewCollV.collectionViewLayout = layout
    }
    
  
    
}

//MARK: - storyPreviewCollV Configuration -

extension UserPreviewCell: UICollectionViewDelegate,UICollectionViewDataSource, UICollectionViewDelegateFlowLayout , UIScrollViewDelegate{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        self.stories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeue(cell: StoryPreviewCell.self, for: indexPath)
        cell.imageView_iv.image = self.stories[indexPath.row]
        
        
        cell.nextStory = { [weak self] in
            guard let self = self else {return}
            if self.currentStory == self.stories.count - 1{

            }else{
                self.currentStory += 1
                print("currentStory: \(self.currentStory)")
                let indexPath = IndexPath.init(row: self.currentStory, section: 0)
                self.storyPreviewCollV.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: false)
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
                self.storyPreviewCollV.reloadData()
            }
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return collectionView.bounds.size
    }
    
   
}
