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
           "device_token" : "4389324956926396263"
       ]
       print(params)
       
       ApiManager.shared.makeRequest(method:.user(.updateDeviceToken), methodType: .post, parameter: params, withErrorAlert: true, withLoader: true, withdebugLog: true) { (result) in
           
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
    
   
    
}
