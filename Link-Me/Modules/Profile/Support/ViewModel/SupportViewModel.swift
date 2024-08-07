//
//  SupportViewModel.swift
//  Link-Me
//
//  Created by Al-attar on 26/06/2023.
//

import Foundation
import RxSwift
import RxCocoa

enum SupportEnum: String{
    case box = "box"
    case sent = "sent"
  //  case suggestion = "suggestion"
}

//MARK: - ViewController -> ViewModel

protocol SupportlInputs{
    
}


//MARK: - ViewController <- ViewModel

protocol SupportOutputs{

}


class SupportViewModel: BaseViewModel, SupportlInputs, SupportOutputs{
    
    let Support: ProfileWorkerProtocol
    let disposedBag = DisposeBag()
    var tickets: BehaviorRelay<[TicketsData]> = .init(value: [])
    
    init(Support: ProfileWorkerProtocol) {
        self.Support = Support
    }
    
    //MARK: - Output -
    func viewDidLoad(ticketType: SupportEnum, view: UIView){
        getTickets(ticketType: ticketType, view: view)
    }
    
    //MARK: - API Call
    
    func getTickets(ticketType: SupportEnum, view: UIView){
        Support.getTickets(ticket_type: ticketType.rawValue).subscribe(onNext:{ [weak self] result in
            guard let self = self else {return}
            switch result{
            case .success(let model):
                self.tickets.accept([])
                self.tickets.accept(model.dats?.data ?? [])
                print( self.tickets.value)
            case .failure(let error):
                let errorMessage = error.userInfo["NSLocalizedDescription"] as! String
                ToastManager.shared.showToast(message: errorMessage, view: view, postion: .top , backgroundColor: .LinkMeUIColor.errorColor)
                print("ERROR: \(error)")
            }
        }).disposed(by: disposedBag)
    }
    
    
}
