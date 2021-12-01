//
//  UITextField+Extension.swift
//  BasicStructure
//
//  Created by Hyperlink on 07/08/19.
//  Copyright © 2019 Hyperlink. All rights reserved.
//

import UIKit

var kRegex = "kRegex"

extension UITextField: UITextFieldDelegate {
//    public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
//        
//        let char = string.cString(using: String.Encoding.utf8)!
//        let isBackSpace = strcmp(char, "\\b")
//        
//        if (isBackSpace == -92) {
//            return true
//        }
//        
//        let textFieldText: NSString = self.text!as NSString
//        let txtAfterUpdate = textFieldText.replacingCharacters(in: range, with: string)
//        
//        if regex != nil {
//            if regex?.trim() != "" {
//                let test = NSPredicate(format: "SELF MATCHES %@", regex!)
//                if test.evaluate(with: txtAfterUpdate) {
//                    return true
//                }
//                return false
//            }
//            return true
//        }else {
//            return true
//        }
//    }
    
    var regex : String? {
        set{
            self.delegate = self
            objc_setAssociatedObject(self, &kRegex, newValue, .OBJC_ASSOCIATION_RETAIN)
        }
        get{
            return objc_getAssociatedObject(self, &kRegex) as? String
        }
    }

    func setRightImage(img : UIImage) {
        let imgView = UIImageView(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
        imgView.image = img
        imgView.contentMode = .center
        self.rightView = imgView
        self.rightViewMode = .always
    }
    func setBorderWithCornerRedious(cornerRedius: CGFloat, borderWidth: CGFloat, borderColor: CGColor){
        self.layer.cornerRadius = cornerRedius
        self.layer.borderWidth = borderWidth
        self.layer.borderColor = borderColor
    }
}
extension UISearchBar {
    
    func change(textFont : UIFont?) {
        
        for view : UIView in (self.subviews[0]).subviews {
            
            if let textField = view as? UITextField {
                textField.font = textFont
            }
        }
    }
    
}
extension UITextField {
    func setLeftPaddingPoints(_ amount:CGFloat){
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.leftView = paddingView
        self.leftViewMode = .always
    }
    func setRightPaddingPoints(_ amount:CGFloat) {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.rightView = paddingView
        self.rightViewMode = .always
    }
}


