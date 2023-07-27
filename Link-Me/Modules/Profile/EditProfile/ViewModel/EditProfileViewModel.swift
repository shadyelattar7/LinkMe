//
//  EditProfileViewModel.swift
//  Link-Me
//
//  Created by Al-attar on 19/06/2023.
//

import Foundation
import RxSwift
import RxCocoa


//MARK: - ViewController -> ViewModel

protocol EditProfileInputs{
    var Countries: BehaviorRelay<[Countries]> {get set}
}


//MARK: - ViewController <- ViewModel

protocol EditProfileOutputs{
    var EditProfileStatus: PublishSubject<BaseResponse> {get set}

}

class EditProfileViewModel: BaseViewModel,EditProfileOutputs, EditProfileInputs{
    
    let editProfile: ProfileWorkerProtocol
    let disposedBag = DisposeBag()
    var Countries: BehaviorRelay<[Countries]> = .init(value: [])
    
    init(editProfile: ProfileWorkerProtocol) {
        self.editProfile = editProfile
 
    }
    
    //MARK: - Output -
    
    var EditProfileStatus: PublishSubject<BaseResponse> = .init()

    
    var numberOfCountries: Int {
        return Countries.value.count
    }
    
    //MARK: - Input -
    
    var userImg: BehaviorRelay<Data?> = .init(value: nil)
    var logoMimeType: BehaviorRelay<String> = .init(value: "")
    
    func ViewDidLoad(view: UIView){
        getCountries(view: view)
    }
    
    
    //MARK: - API Call
    
    func getCountries(view: UIView){
        editProfile.getCountries().subscribe(onNext:{ [weak self] result in
            guard let self = self else {return}
            switch result{
            case .success(let model):
                self.Countries.accept(model.data ?? [])
            case .failure(let error):
                let errorMessage = error.userInfo["NSLocalizedDescription"] as! String
                ToastManager.shared.showToast(message: errorMessage, view: view, postion: .top , backgroundColor: .LinkMeUIColor.errorColor)
                print("ERROR: \(error)")
            }
        }).disposed(by: disposedBag)
    }
    
    func editProfile(email: String, name: String,username: String, birth_date: String,country_id: String,gander: String,bio: String,view: UIView){
        let model = EditProfileRequestModel(email: email,
                                            name: name,
                                            username: username,
                                            birth_date: birth_date,
                                            country_id: country_id,
                                            gander: gander,
                                            bio: bio)
        
        
        var multiPartArr = [MultiPartData]()
        if let image = self.userImg.value{
            let multiPartRequestmodel = MultiPartData(keyName: "image", fileData: image, mimeType: self.logoMimeType.value,fileName: "image")
            multiPartArr = [multiPartRequestmodel]
        }

        print("multiPartArr: \(multiPartArr)")
        print("Param: \(model)")
        
        
        editProfile.EditProfile(model: model, fileModel: multiPartArr).subscribe(onNext:{ [weak self] result in
            guard let self = self else {return}
            print("Model: \(model)")
            switch result{
            case .success(let model):
                self.EditProfileStatus.onNext(model)
            case .failure(let error):
                let errorMessage = error.userInfo["NSLocalizedDescription"] as! String
                ToastManager.shared.showToast(message: errorMessage, view: view, postion: .top , backgroundColor: .LinkMeUIColor.errorColor)
                print("ERROR: \(error)")
            }
        }).disposed(by: disposedBag)
    }
    
}
