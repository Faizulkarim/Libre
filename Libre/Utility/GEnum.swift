//
//  GEnum.swift
//  Ghaf
//
//  Created by Hyperlink on 01/05/19.
//  Copyright © 2019 Hyperlink. All rights reserved.
//

import UIKit
import Foundation

/**
 Enum of Custom Font which is need in project
 
 */
enum CustomFont : String {
    
    case FontRegular                          = "Inter-Regular"
    case FontMedium                           = "Inter-Medium"
    case FontBold                             = "Inter-Bold"
    case FontExtraBold                        = "Inter-ExtraBold"
//    case Tarja_Pro3_light                         = "TrajanPro3Light"
//    case Tarja_Pro3_Bold                       = "trajan-pro-3_942"
//    case Tarja_Pro3_regular                   = "trajan-pro-3"
}

struct myCallId {
   static var callId = 0
}
struct Platform {
    static let isSimulator: Bool = {
        var isSim = false
        #if arch(i386) || arch(x86_64)
        isSim = true
        #endif
        return isSim
    }()
}

enum AppCredential : String {
    
    case facebookAppID  = "389804939103226"
    case googlePlaceID  = "AIzaSyCzut__RC7GSK3pJRMmxKJNOgfHwCsHZ5Y"
    case googleClientID = "159577427637-10sdsrhs5khdrmeoc6f1ece2opbgsvla.apps.googleusercontent.com"
}

enum UserDefaultsKeys : String {
    case kAccessToken                           = "kAccessToken"
    case kLoginUserData                         = "kLoginUserData"
    case kUserSession                           = "kUserSession"
    case kIsTutorial                            = "kIsTutorial"
    case kIsLogin                               = "kIsLogin"
    case kSignUpUserData                        = "kSignUpUserData"
    case kDeviceToken                           = "kDeviceToken"
    case kVoipToken                             = "kVoipToken"
    case kMobilenumber                          = "kMobileNumber"
    case kPassword                              = "kPassword"

}

//Enum for dateformatter
enum DateTimeFormaterEnum : String{
    case MMM_d_Y                                = "MMM d, yyyy"
    case MMM_yyyy                               = "MMM yyyy"
    case HHmmss                                 = "HH:mm:ss"
    case hhmma                                  = "hh:mma"
    case hmma                                   = "h:mm a"
    case HHmm                                   = "HH:mm"
    case dmmyyyy                                = "d/MM/yyyy"
    case UTCFormat                              = "yyyy-MM-dd"
    case ddmm_yyyy                              = "dd MMM, yyyy"
    case dmm_yyyy                               = "d MMM, yyyy"
    case dmmyyyy2                               = "d MMM yyyy"
    case WeekDayhhmma                           = "EEE,hh:mma"
    case hhMMA                                  = "hh:mm a"
    case dd_MM_YYYY                             = "dd/MM/yyyy"
    case dd_MM                                  = "dd/MM"
    case dd_MMMM_YYYY                           = "dd MMMM, yyyy"
    case MMMM_YYYY                              = "MMMM, yyyy"
    case dd_MMM_YYYY                            = "dd MMM yyyy"
    case SystemDate                             = "yyyy-MM-dd HH:mm:ss Z"
    case ddMMYYYY                               = "dd MM yyyy"
    case dd_MMM                                 = "dd MMM"
    case YYYY_MM_dd_hhMMA                       = "yyyy-MM-dd hh:mm a"
    case YYYY_MM_dd_HHMM                        = "yyyy-MM-dd HH:mm"
    case YYYY_MM_dd_HHMMSS                      = "yyyy-MM-dd HH:mm:ss"
    case Monthdd                                = "MMMM dd"
    case Day                                    = "EEEE"
    case Day_SortName                           = "E"
    case UTC_T_Cal                              = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
    case NodeUTCFormat                          = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
    
}
enum AlertButtonType {
    case OnlyOk
    case OkCancel
    case YesNo
}

enum ValidationEnum {
    enum RegexType : String {
        case AlpabetsAndSpace = "^[A-Za-z ]*$"
        case OnlyNumber = "[0-9]"
        case UserId = "^[a-z][a-z0-9._]*$"
        case AllowDecimal = "^[0-9]*((\\.|,)[0-9]{0,2})?$"
    }
    
    enum PhoneNumber : Int {
        case Minimum = 8
        case Maximum = 10
    }
    
    enum Pincode : Int {
        case Maximum = 6
    }
    
    enum Password : Int {
        case Minimum = 4
    }
    
    enum CardNumber : Int {
        case Minimum = 14
        case Maximum = 16
    }
    
    enum SecurityCode : Int {
        case Minimum = 3
        case Maximum = 4
    }
    
    enum ItemPriceCost : Int {
        case Maximum = 8
    }
}

enum PaymentType : String {
    case CARD = "CARD"
    case WALLET = "WALLET"
}

enum SearchPlaceholder : String {
    case Malls                =   "Search Malls"
    case Stores               =   "Search Stores"
    case Products             =   "Search Products"
}

enum OrderStatusType : String {
    
    case Requests            = "Requests"
    case Confirmed           = "Confirmed"
    case Pending             = "Pending"
    case InProgross          = "In progross"
    case ReadyForPickup      = "Ready For Pickup"
    case OnTheWay            = "On The Way"
    case Accepted            = "Accepted"
    case Delivered           = "Delivered"
    case Rejected            = "Rejected"
    case Cancelled           = "Cancelled"
    
}

enum URLlist : String {
    case terms     = "http://4shop.io/admin/home/terms_app"
    case privacy   = "http://4shop.io/home/privacy_policy_app"
    case aboutUsA  = "http://4shop.io/admin/home/about_app?lang=A"
    case aboutUsE  = "http://4shop.io/admin/home/about_app?lang=E"
    case faqA      = "http://4shop.io/admin/home/faq_app?lang=A"
    case faqE      = "http://4shop.io/admin/home/faq_app?lang=E"
    case CancelOrderA      = "http://4shop.io/admin/home/cancel_policy_app?lang=A"
    case CancelOrderE      = "http://4shop.io/admin/home/cancel_policy_app?lang=E"
}

enum NotificationTag : String {
    case orderRequestAccepted         = "order_request_Accepted"
    case orderRequestRejected         = "order_request_Rejected"
    case orderRequestPacked           = "order_request_Packed"
    case orderRequestCancelled        = "order_request_Cancelled"
    case orderRequestDelivered        = "order_request_Delivered"
    case orderRequeston_the_way       = "order_request_on_the_way"
    case orderRequestpickup           = "order_request_pickup"
    case updateProductrice            = "update_product_price"
}
enum AgroraCredintial : String {
    case AgoraAppId = "52eaf51aa1d24ec0a9fcbd06155dec52"
    case AgoraToken = "00652eaf51aa1d24ec0a9fcbd06155dec52IACQpT3gR0Nsg742JJ7vWePErUWRG0oNR9WI3+kfaZZa69bmOcIAAAAAEADri2/Q2I3AYQEAAQDZjcBh"
}


enum SignUpStep : String {
    
    case agreeTerms      = "agree_terms"
    case done            = "done"
}

enum OTPScreenFor {
    case login, signup
}


