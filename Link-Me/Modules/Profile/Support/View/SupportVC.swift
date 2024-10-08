//
//  SupportVC.swift
//  Link-Me
//
//  Created by Al-attar on 26/06/2023.
//

import UIKit

class SupportVC: BaseWireFrame<SupportViewModel>, NavigationBarDelegate, UIScrollViewDelegate {
    
    //MARK: - @IBOutlet -
    
    @IBOutlet weak var emptyView: UIView!
    @IBOutlet weak var segmentControler: UISegmentedControl!
    @IBOutlet weak var navBar: NavigationBarView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var counterBox_lbl: UILabel!
    
    //MARK: - Variables
    var source: SupportEnum = .box
    var isDismissed: Bool = false
    
    //MARK: - Bind
    
    override func bind(viewModel: SupportViewModel) {
        self.viewModel.viewDidLoad(ticketType: source, view: self.view)
        setupView()
        SupportTableViewSetup()
        segmentControler.setTitle("box".localized, forSegmentAt: 0)
        segmentControler.setTitle("sent".localized, forSegmentAt: 1)
    }
    
    //MARK: - Private func
    
    private func setupView(){
        navBar.configure(with: NavigationBarViewModel(navBarTitle: "Support".localized), and: self)
        viewModel.tickets.asObservable()
                   .subscribe(onNext: { [weak self] tickets in
                       self?.updateView(for: tickets)
                   })
                   .disposed(by: disposeBag)
       
    }
    
    func updateView(for tickets: [TicketsData]) {
            if tickets.isEmpty {
                emptyView.isHidden = false
                tableView.isHidden = true
            } else {
                emptyView.isHidden = true
                tableView.isHidden = false
            }
        }
    private func SupportTableViewSetup(){
        tableView.registerNIB(cell: SupportCell.self)
        
        tableView.rx.setDelegate(self).disposed(by: disposeBag)
        
        viewModel.tickets.bind(to: tableView.rx.items(cellIdentifier: String(describing: SupportCell.self), cellType: SupportCell.self)){ (row,item,cell) in
            print(item)
            cell.configure(data: item, source: self.source)
            
        }.disposed(by: disposeBag)
        
        
        tableView.rx.itemSelected.subscribe { [weak self] indexPath in
            guard let self = self, let indexPath = indexPath.element else {return}
        }.disposed(by: disposeBag)
        
    }
    
    //MARK: - Actions
    
    func backButtonPressed() {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func addTapped(_ sender: Any) {
        let sendEmailVC = self.coordinator.Main.viewcontroller(for: .SendEmail) as! SendEmailVC
        sendEmailVC.delegate = self
        self.present(sendEmailVC, animated: true)
        //         self.coordinator.Main.navigate(for: .SendEmail,navigtorTypes: .present)
    }
    
    @IBAction func supportSegment(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0{
            source = .box
            self.viewModel.getTickets(ticketType: .box, view: self.view)
        }else{
            source = .sent
            self.viewModel.getTickets(ticketType: .sent, view: self.view)
        }
    }
}


extension SupportVC: UITableViewDelegate{
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}

extension SupportVC: SendEmailDismissed{
    func checkIsDismissed(isDismiss: Bool) {
        if isDismiss{
            self.viewModel.getTickets(ticketType: source, view: self.view)
        }
    }
    
  
}
