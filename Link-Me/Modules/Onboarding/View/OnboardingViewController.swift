//
//  OnboardingViewController.swift
//  Link-Me
//
//  Created by Al-attar on 10/05/2023.
//

import UIKit
import RxSwift
import RxCocoa

class OnboardingViewController: BaseWireFrame<OnboardingViewModel>, UIScrollViewDelegate {
    
    
    //MARK: - @IBOutlet
    
    @IBOutlet weak var onboardingCollectionView: UICollectionView!
    @IBOutlet weak var letGo_Btn: MainButton!
    
    
    //MARK: - Variables
    
    var currentPage = 0
    
    //MARK: Life Cylce
    
    override func viewDidLoad() {
        super.viewDidLoad()
        rgisterCell()
        setupOnboardingCollectionView()
        setupView()
    }
    
    // MARK: - Setup View
    private func setupView(){
        letGo_Btn.MainBtn.addTarget(self, action: #selector(letsGOTapped), for: .touchUpInside)
        
    }
    
    //MARK: - Func Bind
    
    override func bind(viewModel: OnboardingViewModel) {
        
    }
    
    //MARK: - Private Func
    
    private func rgisterCell(){
        //OnboardingCell
        onboardingCollectionView.registerNIB(OnboardingCell.self)
    }
    
    private func setupOnboardingCollectionView(){
        onboardingCollectionView.rx.setDelegate(self).disposed(by: disposeBag)
        
        viewModel.onboardingItem.bind(to: onboardingCollectionView.rx.items(cellIdentifier: String(describing: OnboardingCell.self), cellType: OnboardingCell.self)){ (row,item,cell) in
            cell.configure(item: item)
        }.disposed(by: disposeBag)
    }
    
    //MARK: - Let's Go button Tapped
    @objc func letsGOTapped(){
        if currentPage == viewModel.countOnboardingItems() - 1{
            print("Go To Auth")
             UDHelper.isAppOpenedBefor = true
            self.coordinator.Auth.navigate(for: .login)
        }else{
            currentPage += 1
            let indexPath = IndexPath.init(row: currentPage, section: 0)
            print("indexPath: \(indexPath)")
            if let cell = onboardingCollectionView.cellForItem(at: indexPath) as? OnboardingCell{
                cell.pageControl.currentPage = currentPage
            }
            onboardingCollectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
            
        }
    }
    
}


//MARK: - Slider Data Source
extension OnboardingViewController: UICollectionViewDelegate,UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        currentPage = Int(scrollView.contentOffset.x / onboardingCollectionView.frame.size.width)
        let indexPath = IndexPath.init(row: currentPage, section: 0)
        if let cell = onboardingCollectionView.cellForItem(at: indexPath) as? OnboardingCell{
            cell.pageControl.currentPage = currentPage
        }
        
    }
    
}
