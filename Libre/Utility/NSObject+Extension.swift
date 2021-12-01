//
//  NSObject+Extension.swift
//  Ghaf
//
//  Created by Ashish on 07/06/19.
//  Copyright © 2019 Hyperlink. All rights reserved.
//

import Foundation
import UIKit


extension NSObject {
    /**
     Set style to the button
     
     - Parameter titleLabelFont: To set Font of the title label
     - Parameter titleLabelColor: To set Color of the title label
     - Parameter cornerRadius: To set Corner Radius of the button
     - Parameter borderColor: To set Color of the border
     - Parameter borderWidth: To set Width of the border
     - Parameter backgroundColor: To set Backgroud Color of the button
     - Parameter state: To set above parameter to any specific State. Default is Normal State
     
     */
    func applyStyle(
        titleFont           : UIFont?  = nil
        , titleColor        : UIColor? = nil
        , cornerRadius      : CGFloat? = nil
        , borderColor       : UIColor? = nil
        , borderWidth       : CGFloat? = nil
        , backgroundColor   : UIColor? = nil
        , state             : UIControl.State = UIControl.State.normal
        , leftImage         : UIImage? = nil
        , rightImage        : UIImage? = nil
        ) {
        
        switch self {
        case is UIButton:
            /// Set Corner Radius to button
            let button = self as! UIButton
            if cornerRadius != nil {
                button.layer.cornerRadius = cornerRadius!
            }
            
            /// Set Border Color to button
            if borderColor != nil {
                button.layer.borderColor = borderColor?.cgColor
            }
            
            /// Set Border Width to button
            if borderWidth != nil {
                button.layer.borderWidth = borderWidth!
            }
            
            /// Set Font to title label
            if titleFont != nil {
                button.titleLabel?.font = titleFont
            }
            
            /// Set Color to title label
            if titleColor != nil {
                button.setTitleColor(titleColor, for: state)
            }
            
            /// Set Background Color to the button
            if backgroundColor != nil {
                button.backgroundColor = backgroundColor
            }
            break
            
        case is UILabel:
            let label = self as! UILabel
            /// Set Corner Radius to label
            if cornerRadius != nil {
                label.layer.cornerRadius = cornerRadius!
            }
            
            /// Set Border Color to label
            if borderColor != nil {
                label.layer.borderColor = borderColor?.cgColor
            }
            
            /// Set Background Color to label
            if backgroundColor != nil {
                label.backgroundColor = backgroundColor
            }
            
            /// Set Border Width to label
            if borderWidth != nil {
                label.layer.borderWidth = borderWidth!
            }
            
            /// Set Font to label
            if titleFont != nil {
                label.font = titleFont
            }
            
            /// Set Color to label
            if titleColor != nil {
                label.textColor = titleColor
            }
            break
            
        case is UITextField:
            let textField = self as! UITextField
            
            if cornerRadius != nil {
                textField.layer.cornerRadius = cornerRadius!
            }
            
            if borderColor != nil {
                textField.layer.borderColor = borderColor?.cgColor
            }
            
            if borderWidth != nil {
                textField.layer.borderWidth = borderWidth!
            }
            
            if titleFont != nil {
                textField.font = titleFont
            }
            
            if titleColor != nil {
                textField.textColor = titleColor
            }
        
            
            if rightImage != nil {
                textField.setRightImage(img: rightImage!)
            }
            break
            
        case is UITextView:
            let textView = self as! UITextView
            if cornerRadius != nil {
                textView.layer.cornerRadius = cornerRadius!
            }
            else {
                textView.layer.cornerRadius = 0
            }
            
            if borderColor != nil {
                textView.layer.borderColor = borderColor?.cgColor
            }
            
            if borderWidth != nil {
                textView.layer.borderWidth = borderWidth!
            }
            
            if titleFont != nil {
                textView.font = titleFont!
            }
            
            if titleColor != nil {
                textView.textColor = titleColor!
            }
            break
            
        default:
            break
        }
    }
}
