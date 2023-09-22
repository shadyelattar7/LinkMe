//
//  ReportStoryViewController.swift
//  Link-Me
//
//  Created by Ahmed Nasr on 22/09/2023.
//

import UIKit
import RxSwift
import RxCocoa

class ReportStoryViewController: UIViewController {

    // MARK: Outlets
    
    @IBOutlet private weak var parentView: UIView!
    @IBOutlet private weak var reportTextView: UITextView!
    @IBOutlet private weak var sendReportButton: UIButton!
    @IBOutlet private weak var cancelButton: UIButton!
    
    // MARK: Properties
    
    private let viewModel: ReportStoryViewModel
    private let disposeBag = DisposeBag()
    
    // MARK: Init
    
    init(viewModel: ReportStoryViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        binds()
        subscribe()
    }
}

// MARK: Configure UI

extension ReportStoryViewController {
    private func configureUI() {
        parentView.layer.cornerRadius = 12
        reportTextView.layer.cornerRadius = 8
        sendReportButton.layer.cornerRadius = 8
        cancelButton.layer.cornerRadius = 8
    }
}

// MARK: Private Handlers

extension ReportStoryViewController {
    private func binds() {
        bindToTexts()
    }
    
    private func subscribe() {
        subscribeToCancelButton()
        subscribeToSendReportButton()
        subscribeToReportStoryState()
    }
}

// MARK: Actions

extension ReportStoryViewController {
    private func subscribeToCancelButton() {
        cancelButton.rx.tap.throttle(RxTimeInterval.milliseconds(500), scheduler: MainScheduler.instance).subscribe { [weak self] _ in
            guard let self = self else {return}
            self.dismiss(animated: true)
        }.disposed(by: disposeBag)
    }
    
    private func subscribeToSendReportButton() {
        sendReportButton.rx.tap.throttle(RxTimeInterval.milliseconds(500), scheduler: MainScheduler.instance).subscribe { [weak self] _ in
            guard let self = self else {return}
            self.viewModel.reportStory()
        }.disposed(by: disposeBag)
    }
}

// MARK: viewModel Inputs & Outputs

extension ReportStoryViewController {
    private func bindToTexts() {
        reportTextView.rx.text.orEmpty.bind(to: viewModel.reportReason).disposed(by: disposeBag)
    }
    
    private func subscribeToReportStoryState() {
        viewModel.reportStoryObserver.subscribe { [weak self] state in
            guard let self = self else { return }
            
            switch state.element {
            case .success:
                self.dismiss(animated: true)
                
            case .error(let errorMessage):
                ToastManager.shared.showToast(message: errorMessage, view: self.view, postion: .top , backgroundColor: .LinkMeUIColor.errorColor)
            default:
                break
            }
            
        }.disposed(by: disposeBag)
    }
}


