//
//  Validation.swift
//  
//
//  Created by  on 17/01/18.
//  Copyright © 2018    . All rights reserved.
//

import UIKit

class Validation: NSObject {
    
    //--------------------------------------------------------------------------------------
    
    static func isAlphabaticString(txt: String)         -> Bool {
        
        let RegEx   = "[A-Za-z]+"
        let eTest   = NSPredicate(format:"SELF MATCHES %@", RegEx)
        let result  = eTest.evaluate(with: txt)
        return result;
    }
    
    //--------------------------------------------------------------------------------------
    
    static func isAlphabaticStringWithSpace(txt: String)         -> Bool {
        
        let RegEx   = "[A-Za-z ]+"
        let eTest   = NSPredicate(format:"SELF MATCHES %@", RegEx)
        let result  = eTest.evaluate(with: txt)
        return result;
    }
    
    //------------------------------------------------------
    
    static func isAlphaNummericString(txt: String)      -> Bool {
        
        let RegEx   = "^[A-Za-z0-9 _]+$"
        let eTest   = NSPredicate(format:"SELF MATCHES %@", RegEx)
        let result  = eTest.evaluate(with: txt)
        return result;
    }
    
    //--------------------------------------------------------------------------------------
    
    static func isValidMiddleName(txt: String)          -> Bool {
        let RegEx   = "[A-Za-z]{1}+\\.?"
        let eTest   = NSPredicate(format:"SELF MATCHES %@", RegEx)
        let result  = eTest.evaluate(with: txt)
        debugPrint("str : \(txt) validation : \(result)")
        return result
    }
    
    //--------------------------------------------------------------------------------------
    
    static func isValidFirstName(txt: String)           -> Bool {
        let RegEx   = "^[A-Z][a-z]*$"
        let eTest   = NSPredicate(format:"SELF MATCHES %@", RegEx)
        let result  = eTest.evaluate(with: txt)
        debugPrint("str : \(txt) validation : \(result)")
        return result
    }
    
    //--------------------------------------------------------------------------------------
    
    static func isValidAgeRangeName(txt: String)        -> Bool {
        let RegEx   = "^(0?[1-9]|[1-9][0-9])$"
        let eTest   = NSPredicate(format:"SELF MATCHES %@", RegEx)
        let result  = eTest.evaluate(with: txt)
        debugPrint("str : \(txt) validation : \(result)")
        return result
    }
    
    //--------------------------------------------------------------------------------------
    
    static  func isValidEmail(testStr:String)           -> Bool {
        let emailRegEx  = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        //"^[_A-Za-z0-9-]+(\\.[_A-Za-z0-9-]+)*@[A-Za-z0-9]+[A-Za-z0-9-]+(\\.[A-Za-z0-9]+)*(\\.[A-Za-z]{2,4})$"
//        "[\u0621-\u064A\u0660-\u0669a-zA-Z0-9\+\.\_\%\-\+]{1,256}\@[\u0621-\u064A\u0660-\u0669a-zA-Z0-9][\u0621-\u064A\u0660-\u0669a-zA-Z0-9\-]{0,64}(\.[\u0621-\u064A\u0660-\u0669a-zA-Z0-9][\u0621-\u064A\u0660-\u0669a-zA-Z0-9\-]{0,25})+"
        let emailTest   = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        let result  = emailTest.evaluate(with: testStr)
        return result
    }
    
    //--------------------------------------------------------------------------------------
    
    static func isValidNumber(txt: String)              -> Bool {
        
        let RegEx   = "^((\\+)|(00))[0-9]{10,13}$"
        let eTest   = NSPredicate(format:"SELF MATCHES %@", RegEx)
        let result  = eTest.evaluate(with: txt)
        return result;
    }
    
    //--------------------------------------------------------------------------------------
    
    static func isValidOTP(txt: String)              -> Bool {
        
        let RegEx   = "^[0-9]{1}$"
        let eTest   = NSPredicate(format:"SELF MATCHES %@", RegEx)
        let result  = eTest.evaluate(with: txt)
        return result;
    }
    
    //--------------------------------------------------------------------------------------
    
    
    static func isValidPostalCode(txt: String)          -> Bool {
        
        let RegEx   = "^[A-Za-z0-9- ]{1,10}$"
        debugPrint(txt)
        let eTest   = NSPredicate(format:"SELF MATCHES %@", RegEx)
        let result  = eTest.evaluate(with: txt)
        return result;
    }
    
    //--------------------------------------------------------------------------------------
    
    static func isValidBankInfoStartCode(txt: String)   -> Bool {
        
        let RegEx   = "[A-Za-z0-9]+"
        let eTest   = NSPredicate(format:"SELF MATCHES %@", RegEx)
        let result  = eTest.evaluate(with: txt)
        return result;
    }
    
    //--------------------------------------------------------------------------------------
    
