//
//  GetLocalDataManager.swift
//  Paymob App
//
//  Created by Al-attar on 15/06/2022.
//

import Foundation
import RxSwift

class LocalDataManager{
    
    static func getData<T: Decodable>(_ model: T.Type, _ forResource: String, _ withExtension: String) -> Observable<Result<T, NSError>>{
        return Observable.create { observer in
            
            guard let sourceUrl = Bundle.main.url(forResource: forResource, withExtension: withExtension) else{
                //  completion(nil, "Could not find Setting.json")
                let error = NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey : "Could not find Setting.json"])
                observer.onNext(.failure(error))
                return Disposables.create()
            }
            
            guard let resultData = try? Data(contentsOf: sourceUrl) else {
                //  completion(nil, "Could not convert data")
                let error = NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey : "Could not convert data"])
                observer.onNext(.failure(error))
                return Disposables.create()
            }
            
            let decoder = JSONDecoder()
            guard let result = try? decoder.decode(T.self, from: resultData) else{
                //  completion(nil, "There was a problem decoding the data ....")
                let error = NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey : "There was a problem decoding the data ...."])
                observer.onNext(.failure(error))
                return Disposables.create()
            }
            
            observer.onNext(.success(result))
            return Disposables.create()
        }
    }
}
