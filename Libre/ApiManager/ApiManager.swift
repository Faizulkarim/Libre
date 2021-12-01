//
//  NewApiManager.swift
//  Melpot
//
//  Created by Hyperlink on 08/04/19.
//  Copyright © 2019 Melpot. All rights reserved.
//

import Foundation
import UIKit
import SwiftyJSON

class ApiManager : TargetType {
    
    var path: String = ""
    var isArray = false
    var arrData = [[String:Any]]()
    
    static var shared = ApiManager()
    
    let provider = MoyaProvider<ApiManager>(manager : WebService.manager())
    
    var sampleData: Data {
        return "Half measures are as bad as nothing at all.".utf8Encoded
    }
    
    var requests : [(endPoint : ApiEndPoints , cancellable : Moya.Cancellable)] = []
    
    var headers: [String : String]?
    
    // http://35.158.248.75:8701/v1
    // http://18.157.205.23:8701/v1/ new server link received on ZOHO 09/06/2020
    var environmentBaseURL : String {
        switch NetworkManager.environment{
        case .local : return ""
        case .live :  return "http://4shop.io:8701/v1"
        case .localhost : return "http://3.17.180.233"
        }
        
    }
    
    // MARK: - baseURL
    var baseURL: URL {
        
        guard let url  = URL(string: environmentBaseURL) else{
            fatalError("base url could not be configured")
        }
        return url
    }
    
    //  var path : String = ""
    
    var method: Moya.Method = .post
    
    // MARK: - parameterEncoding
    var parameterEncoding: ParameterEncoding {
        return URLEncoding.default
    }
    
    // MARK: - task
    var task: Task {
        
        if isArray {
            self.isArray = false
            let jsonData = try? JSONSerialization.data(withJSONObject: arrData, options: JSONSerialization.WritingOptions.prettyPrinted)
            let jsonString = String(data: jsonData!, encoding: .utf8)!
            return .requestParameters(parameters: [:], encoding: self.method == . post ? jsonString as ParameterEncoding : URLEncoding.default)
        } else {
            let jsonData = try? JSONSerialization.data(withJSONObject: self.parameters!, options: JSONSerialization.WritingOptions.prettyPrinted)
            let jsonString = String(data: jsonData!, encoding: .utf8)!
            return .requestParameters(parameters: [:], encoding: self.method == . post ? jsonString as ParameterEncoding : URLEncoding.default)
        }


    }
    
    var parameters: [String: Any]?
    

    /// Set Headers
    func setHeaders(withToken : Bool)  {
        var headersToSend : [String : String] = [:]
        headersToSend["content-type"] = "application/json"
        if withToken == true {
            if let token = UserDefaults.standard.value(forKey: UserDefaultsKeys.kAccessToken.rawValue) {
                headersToSend["authorization"] = ("Bearer " + JSON(token).stringValue)
            }
        }
        self.headers = headersToSend
        debugPrint(headersToSend)
    }
    
