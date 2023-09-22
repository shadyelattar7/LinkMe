//
//  BottomListSheet.swift
//  Link-Me
//
//  Created by Ahmed Nasr on 22/09/2023.
//

import UIKit

class BottomListSheet: UIViewController {

    // MARK: Outlets
    
    @IBOutlet private weak var contentView: UIView!
    @IBOutlet private weak var itemsParentView: UIView!
    @IBOutlet private weak var heightOfItemsViewConstraint: NSLayoutConstraint!
    @IBOutlet private weak var handView: UIView!
    @IBOutlet private weak var itemsTableView: UITableView!
    
    // MARK: Properties
    
    private let listItems: [ItemList]
    var onClicked: ((ItemList) -> ()) = { _ in }
    
    // MARK: Init
    
    init(listItems: [ItemList]) {
        self.listItems = listItems
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        configureTableView()
//        addTappedOnContentView()
//        addTappedOnItemsParent()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.heightOfItemsViewConstraint.constant = self.itemsTableView.contentSize.height + 48
        }
    }
}

// MARK: Configure UI

extension BottomListSheet {
    private func configureUI() {
        itemsParentView.layer.cornerRadius = 12
        configureHandViewUI()
    }
    private func configureHandViewUI() {
        handView.backgroundColor = UIColor(red: 0.92, green: 0.92, blue: 0.92, alpha: 1)
        handView.layer.cornerRadius = 5
    }
}

// MARK: Private Handlers

extension BottomListSheet {
    private func addTappedOnContentView() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(didTappedOnContentView))
        tap.numberOfTapsRequired = 1
        contentView.isUserInteractionEnabled = true
        contentView.addGestureRecognizer(tap)
    }
    
    @objc private func didTappedOnContentView() {
        self.dismiss(animated: true)
    }
    
    private func addTappedOnItemsParent() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(didTappedOnItemsParent))
        tap.numberOfTapsRequired = 1
        itemsParentView.isUserInteractionEnabled = true
        itemsParentView.addGestureRecognizer(tap)
    }
    
    @objc private func didTappedOnItemsParent() {
    }
}

// MARK: Configure tableView

extension BottomListSheet {
    private func configureTableView() {
        itemsTableView.register(UINib(nibName: "ItemListTableViewCell",
                                      bundle: nil), forCellReuseIdentifier: "ItemListTableViewCell")
        itemsTableView.delegate = self
        itemsTableView.dataSource = self
    }
}

// MARK: Confirm delegate, dataSource

extension BottomListSheet: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ItemListTableViewCell", for: indexPath) as? ItemListTableViewCell else { return UITableViewCell() }
        
        cell.update(listItems[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        onClicked(listItems[indexPath.row])
    }
}
