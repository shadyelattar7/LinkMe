//
//  UICollectionView+Helper.swift
//  Test
//
//  Created by admin on 4/16/20.
//  Copyright © 2020 testing. All rights reserved.
//

import UIKit

extension UICollectionView {
    
    
    
    func registerNIB<Cell: UICollectionViewCell>(_: Cell.Type) {
        let identifier = String(describing: Cell.self)
        self.register(UINib(nibName: identifier, bundle: nil), forCellWithReuseIdentifier: identifier)
    }
    
    func dequeue<Cell: UICollectionViewCell>(cell: Cell.Type, for index: IndexPath) -> Cell {
        let identifier = String(describing: cell.self)
        guard let cell = dequeueReusableCell(withReuseIdentifier: identifier, for: index) as? Cell else {
            fatalError("Unable to Dequeue Reusable Collection View Cell with identifier: \(identifier)")
        }
        return cell
    }
    
    
    
}
