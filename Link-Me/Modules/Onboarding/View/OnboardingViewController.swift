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
    //MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        registerCell()
        setupOnboardingCollectionView()
        setupView()
        initializeOnboarding()
    }
    private func initializeOnboarding() {
           // Ensure starting index is 0
           currentPage = 0
           viewModel.setCurrentPage(currentPage)
           let indexPath = IndexPath(row: currentPage, section: 0)
           onboardingCollectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: false)
           letGo_Btn.textTitle = "Next".localized
       }
    
    // MARK: - Setup View
    private func setupView(){
        letGo_Btn.MainBtn.addTarget(self, action: #selector(letsGOTapped), for: .touchUpInside)
    }
    
    //MARK: - Func Bind
    override func bind(viewModel: OnboardingViewModel) {
        // Any additional bindings can go here
    }
    
    //MARK: - Private Func
    private func registerCell(){
        onboardingCollectionView.registerNIB(OnboardingCell.self)
    }
    
    private func setupOnboardingCollectionView(){
        onboardingCollectionView.rx.setDelegate(self).disposed(by: disposeBag)
        
        viewModel.onboardingItem
            .bind(to: onboardingCollectionView.rx.items(cellIdentifier: String(describing: OnboardingCell.self), cellType: OnboardingCell.self)) { [weak self] (row, item, cell) in
                guard let self = self else { return }
                cell.configure(item: item)
                if row == self.currentPage {
                    cell.pageControl.currentPage = self.currentPage
                }
            }
            .disposed(by: disposeBag)
    }
    
    //MARK: - Let's Go button Tapped
    @objc func letsGOTapped(){
        if currentPage == viewModel.countOnboardingItems() - 1 {
            print("Go To Auth")
            UDHelper.isAppOpenedBefor = true
            self.coordinator.Auth.navigate(for: .login)
        } else {
            let nextPage = currentPage + 1
            setCurrentPage(nextPage)
            let indexPath = IndexPath(row: nextPage, section: 0)
            onboardingCollectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        }
    }
    
    //MARK: - Private Methods
    private func setCurrentPage(_ page: Int) {
        currentPage = page
        viewModel.setCurrentPage(page)
        letGo_Btn.textTitle = page == viewModel.countOnboardingItems() - 1 ? "Let's go".localized : "Next".localized
    }
}

//MARK: - UICollectionViewDelegate, UICollectionViewDelegateFlowLayout
extension OnboardingViewController: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let pageWidth = onboardingCollectionView.frame.size.width
        currentPage = Int(scrollView.contentOffset.x / pageWidth)
        viewModel.setCurrentPage(currentPage)
        
        let indexPath = IndexPath(row: currentPage, section: 0)
        if let cell = onboardingCollectionView.cellForItem(at: indexPath) as? OnboardingCell {
            cell.pageControl.currentPage = currentPage
        }
        
        letGo_Btn.textTitle = currentPage == viewModel.countOnboardingItems() - 1 ? "Let's go".localized : "Next".localized
    }
}