    func makeRequest(method: ApiEndPoints,
                     methodType: HTTPMethod = .post,
                     parameter : Dictionary<String,Any>?,
                     withErrorAlert isErrorAlert : Bool = true,
                     withLoader isLoader : Bool = true,
                     withToken       : Bool = true,
                     withdebugLog isDebug : Bool = true,
                     withBlock completion :((Swift.Result<DataResult,Error>) -> Void)?) {
        
        
        //Assign Value to Moya Parameters
        self.path = method.methodName
        self.parameters = parameter
        self.method = methodType
        setHeaders(withToken: withToken)

        
        if isLoader {
            self.addLoader()
        }
        
        let bottomLoader = (parameter?.keys.contains("page") ?? false  && (parameter?["page"] as! String) != "1")
        if bottomLoader
        {
            GradientLoadingBar.shared.show()
        }
        
        DispatchQueue.main.async {
            UIApplication.shared.isNetworkActivityIndicatorVisible = true
        }
        
                if isDebug {
                    self.manageDebugRequest(parameters: self.parameters)
                }
        
        let request = provider.request(self) { (result) in
            
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
            self.removeLoader()
            
           
            print(result)
            switch result {
            
            
            case .success(let response):
                
                
                if response.statusCode == 401 {
                    self.logout()
                    completion?(.failure(ApiCustomError.sessionExpire))
                }
                
                do {
                    //                    guard let res = try response.mapJSON() as? String else {
                    //                        return
                    //                    }
                    
                    var code = ApiKeys.ApiStatusCode.invalidOrFail
                    
                    
                    let resDic  = JSON(response.data)
                    print(resDic)
                    
                    
                    //                    if isDebug {
                    //                        self.manageDebugResponse(encryptedString: res, responseDic: resDic)
                    //                    }
                    
                    if let codeint = ApiKeys.ApiStatusCode.init(rawValue: String(resDic["statusCode"].intValue)) {
                        code = codeint
                    }
                    
                    let responseData = DataResult(data: resDic[ApiKeys.respsone(.data).value],
                                                  httpCode: response.statusCode,
                                                  apiCode: code,
                                                  message: resDic[ApiKeys.respsone(.message).value].stringValue,
                                                  success: resDic["success"].boolValue,
                                                  response : resDic
                                                 )
                    
                    completion?(.success(responseData))
                    
                } catch let error {
                    completion?(.failure(ApiCustomError.invalidData))
                    self.manageErrors(apiName: method.methodName, error: error, isShowAlert: false)
                }
                break
                
            case .failure(let error):
                
                if (error as NSError).code == NSURLErrorCancelled {
                    // Manage cancellation here
                    self.manageErrors(apiName: method.methodName, error: error, isShowAlert: false)
                    completion?(.failure(error))
                    return
                }
                
                self.manageErrors(apiName: method.methodName, error: error, isShowAlert: isErrorAlert)
                completion?(.failure(error))
                break
            }
        }
        
        requests.append((method,request))
    }
    
    func makeRequestArrayOfDict(method: ApiEndPoints,
                                methodType: HTTPMethod = .post,
                                parameter : [Dictionary<String,Any>],
                                withErrorAlert isErrorAlert : Bool = true,
                                withLoader isLoader : Bool = true,
                                withdebugLog isDebug : Bool = true,
                                withToken       : Bool = true,
                                withBlock completion :((Swift.Result<DataResult,Error>) -> Void)?) {
        
        
        //Assign Value to Moya Parameters
        self.path = method.methodName
        //        self.parameters = parameter
        self.method = methodType
        
        setHeaders(withToken: withToken)
        
        if isLoader {
            self.addLoader()
        }
        
        //        let bottomLoader = (parameter.keys.contains("page") ?? false  && (parameter?["page"] as! String) != "1")
        //        if bottomLoader
        //        {
        //            GradientLoadingBar.shared.show()
        //        }
        
        DispatchQueue.main.async {
            UIApplication.shared.isNetworkActivityIndicatorVisible = true
        }
        
        if isDebug {
            self.manageDebugRequest(parameters: self.parameters)
        }
        
        let request = provider.request(self) { (result) in
            
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
            self.removeLoader()
            
            switch result {
            
            case .success(let response):
                
                if response.statusCode == 401 {
                    self.logout()
                    completion?(.failure(ApiCustomError.sessionExpire))
                }
                
                do {
                    guard let res = try response.mapJSON() as? String else {
                        return
                    }
                    
                    var code = ApiKeys.ApiStatusCode.invalidOrFail
                    
                    let resDic  = JSON(response.data)
                    
                    //                       if isDebug {
                    //                           self.manageDebugResponse(encryptedString: res, responseDic: resDic)
                    //                       }
                    
                    if let codeint = ApiKeys.ApiStatusCode.init(rawValue: String(resDic["statusCode"].intValue)) {
                        code = codeint
                    }
                    
                    let responseData = DataResult(data: resDic[ApiKeys.respsone(.data).value],
                                                  httpCode: response.statusCode,
                                                  apiCode: code,
                                                  message: resDic[ApiKeys.respsone(.message).value].stringValue,
                                                  success : resDic["success"].boolValue
                                                  )
                    
                    completion?(.success(responseData))
                    
                } catch let error {
                    completion?(.failure(ApiCustomError.invalidData))
                    self.manageErrors(apiName: method.methodName, error: error, isShowAlert: false)
                }
                break
                
            case .failure(let error):
                
                if (error as NSError).code == NSURLErrorCancelled {
                    // Manage cancellation here
                    self.manageErrors(apiName: method.methodName, error: error, isShowAlert: false)
                    completion?(.failure(error))
                    return
                }
                
                self.manageErrors(apiName: method.methodName, error: error, isShowAlert: isErrorAlert)
                completion?(.failure(error))
                break
            }
        }
        
        requests.append((method,request))
    }
    
