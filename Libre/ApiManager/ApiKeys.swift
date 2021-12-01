//
//  ApiKeys.swift
//  NewApiManager
//
//  Created by Hyperlink on 17/06/19.
//  Copyright © 2019 Hyperlink. All rights reserved.
//

import UIKit


enum ApiKeys {
    case respsone(ApiResponseKey)
    case statusCode(ApiStatusCode)
    
    var value: String {
        switch self {

        case .respsone(let key):
            return key.rawValue
        case .statusCode(let key):
            return key.rawValue
      }
    }
}

/// Set All keys here
extension ApiKeys {
    
    //MARK:- API Key Constant
    internal enum ApiResponseKey: String {
        case data                               = "data"
        case message                            = "message"
        case code                               = "code"
        case list                               = "list"
    }
    
    //MARK:- APIStatusCodeEnum
    internal enum ApiStatusCode: String {
        case invalidOrFail                      = "401"
        case success                            = "200"
        case emptyData                          = "2"
        case inactiveAccount                    = "3"
        case otpVerify                          = "4"
        case emailVerify                        = "5"
        case forceUpdateApp                     = "6"
        case simpleUpdateAlert                  = "7"
        case socialIdNotRegister                = "11"
        case userSessionExpire                  = "-1"
        case unknown                            = "1000"
    }
}



