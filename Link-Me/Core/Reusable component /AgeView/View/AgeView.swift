//
//  AgeView.swift
//  Link-Me
//
//  Created by Ahmed Nasr on 03/10/2023.
//

import UIKit

enum AgeType {
    case first
    case middle
    case last
    
    var title: String {
        switch self {
        case .first: return "16-24"
        case .middle: return "25-30"
        case .last: return "30+"
        }
    }
    
    var id: Int {
        switch self {
        case .first: return 1
        case .middle: return 2
        case .last: return 3
        }
    }
}

class AgeView: UIView {
    
    // MARK: Outlets
    
    @IBOutlet private weak var contentView: UIView!
    @IBOutlet private weak var ageCollectionView: UICollectionView!
    
    // MARK: Properties
    
    private let listOfAge: [AgeType] = [.first, .middle, .last]
    var onSelected: ((Int) -> ()) = { _ in }
    
    //MARK: - init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        initView()
    }
    
    private func initView() {
        loadViewFromNib()
        configureCollectionView()
    }
}

// MARK: Handle collection views

extension AgeView: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    private func configureCollectionView() {
        ageCollectionView.registerNIB(AgeCollectionViewCell.self)
        ageCollectionView.delegate = self
        ageCollectionView.dataSource = self
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return listOfAge.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeue(cell: AgeCollectionViewCell.self, for: indexPath)
        cell.update(listOfAge[indexPath.row].title)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? AgeCollectionViewCell else { return }
        cell.selectItem()
        onSelected(listOfAge[indexPath.row].id)
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? AgeCollectionViewCell else { return }
        cell.unSelectItem()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 110, height: 56)
    }
}