    func makeRequestWithModel<T: mappable>(method: ApiEndPoints,
                                           modelType : T.Type,
                                           methodType: HTTPMethod = .post,
                                           responseModelType: ResponseModelType = .dictonary,
                                           parameter: Dictionary<String,Any>?,
                                           withErrorAlert isErrorAlert: Bool = true,
                                           withLoader isLoader: Bool = true,
                                           withToken       : Bool = true,
                                           withdebugLog isDebug: Bool = true,
                                           withBlock completion: ((Swift.Result<DataResultModel<T>,Error>) -> Void)?)  {
        
        
        //Assign Value to Moya Parameters
        self.path = method.methodName
        self.parameters = parameter
        self.method = methodType
        
        
        setHeaders(withToken: withToken)
        
        if isLoader {
            self.addLoader()
        }
        
        let bottomLoader = (parameter?.keys.contains("page") ?? false  && (parameter?["page"] as! String) != "1")
        if bottomLoader
        {
            GradientLoadingBar.shared.show()
        }
        
        DispatchQueue.main.async {
            UIApplication.shared.isNetworkActivityIndicatorVisible = true
        }
        
        if isDebug {
            self.manageDebugRequest(parameters: self.parameters)
        }
        
        
        let request = provider.request(self) { (result) in
            
            DispatchQueue.main.async {
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
                self.removeLoader()
                GradientLoadingBar.shared.hide()
            }
            
            
            switch result {
            
            case .success(let response):
                
                if response.statusCode == 401 {
                    self.logout()
                    
                    return
                }
                
                do {
                    //                       guard let res = try response.mapJSON() as? String else {
                    //                           return
                    //                       }
                    //
                    var code = ApiKeys.ApiStatusCode.invalidOrFail
                    
                    let resDic  = JSON(response.data)
                    
                    //                       if isDebug {
                    //                           self.manageDebugResponse(encryptedString: res, responseDic: resDic)
                    //                       }
                    
                    
                    if let codeint = ApiKeys.ApiStatusCode.init(rawValue: resDic["statusCode"].stringValue) {
                        
                        code = codeint
                    }
                    
                    var responseData = DataResultModel<T>.init()
                    
                    switch responseModelType {
                    
                    case .dictonary:
                        responseData.data = modelType.init(fromJson: resDic[ApiKeys.respsone(.data).value])
                        break
                    case .array:
                        //                        responseData.data = modelType.init(fromJson: resDic[ApiKeys.respsone(.data).value]["result"]) // If response["data"] is not array type then
                        responseData.data = modelType.init(fromJson: resDic[ApiKeys.respsone(.data).value]) // if data has direct array value use this
                        break
                        
                    }
                    
                    responseData.message = resDic[ApiKeys.respsone(.message).value].stringValue
                    responseData.apiCode = code
                    responseData.httpCode = response.statusCode
                    responseData.response = resDic
                    responseData.success = resDic["success"].boolValue
                    completion?(.success(responseData))
                    
                } catch let error {
                    self.manageErrors(apiName: method.methodName, error: error, isShowAlert: false)
                }
                break
                
            case .failure(let error):
                
                if (error as NSError).code == NSURLErrorCancelled || (error as MoyaError)._code == 6{
                    // Manage cancellation here
                    self.manageErrors(apiName: method.methodName, error: error, isShowAlert: false)
                    completion?(.failure(error))
                    return
                }
                
                self.manageErrors(apiName: method.methodName, error: error, isShowAlert: isErrorAlert)
                completion?(.failure(error))
                break
                
            }
        }
        requests.append((method,request))
    }
    
}

