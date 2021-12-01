//
//  ApiEndPoints.swift
//  NewApiManager
//
//  Created by Hyperlink on 17/06/19.
//  Copyright © 2019 Hyperlink. All rights reserved.
//

import UIKit

/// ApiEndPoints - This will be main api points
enum ApiEndPoints {
    
    case user(User)
    case auth(Auth)
    
    var methodName : String {
        
        switch self {
            
        case .user(let user):
            return "/api/" + user.rawValue
            
        case .auth(let auth):
            return "api/auth/" + auth.rawValue
        }
    }    
}

enum User : String {
    case updateProfile                        = "updateProfile"
    case userProfile                          = "getProfileInfo"
    case preferredLoveList                    = "preferredLoveList"
    case getuserImages                        = "getUserImages"
    case uploaduserImages                     = "profileImageUpload"
    case updateDeviceToken                    = "updateDeviceToken"
    case peopleNerarby                        = "getUserByLocation"
    case deleteImage                          = "deleteImage"
  
}

enum Auth : String {
    case signup                             = "signup"
    case login                              = "signin"
    case verify                             = "phoneNumberVerify"
    case resendOtp                          = "resendOtp"
    case saveuserData                         = "updateInitialProfile"
    case setNewPassword                       = "updatePassword"
    case signout                              = "signout"
    case backgroundImage                      = "getBackgroundImages"


}
