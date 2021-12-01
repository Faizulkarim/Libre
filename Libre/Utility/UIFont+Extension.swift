//
//  UIFont+Extension.swift
//  Ghaf
//
//  Created by Ashish on 11/06/19.
//  Copyright © 2019 Hyperlink. All rights reserved.
//

import UIKit

extension UIFont {
    
    /**
     To get the UIFont
     
     - Parameter fontType: Family of the font
     - Parameter fontSize: Size of the font
     - Parameter isAspectRatio: You want to increase/decrease the font size according to device?
     
     - Returns: UIFont
     
     */
    class func applyFont(fontType : CustomFont = CustomFont.FontRegular , fontSize : CGFloat, _ isAspectRatio : Bool = true) -> UIFont {
        
        if isAspectRatio {
            if let font = UIFont.init(name: fontType.rawValue, size: fontSize * kFontAspectRatio){
                return font
            }
            return UIFont.systemFont(ofSize: fontSize)
        }
        if let font = UIFont.init(name: fontType.rawValue, size: fontSize){
            return font
        }
        return UIFont.systemFont(ofSize: fontSize * kFontAspectRatio)
    }
    
    class func customFont(ofType type: CustomFont, withSize size: CGFloat) -> UIFont {
          let fontSize = UIDevice.current.userInterfaceIdiom == .phone ? size : size + 8
        let fontToSet = UIFont.init(name: type.rawValue, size: fontSize * kFontAspectRatio)
          //        if #available(iOS 11.0, *) {
          //            return UIFontMetrics.default.scaledFont(for: fontToSet)
          //        } else {
          // Fallback on earlier versions
        return fontToSet!
          //        }
      }
}
