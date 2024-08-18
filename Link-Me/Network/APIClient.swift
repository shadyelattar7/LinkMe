//
//  APIClient.swift
//  Link-Me
//
//  Created by Al-attar on 10/05/2023.
//

import Foundation
import Alamofire
import RxSwift

//enum URLType: String{
//    case intention = ""
//    case payment = ""
//}

enum DownloadStatus{
    case progress(progress: Progress)
    case success(url: URL?)
    //case failure(error: NSError)
}

class APIClient<T: TargetType> {
    
    var loadingCheck: Bool?
    
    private let baseURL: String = "https://link-me.live/api"
    
    /// a generic method to perform requests with requestModels
    /// - Parameters:
    ///   - target: it carries the data of the request you are performing
    ///   - requestModel: it is used to infer the type of the encodable parameters
    /// - Returns: an observable of type Result --> may carry a success or failure response
    func performRequest<X: Decodable, E: Encodable>(target: T, requestModel: E) -> Observable<Result<X, NSError>>{
        if loadingCheck ?? true{
            Loading.shared.showLoading()
        }
        return Observable.create { observer in
            let method = Alamofire.HTTPMethod(rawValue: target.method.rawValue)
            let headers = Alamofire.HTTPHeaders(target.headers)
            let params = self.buildParams(task: target.task).0 as? E
            
            
            
            AF.request(self.baseURL+target.path, method: method, parameters: params, encoder: JSONParameterEncoder.default, headers: headers)
                .responseDecodable (decoder: JSONDecoder()) { (response: DataResponse<X, AFError>) in
   //                 PrintHelper.debugPrint(response)
                    self.hideLoading()

                    if let data = response.data{
                        let statusCode = response.response?.statusCode ?? 500
                        if statusCode == 200 || statusCode == 201{
                            if let data = response.value{
                                print("\n\n RESPONSE: 🟢⚡️🚀➡️ \(data) \n\n")
                                observer.onNext(.success(data))
                            }else{
                                let error = NSError(domain: self.baseURL, code: statusCode, userInfo: [NSLocalizedDescriptionKey: response.error?.localizedDescription ?? ErrorMessage.genericError.rawValue])
                                
                                print("ERROR: \(response.error)")
//                                self.hideLoading()
                                observer.onNext(.failure(error))
                            }
                        }else{
                            do{
                                let errorModel = try JSONDecoder().decode(ErrorModel.self, from: data)
                                let msg = errorModel.message?.val ?? errorModel.detail ?? ""
                                var obj : [String: String]  = [NSLocalizedDescriptionKey: msg]
                                if let code = errorModel.code{
                                    obj["code"] = code
                                }
                                
                                let error = NSError(domain: self.baseURL, code: statusCode, userInfo: obj)
//                                self.hideLoading()
                                observer.onNext(.failure(error))
                            }catch{
                                if statusCode >= 500{
                                    let error = NSError(domain: self.baseURL, code: statusCode, userInfo: [NSLocalizedDescriptionKey: "server Error"])
//                                    self.hideLoading()
                                    observer.onNext(.failure(error))
                                }else{
                                    let error = NSError(domain: self.baseURL, code: statusCode, userInfo: [NSLocalizedDescriptionKey: response.error?.localizedDescription ?? ErrorMessage.genericError.rawValue])
//                                    self.hideLoading()
                                    observer.onNext(.failure(error))
                                }
                            }
                        }
                    }else{
                        let error = NSError(domain: self.baseURL, code: 0, userInfo: [NSLocalizedDescriptionKey: response.error?.localizedDescription ?? ErrorMessage.genericError.rawValue])
//                        self.hideLoading()
                        observer.onNext(.failure(error))
                    }
                }
            return Disposables.create()
        }
    }
    
    
    /// a generic method to perform plain requests without requestModels
    /// - Parameters:
    ///   - target: it carries the data of the request you are performing
    /// - Returns: an observable of type Result --> may carry a success or failure response
    func performRequest<X: Decodable>(target: T) -> Observable<Result<X, NSError>>{
        if loadingCheck ?? true{
            Loading.shared.showLoading()
        }
        return Observable.create { observer in
            let method = Alamofire.HTTPMethod(rawValue: target.method.rawValue)
            let headers = Alamofire.HTTPHeaders(target.headers)
            AF.request(self.baseURL+target.path, method: method, parameters: nil, encoding: JSONEncoding.default, headers: headers)
                .responseDecodable (decoder: JSONDecoder()) { (response: DataResponse<X, AFError>) in
                    // PrintHelper.debugPrint(response)
                    print("URL: \(self.baseURL+target.path)")
                    print("Response: \(response.value)")
                    self.hideLoading()
                    if let data = response.data{
                        let statusCode = response.response?.statusCode ?? 500
                        if statusCode == 200 || statusCode == 201{
                            if let data = response.value{
                                print("\n\n RESPONSE: 🟢⚡️🚀➡️ \(data) \n\n")
                                if self.loadingCheck ?? true{
                                    Loading.shared.hideProgressView()
                                }
                                print("Data: \(data)")
                                observer.onNext(.success(data))
                            }else{
                                let error = NSError(domain: self.baseURL, code: statusCode, userInfo: [NSLocalizedDescriptionKey: response.error?.localizedDescription ?? ErrorMessage.genericError.rawValue])
                                print("ERROR: \(response.error)")
                                observer.onNext(.failure(error))
                            }
                        }else{
                            do{
                                let errorModel = try JSONDecoder().decode(ErrorModel.self, from: data)
                                let msg = errorModel.message?.val ?? errorModel.detail ?? ""
                                var obj : [String: String]  = [NSLocalizedDescriptionKey: msg]
                                if let code = errorModel.code{
                                    obj["code"] = code
                                }
                                
                                let error = NSError(domain: self.baseURL+target.path, code: statusCode, userInfo: obj)
                                observer.onNext(.failure(error))
                            }catch{
                                if statusCode >= 500{
                                    let error = NSError(domain: self.baseURL, code: statusCode, userInfo: [NSLocalizedDescriptionKey: "server Error"])
                                    observer.onNext(.failure(error))
                                }else{
                                    let error = NSError(domain: self.baseURL, code: statusCode, userInfo: [NSLocalizedDescriptionKey: response.error?.localizedDescription ?? ErrorMessage.genericError.rawValue])
                                    observer.onNext(.failure(error))
                                }
                            }
                        }
                    }else{
                        let error = NSError(domain: self.baseURL+target.path, code: 0, userInfo: [NSLocalizedDescriptionKey: response.error?.localizedDescription ?? ErrorMessage.genericError.rawValue])
                        observer.onNext(.failure(error))
                    }
                }
            return Disposables.create()
        }
    }
    
    
    /// upload multipart request
    /// - Parameter target: it carries the data of the request you are performing
    /// - Returns: an observable of type Result --> may carry a success or failure response
    func performMultipartRequest<X: Decodable>(target: T) -> Observable<Result<X, NSError>>{
        if self.loadingCheck ?? true {
            Loading.shared.showLoading()
        }
        
        return Observable.create { observer in
            
            let method = Alamofire.HTTPMethod(rawValue: target.method.rawValue)
            let headers = Alamofire.HTTPHeaders(target.headers)
            let filesModel = self.buildParams(task: target.task).1 ?? []
            var params: [String: Any]?
            
            do{
                params = try self.buildParams(task: target.task).0?.asDictionary()
            }catch let err{
                let error = NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: err])
                observer.onNext(.failure(error))
            }
                       
            
            AF.upload(multipartFormData: { (multipartFormData) in
                guard let params = params else { return}
                
                
                for (key, val) in params{
                    multipartFormData.append((val as AnyObject).data(using: String.Encoding.utf8.rawValue)!, withName: key)
                }
                
                for item in filesModel{
                   // let random = Int.random(in: 1000..<99999999)
                    let fileName = item.fileName
                    multipartFormData.append(item.fileData, withName: item.keyName, fileName: fileName, mimeType: item.mimeType)
                }
            }, to: self.baseURL+target.path, method: method, headers: headers)
            .responseDecodable (decoder: JSONDecoder()){ (response: DataResponse<X, AFError>) in
                // PrintHelper.debugPrint(response)
                self.hideLoading()
                
                if let data = response.data{
                    let statusCode = response.response?.statusCode ?? 500
                    if statusCode == 200 || statusCode == 201{
                        if let data = response.value{
                            
                            print("\n\n RESPONSE: 🟢⚡️🚀➡️ \(data) \n\n")
                            if self.loadingCheck ?? true{
                                Loading.shared.hideProgressView()
                            }
                            observer.onNext(.success(data))
                        }else{
                            print("ERRORRR: \(response.error)")
                            let error = NSError(domain: self.baseURL+target.path, code: statusCode, userInfo: [NSLocalizedDescriptionKey: response.error?.localizedDescription ?? ErrorMessage.genericError.rawValue])
                            observer.onNext(.failure(error))
                        }
                    }else{
                        do{
                            let errorModel = try JSONDecoder().decode(ErrorModel.self, from: data)
                            let msg = errorModel.message?.val ?? errorModel.detail ?? ""
                            var obj : [String: String]  = [NSLocalizedDescriptionKey: msg]
                            if let code = errorModel.code{
                                obj["code"] = code
                            }
                            
                            let error = NSError(domain: self.baseURL, code: statusCode, userInfo: obj)
                            observer.onNext(.failure(error))
                        }catch{
                            if statusCode >= 500{
                                let error = NSError(domain: self.baseURL, code: statusCode, userInfo: [NSLocalizedDescriptionKey: "server Error"])
                                print("ERROR 500: \(error)")
                                observer.onNext(.failure(error))
                            }else{
                                let error = NSError(domain: self.baseURL, code: statusCode, userInfo: [NSLocalizedDescriptionKey: response.error?.localizedDescription ?? ErrorMessage.genericError.rawValue])
                                observer.onNext(.failure(error))
                            }
                        }
                    }
                }else{
                    let error = NSError(domain: self.baseURL, code: 0, userInfo: [NSLocalizedDescriptionKey: response.error?.localizedDescription ?? ErrorMessage.genericError.rawValue])
                    observer.onNext(.failure(error))
                }
            }
            return Disposables.create()
        }
    }
    
    
    func download(target: T, Url: String) -> Observable<DownloadStatus>{
        Observable<DownloadStatus>.create { observer in
            if self.loadingCheck ?? true{
                //Loading.shared.showLoading()
            }
            let url = URL(string: target.path)!
            let destination = //DownloadRequest.suggestedDownloadDestination(for: .documentDirectory)
            DownloadRequest.suggestedDownloadDestination(for: .documentDirectory, in: .userDomainMask, options: DownloadRequest.Options.removePreviousFile)
            
            AF.download(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: nil, to: destination)
                .downloadProgress(closure: { (progress) in
                    observer.onNext(.progress(progress: progress))
                })
                .response(completionHandler: { (DefaultDownloadResponse) in
                    if self.loadingCheck ?? true{
                        //Loading.shared.hideProgressView()
                    }
                    //PrintHelper.debugPrint(DefaultDownloadResponse.response)
                    switch DefaultDownloadResponse.result{
                    case .success(let url):
                        observer.onNext(.success(url: url))
                        observer.onCompleted()
                    case .failure(let error):
                        let statusCode = DefaultDownloadResponse.response?.statusCode ?? 0
                        let errorMsg = error.errorDescription ?? ""
                        let error = NSError(domain: url.absoluteString, code: statusCode, userInfo: [NSLocalizedDescriptionKey: errorMsg])
                        observer.onError(error)
                    }
                })
            return Disposables.create()
        }
    }
    
    private func buildParams(task: Task) -> (Encodable?, [MultiPartData]?){
        switch task {
        case .requestPlain:
            return (nil, nil)
        case .request(let parameters):
            return (parameters, nil)
        case .multiPart(let parameters, let fileData):
            return (parameters, fileData)
        case .localData:
            return (nil, nil)
        }
    }
    
    func hideLoading(){
        if self.loadingCheck ?? true{
            Loading.shared.hideProgressView()
        }
    }
}


struct MultiPartData{
    var keyName: String
    var fileData: Data
    var mimeType: String
    var fileName: String
}


extension Encodable{
    
    /// encode class that confirm Encodable to Data to send it to HTTP body
    var encode : Data?{
        do {
            return try JSONEncoder().encode(self)
        }catch{
            return nil
        }
    }
    
    /// convert encodable model to [String: Any]
    func asDictionary() throws -> [String: Any] {
        let data = try JSONEncoder().encode(self)
        guard let dictionary = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any] else {
            throw NSError()
        }
        return dictionary
    }
}