    static func isValidBankInfoCode(txt: String) -> Bool {
        
        let RegEx   = "[A-Za-z0-9- ]+"
        let eTest   = NSPredicate(format:"SELF MATCHES %@", RegEx)
        let result  = eTest.evaluate(with: txt)
        return result;
    }
    
    static func isValidMobileTextChange(testStr:String) -> Bool
    {
        let nameRegEx = "[0-9]*"
        let nameTest = NSPredicate(format:"SELF MATCHES %@", nameRegEx)
        return nameTest.evaluate(with: testStr)
    }
    
    static func isValidPasssword(txt: String) -> Bool {
        
        let RegEx   = "^(?=.*[A-Za-z])(?=.*\\d)(?=.*[$@$!%*#?&])[A-Za-z\\d$@$!%*#?&]{6,}$"
        debugPrint(txt)
        let eTest   = NSPredicate(format:"SELF MATCHES %@", RegEx)
        let result  = eTest.evaluate(with: txt)
        return result;
        
        // https://stackoverflow.com/questions/39284607/how-to-implement-a-regex-for-password-validation-in-swift
    }
    
    static func isValidTextView(textView: UITextView) -> Bool {
        guard let text = textView.text, !text.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).isEmpty else {
            // this will be reached if the text is nil (unlikely)
            // or if the text only contains white spaces
            // or no text at all
            return false
        }
        
        return true
    }
}

enum ValidationMessage : String {
        
    case ErrorOTP                           = "Please enter valid OTP"
    case ErrorName                          = "Please enter name"
    case ErrorEmptyCode                     = "Please select code"
    case ErrorEmptyMobileNumber             = "Please enter phone number"
    case ErrorMobileNumberValidation        = "Please enter valid phone number"
    
    case ErrorPrefarance                    = "Please Choose from list"
    case ErrorEmail                         = "Please enter valid email"
    case ErrorPassword                      = "Please enter password"
    case ErrorEnterEmail                    = "Please enter email"
    case ErrorContactReason                 = "Please enter detail"
    case ImageError                         = "Please select an Image"
    
    case InvalidPassword                    =   "Please enter minimum %@ characters for password"
    case ErrorConfirmPassword               =   "Please enter confirm password"
    case ErrorPasswordMismatch              =   "Password mismatch"
       
    case EnterCity                           = "Please select city"
    case EnterState                          = "Please select state"
    case EnterAreaStreet                     = "Please enter area"
    case EnterSlot                           = "Please enter slot"
    case Enterblock                           = "Please enter block"
    case EnterAvenue                         = "Please enter avenue"
    case EnterStreet                         = "Please enter street"
    case EnterAlterNative                    = "Please enter alternative number"
    case EnterLandmark                       = "Please enter near by landmark"
    case selectHouseType                     = "Please select house type"
    case EnterHouseNo                        = "Please enter house number"
    case EnterBuilding                       = "Please enter building number"
    case EnterFloorno                        = "Please enter floor number"
    case EnterFlat                           = "Please enter flat number"
    case EnterAppt                           = "Please enter appartment number"
    
    case LocationStatus                      = "App needs access to your location. Turn on Location Services in your device settings."
    case EnterReview                         = "Please share your experience"
    case ErrorCode                           = "Please enter coupan code"
    case ErrorSelectAdd                      = "Please select address for delivery"
    
    case EnterCardHolderName              = "Please enter card holder name"
    case EnterCardNumber                  = "Please enter card number"
    case EnterValidCardNumber             = "Please enter valid card number"
    case EnterCardExpiryDate              = "Please enter expiry date"
    case EnterValidExpiryDate             = "Please enter valid expiry date"
    case EnterCVV                         = "Please enter CVV "
    case EnterValidCVV                    = "Please enter valid CVV"
    
    case EmptyCart                        = "Your cart is empty"
    case EmptySelectAttb                  = "Please select atleast one attibute"
    case EmptyProductDetail               = "Product detail is not avilable"
    case ErrorLoginAlert                  = "To proceed you need to login, Do you want to Login now?"
    
    //====================================================================================//
    
    case ErrorEmptyDataSetTitle             = "Sorry, nothing found here."
    case ErrorEmptyDataSetDiscription       = "Please upload image."
    case Logout                             = "Are you sure want to logout?"
    
    case ErrorSelectCategory                 = "Please select category"
    case ErrorSelectSubCategory              = "Please select sub category"
    case ErrorSelectSubSubCategory           = "Please select sub subcategory"
    case ErrorQty                            = "Please add qty"
    case ErrorTitle                          = "Please enter title"
    case ErrorDiscr                          = "Please enter description"
    case ErrorMinQty                         = "Minimum qty can be 1";
    
    case ErrorOldPassword                    = "Please enter current password"
    case ErrorNewPassword                    = "Please enter new password"
    case ErrorGiveReview                     = "Please give review"
    
    case ErrorNoPermission                   = "You can not change password, because you are sign in with Google/Facebook/Apple"
}
