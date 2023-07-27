//
//  UserPhotoProfileView.swift
//  Link-Me
//
//  Created by Al-attar on 14/06/2023.
//

import Foundation
import UIKit

enum CompeletPrecntage: CGFloat{
    case quarter = 0.6366197723675814
    case half = 1.57079632679
    case complete = 6.283185307179586
}

struct UserPhotoProfileViewViewModel {
    var userPhoto: String = ""
    var precntage: Int = 0
    var radiusCircular: CGFloat = 0
}

class UserPhotoProfileView : NibLoadingView {
    
    // MARK: - Outlets -
    
    @IBOutlet var viewContainer: UIView!
    @IBOutlet weak var userImg_iv: UIImageView!
    @IBOutlet weak var precntage_lbl: UILabel!
    
    
    // MARK: - Properties -
    
    let shapeLayer = CAShapeLayer()
    private let nibName = "UserPhotoProfileView"
    private var viewModel: UserPhotoProfileViewViewModel? {
        didSet {
            guard let viewModel = viewModel else {
                return
            }
            setData(with: viewModel)
        }
    }
    
    lazy var precntageLbl: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "125 %"
        label.backgroundColor = .LinkMeUIColor.mainColor
        label.layer.cornerRadius = 11
        label.clipsToBounds = true
        label.textColor = .white
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 10)
        return label
    }()
    
    lazy var userImg: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.contentMode = .scaleAspectFill
        image.layer.cornerRadius = self.frame.height / 2
        image.layer.masksToBounds = false
        image.clipsToBounds = true
        return image
    }()
    
    var radiusCircular: CGFloat = 0
    
    // MARK: - init
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        xibSetUp()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        xibSetUp()
    }
    
    // MARK: - Private Methods
    
    private func xibSetUp() {
        viewContainer = loadViewFromNib()
        viewContainer.frame = self.bounds
        viewContainer.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        addSubview(viewContainer)
    }
    
    private func loadViewFromNib() -> UIView {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: nibName, bundle: bundle)
        return nib.instantiate(withOwner: self, options: nil).first as! UIView
    }
    
    private func setData(with viewModel: UserPhotoProfileViewViewModel) {
        userImg_iv.getImage(imageUrl: viewModel.userPhoto)
        precntageLbl.text = "\(viewModel.precntage)%"
        userImg.getImage(imageUrl: viewModel.userPhoto)
        radiusCircular = viewModel.radiusCircular
        
    }
    
    private func drawCircularProgress(precntage: CompeletPrecntage){
        
        let center = view.center
        
        //MARK: - Create my track layer
        let trackcircularPath = UIBezierPath(arcCenter: center, radius: radiusCircular, startAngle: -CGFloat.pi / 2 , endAngle: 2 * CGFloat.pi, clockwise: true)
        let trackLayer = CAShapeLayer()
        trackLayer.path = trackcircularPath.cgPath
        trackLayer.strokeColor =  UIColor.LinkMeUIColor.lightPurple.cgColor
        trackLayer.lineWidth = 6
        trackLayer.fillColor = UIColor.clear.cgColor
        trackLayer.lineCap = .round
        view.layer.addSublayer(trackLayer)
        view.addSubview(userImg)
        
        
     
        
        userImg.widthAnchor.constraint(equalToConstant:  75).isActive = true
        userImg.heightAnchor.constraint(equalToConstant: 75).isActive = true
        userImg.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        userImg.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        
        
        //MARK: - Create Circular Progress
        let circularPath = UIBezierPath(arcCenter: center, radius: radiusCircular, startAngle: -CGFloat.pi / 2 , endAngle: precntage.rawValue, clockwise: true)
        shapeLayer.path = circularPath.cgPath
        shapeLayer.strokeColor =  UIColor.LinkMeUIColor.mainColor.cgColor
        shapeLayer.lineWidth = 6
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.lineCap = .round
        shapeLayer.strokeEnd = 0
        view.layer.addSublayer(shapeLayer)
        view.addSubview(precntageLbl)
        handleAnimation()
        
        
        // Set its constraint to display it on screen
        
        precntageLbl.widthAnchor.constraint(equalToConstant:  37).isActive = true
        precntageLbl.heightAnchor.constraint(equalToConstant: 20.96).isActive = true
        precntageLbl.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        precntageLbl.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: (radiusCircular - 40) + 10).isActive = true
    }
    
    
    private func handleAnimation(){
        let basicAnimation = CABasicAnimation(keyPath: "strokeEnd")
        basicAnimation.toValue = 1
        basicAnimation.duration = 2
        basicAnimation.fillMode = .forwards
        
        basicAnimation.isRemovedOnCompletion = false
        shapeLayer.add(basicAnimation, forKey: "urSoBasic")
    }
    // MARK: - configure Methods
    
    func configure(with viewModel: UserPhotoProfileViewViewModel, precntage: CompeletPrecntage) {
        self.viewModel = viewModel
        drawCircularProgress(precntage: precntage)
    }
    
}
