//
//  Networkable.swift
//  FormApp
//
//  Created by Hany Alkahlout on 27/08/2022.
//

import Foundation
import Moya
import Network
import Alamofire
import SVProgressHUD


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
        print("Request Data:",target)
        provider.request(target) { result in
            switch result {
            case let .success(response):
                print("Request Response:",String(data: response.data, encoding: .utf8) ?? "Faild to Convert response to String")
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
                } else  if response.statusCode == 503 || response.statusCode == 500 {
                    print(String(data: response.data, encoding: .utf8) ?? "Faild to Convert response to String")
                    SVProgressHUD.dismiss()
                    completion(.failure(MyError.serverError))
                } else {
                    
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
    case serverError
}

extension MyError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .customError:
            return NSLocalizedString("Something went the wrong try again", comment: "")
        case .serverError:
            return NSLocalizedString("Server Error !!", comment: "")
        }
    }
}

