//
//  NotificationListViewController.swift
//  Link-Me
//
//  Created by Ahmed Nasr on 24/09/2023.
//

import UIKit

class NotificationListViewController: UIViewController {

    // MARK: - Outlets
    
    @IBOutlet private weak var headerView: NavigationBarView!
    @IBOutlet private weak var notificationsTableView: UITableView!
    
    // MARK: - LifeCyele
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        configureTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
    }
}

// MARK: - Private Handlers

extension NotificationListViewController: NavigationBarDelegate {
    private func configureUI() {
        headerView.configure(with: NavigationBarViewModel(navBarTitle: "Notifications"), and: self)
    }
    
    func backButtonPressed() {
        self.navigationController?.popViewController(animated: true)
    }
}

// MARK: Configure tableView

extension NotificationListViewController {
    private func configureTableView() {
        notificationsTableView.registerNIB(cell: NotificationItemTableViewCell.self)
        notificationsTableView.separatorStyle = .none
        notificationsTableView.delegate = self
        notificationsTableView.dataSource = self
    }
}

// MARK: Confirm delegate, dataSource

extension NotificationListViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeue() as NotificationItemTableViewCell
        
//        cell.update(viewModel.getItems(indexPath: indexPath))
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
}

