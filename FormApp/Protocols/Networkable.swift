//
//  Networkable.swift
//  GoodLifeApplocation
//
//  Created by heba isaa on 27/08/2022.
//

import Foundation
import Moya
import Network
import Alamofire
protocol Networkable{
    associatedtype targetType:TargetType
    var provider: MoyaProvider<targetType> { get }
    func request<T:Decodable>(target:targetType,completion: @escaping (Result<T, Error>) -> ())
    
}


extension Networkable{
    
    
    
    func request<T: Decodable>(target: targetType, completion: @escaping (Result<T, Error>) -> ()) {
        
        AppManager.shared.monitorNetwork {
            UserDefaults.standard.set(true, forKey: "internet_connection")
        } notConectedAction: {
            UserDefaults.standard.set(false, forKey: "internet_connection")
        }
            provider.request(target) { result in
                switch result {
                case let .success(response):
                    if  response.statusCode == 401 {
                        
                        if let app = UIApplication.shared.delegate as? AppDelegate, let window = app.window {
                            let storyboard = UIStoryboard(name: "Main", bundle: nil)
                            let nav = storyboard.instantiateViewController(withIdentifier: "NavigationController") as! UINavigationController
                            let vc = nav.viewControllers.first as? AuthVC
                            if let vc = vc {
                                vc.isFromUnautherized = true
                            }
                            window.rootViewController = nav
                            Alert.showError(title:"Unauthorized Access",message: "Please login", viewController: nav)
                        }

                    } else {
                        print(String(data: response.data, encoding: .utf8) ?? "Faild to Convert response to String")
                        do {
                            
                            let results = try JSONDecoder().decode(T.self, from: response.data)
                            completion(.success(results))
                        } catch let error {
                            print(error)
                            completion(.failure(MyError.customError))
                        }
                    }
                case let .failure(error):
                    print(error)
                    completion(.failure(MyError.customError))
                }
            }
    }
    
//    func requestRetrier<T:Decodable>(url:String,method:HTTPMethod,parameters:Parameters,headers:HTTPHeaders,completion: @escaping (Result<T, Error>) -> ()){
//
//        AF.request(url,method: method,parameters: parameters ,headers: headers,interceptor: CustomInterceptor()).responseJSON { result in
//            switch result.result {
//            case .success(_):
//                if  result.response?.statusCode == 401 {
//                    self.unauthorizedAction()
//                }else {
//                    do {
//                        print(String(data: result.data ?? Data(), encoding: .utf8) ?? "Faild to Convert response to String")
//                        let results = try JSONDecoder().decode(T.self, from: result.data ?? Data())
//                        completion(.success(results))
//                    } catch let error {
//                        print(error)
//                        completion(.failure(MoyaError.customError("something wrong try again")))
//                    }
//                }
//
//            case let .failure(error):
//                print(error)
//                completion(.failure(MoyaError.customError("something wrong try again")))
//            }
//        }
//    }
    
    
    
    private func unauthorizedAction(){
        
        if let app = UIApplication.shared.delegate as? AppDelegate, let window = app.window {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let nav = storyboard.instantiateViewController(withIdentifier: "NavigationController") as! UINavigationController
            window.rootViewController = nav
            Alert.showError(title:"Unauthorized Access",message: "Please login", viewController: nav)
        }
    }
    
}


public enum MyError: Error {
    case customError
}

extension MyError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .customError:
            return NSLocalizedString("something wrong try again", comment: "")
        }
    }
}

