//
//  UITableView+Helper.swift
//  Test
//
//  Created by admin on 4/16/20.
//  Copyright © 2020 testing. All rights reserved.
//

import UIKit

extension UITableView {
    
    
    /**
     *** 1- register nib
     *** 2- customize shape ... remove sperator . remove last line set background to clear & remove vertical indicator
     */
    
    
    /**
     *** mark:- register TableView
     *--------------------------------------------------------
     *&&-------
     *&& using generic ...
     *&& T.Type means ( UserTableCell )
     *&&-----
     *--------------------------------------------------------
     */
    
    public func registerNIB<T: UITableViewCell>(cell: T.Type) -> Void {
        let identifier = String(describing: cell.self)
        self.register(
            UINib(nibName: identifier, bundle: nil),
            forCellReuseIdentifier: identifier
        )
    }
    
    /**
     *** mark:- dequeue TableView
     *--------------------------------------------------------
     *&&-------
     *&& using generic ...
     *&&-----
     *--------------------------------------------------------
     */
    
    public func dequeue<T: UITableViewCell>() -> T {
        let identifier = String(describing: T.self)
        if let dequeuedCell = self.dequeueReusableCell(withIdentifier: identifier) as? T {
            return dequeuedCell
        }
        fatalError("could not deque cell")
    }
    
    
    /**
     *** mark:- set TableView SperatorStyle
     *--------------------------------------------------------
     *&&-------
     *&& sperator ...
     *&&-----
     *--------------------------------------------------------
     */
    
    
    public func set(sperator: UITableViewCell.SeparatorStyle) -> UITableView {
        self.separatorStyle = sperator
        return self
    }
    
    /**
     *** mark:- remove last line TableView
     *--------------------------------------------------------
     *&&-------
     *&& remove last line from footerView
     *&&-----
     *--------------------------------------------------------
     */
    
    public func remmove(bottomLine: Bool = true) -> UITableView {
        if bottomLine == true {
            self.tableFooterView =
                UIView(frame: CGRect(x: 0, y: 0, width: self.frame.width, height: 0.01))
        }
        return self
    }
    
    
    /**
     *** mark:- display indicator TableView
     *--------------------------------------------------------
     *&&-------
     *&& remove indicator from tableView
     *&&-----
     *--------------------------------------------------------
     */
    
    public func show(indicator: Bool) -> UITableView {
        self.showsHorizontalScrollIndicator = indicator
        self.showsVerticalScrollIndicator = indicator
        return self
    }
    
}
