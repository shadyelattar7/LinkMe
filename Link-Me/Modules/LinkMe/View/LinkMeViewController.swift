//
//  LinkMeViewController.swift
//  Link-Me
//
//  Created by Al-attar on 10/05/2023.
//

import UIKit
import MOLH
import SGSegmentedProgressBarLibrary

class LinkMeViewController: BaseWireFrame<LinkMeViewModel> {
    
    // MARK: - Properties -
    var segmentbar: SGSegmentedProgressBar!

    override func viewDidLoad() {
        super.viewDidLoad()
    
        setupView()
        
    }
    
    
    override func bind(viewModel: LinkMeViewModel) {
        
    }
    
    private func setupView(){
        UDHelper.isChangeLang = false
        
        let rect = CGRect(x: 10, y: 100, width: self.view.frame.size.width - 20, height: 3)
        self.segmentbar = SGSegmentedProgressBar(frame: rect, delegate: self, dataSource: self)
        self.view.addSubview(self.segmentbar!)
    }
    
    
    @IBAction func nextTapped(_ sender: Any) {
        segmentbar.nextSegment()
    }
    
    @IBAction func periousTapped(_ sender: Any) {
        segmentbar.previousSegment()
    }
    
}


//MARK: - SGSegmented Progress Bar Library Configuration -

extension LinkMeViewController: SGSegmentedProgressBarDelegate, SGSegmentedProgressBarDataSource{
    func segmentedProgressBarFinished(finishedIndex: Int, isLastIndex: Bool) {
        print("Finish index: \(finishedIndex)")
    }
    
    var numberOfSegments: Int {
        return 10
    }
    
    var segmentDuration: TimeInterval {
        return 5
    }
    
    var paddingBetweenSegments: CGFloat {
        return 3
    }
    
    var trackColor: UIColor {
        return UIColor.red.withAlphaComponent(0.2)
    }
    
    var progressColor: UIColor {
        return UIColor.red
    }
    
    var roundCornerType: SGSegmentedProgressBarLibrary.SGCornerType {
        return .none
    }
    
    
}
