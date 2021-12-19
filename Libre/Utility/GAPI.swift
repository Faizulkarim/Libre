//
//  GAPI.swift
//  Village
//
//  Created by KISHAN_RAJA on 11/12/18.
//  Copyright © 2018 HYPERLINK. All rights reserved.
//

import Foundation
import UIKit

class GlobalAPI : NSObject {
    
    
    //MARK: - sharedInstance -
    static let shared   : GlobalAPI = GlobalAPI()
    
    var currentTimeZone: String { return TimeZone.current.identifier }
    
    //--------------------------------------------------------------------------------------
    
    //for update device data
    func APICallUpdateDeviceToken() {
       
       let params : [String : Any] = [
           "userId": UserModel.currentUser?.userId! as Any,
           "latitude" : LocationManager.shared.location.latitude.description,
           "longitude": LocationManager.shared.location.longitude.description,
           "voip_token" : GFunction.shared.getStringValueForKey(UserDefaultsKeys.kVoipToken.rawValue),
           "device_token" : GFunction.shared.getStringValueForKey(UserDefaultsKeys.kDeviceToken.rawValue)
       ]
       print(params)
       
       ApiManager.shared.makeRequest(method:.user(.updateDeviceToken), methodType: .post, parameter: params, withErrorAlert: true, withLoader: false, withdebugLog: true) { (result) in
           
        print(result)
           switch result {
           case .success(let apiData):
               print(result)
               switch apiData.apiCode {
               case .success:
                   print(apiData)
               default:
                   GFunction.shared.showSnackBar(apiData.message)
               }
               
           case .failure(let failedMsg):
               print(failedMsg)
               break
           }
       }
   }
    

    /// Mark:- Api call status changes
    ///
    ///
     func APICallStatusChange(status: Int, completion: @escaping (Bool) -> Void){
        let params : [String: Any] = [
            "callId" : myCallId.callId,
            "status" : status,
            "userId" : UserModel.currentUser?.userId! as Any
        ]
        
        print(params)
        
         ApiManager.shared.makeRequest(method:.user(.callStatus),methodType: .post, parameter: params, withLoader: false) { (result) in
            switch result {
            case .success(let apiData):
                print(result)
                switch apiData.apiCode {
                case .success:
                    let response = apiData.response
                    completion(true)
                    print(response)
                default:
                    GFunction.shared.showSnackBar(apiData.message)
                }
                
            case .failure(let failedMsg):
                print(failedMsg)
                break
            }
        }
    }
    
}
