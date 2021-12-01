//
//  GConstants.swift
//  Ghaf
//
//  Created by Hyperlink on 01/05/19.
//  Copyright © 2019 Hyperlink. All rights reserved.
//

import UIKit

let kAppName                                     = "Libre"
let kTHEMECOLOR                                  =  UIColor.ColorTheme
let kTABNAV                                      = "navTabbar"
let kAUTHNAV                                     = "AuthanticationNav"
let kLANGNAV                                     = "LanguageNav"


let kNAVHOME                                     = "Home"
let kNAVMENU                                     = "NavMenu"
let kNAVFAVORITES                                = "NAVFAVORITES"
let kNAVNOTIFICATION                             = "NAVNOTIFICATION"
let kNAVACCOUNT                                  = "NAVACCOUNT"
var isWalkthrough                               = "walkthrough"
var kLanguageCode                               =  Locale.current.languageCode

//MARK: - Screen (Width - Height)
let kScreenWidth                                =  UIScreen.main.bounds.size.width
let kScreenHeight                               =  UIScreen.main.bounds.size.height
var kRatio                                      =  "kRatio"
var kAuthFlag                                   = "isAuth"
var kWindow: UIWindow {
    return UIApplication.shared.windows.first!
}
var kSettings                                   =  "Settings"

var xCenter                                     = 0
var SendBirdApikey = "20F9287C-FCC4-4BEB-AC0A-DC2E33ABE40C"

//MARK: - For getting Aspect Ration of screen
var kFontAspectRatio : CGFloat {
    if UIDevice().userInterfaceIdiom == .pad {
        return kScreenHeight / 667
    }
    return kScreenWidth / 375
}

var kHeightMultiplier : CGFloat{
    return kScreenHeight / 667
}

var kWidthMultiplier : CGFloat {
    return kScreenWidth / 375
}

var kProductHeight : CGFloat {
    return 93.5 * kHeightMultiplier
}

var isIphoneX : Bool {
    if UIDevice().userInterfaceIdiom == .phone {
        switch UIScreen.main.nativeBounds.height {
        case 1136:
            print("iPhone 5 or 5S or 5C")
            return false
        case 1334:
            print("iPhone 6/6S/7/8")
            return false
        case 2208:
            print("iPhone 6+/6S+/7+/8+")
            return false
        case 2436:
            print("iPhone X")
            return true
        default:
            print("unknown")
            return false
        }
    }
    return false
}

//let kLanguage_en                                = "en"
//let KHeaderLanguageEnglish                      = "english"
//
//let kLanguage_ar                                = "ar"
//let KHeaderLanguageArabic                       = "arabic"

let kLineSpacing                         : CGFloat = 8.0

// Font Size
let kFontSize9                           : CGFloat = 9.0
let kFontSize8                           : CGFloat = 8.0
let kFontSize7                           : CGFloat = 7.0
let kFontSize10                          : CGFloat = 10.0
let kFontSize11                          : CGFloat = 11.0
let kFontSize12                          : CGFloat = 12.0
let kFontSize13                          : CGFloat = 13.0
let kFontSize14                          : CGFloat = 14.0
let kFontSize15                          : CGFloat = 15.0
let kFontSize16                          : CGFloat = 16.0
let kFontSize17                          : CGFloat = 17.0
let kFontSize18                          : CGFloat = 18.0
let kFontSize19                          : CGFloat = 19.0
let kFontSize20                          : CGFloat = 20.0
let kFontSize22                          : CGFloat = 22.0
let kFontSize23                          : CGFloat = 23.0
let kFontSize24                          : CGFloat = 24.0
let kFontSize25                          : CGFloat = 25.0
let kFontSize26                          : CGFloat = 26.0
let kFontSize28                          : CGFloat = 28.0
let kFontSize30                          : CGFloat = 30.0
let kFontSize40                          : CGFloat = 40.0



var kCategoryType                               = 0

//MARK: - Title Constant

var kGallery : String {
    return "Gallery"
}

var kCamera : String {
    return "Camera"
}

var kYes : String {
    return "Yes"
}

var kNo : String {
    return "No"
}

var kOk : String {
    return "Ok"
}

var kCancel : String {
    return "Cancel"
}

var isIPad : Bool {
    return UIDevice().userInterfaceIdiom == .pad
}

var kSignupLoginText : String {
    return "Signup and Login to use this option"
}

var currentTimezon: String {
    return TimeZone.current.identifier
}

//var currentDate: String {
//    return GFunction.shared.GetStringDateInAPIFormat(sourceDate: Date())
//}
//
//var currentTime: String {
//    return GFunction.shared.GetStringTimeInAPIFormat(sourceDate: Date())
//}

var loginType: String {
    return "S"
}

var fbLoginType: String {
    return "F"
}

var GoogleloginType: String {
    return "G"
}

var AppleLoginType: String {
    return "A"
}

var kReadMoreText : String {
    return " See More"
}

var kReadLessText : String {
    return " See Less"
}



