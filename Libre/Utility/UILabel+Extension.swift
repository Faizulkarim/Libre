//
//  UILabel+Extension.swift
//  Mjnun
//
//  Created by Hyperlink on 26/08/19.
//  Copyright © 2019 Hyperlink. All rights reserved.
//

import Foundation
import UIKit
extension UILabel{
    open override func awakeFromNib() {
        super.awakeFromNib()
        self.text = self.text
    }
    func setAttributedStringFrom(fullString:String, attributedString:[String] , attributes : [NSAttributedString.Key : Any],attributedFullString : [NSAttributedString.Key : Any]){
        let str = fullString as NSString
        let attributedNewString = NSMutableAttributedString(string: fullString , attributes: attributedFullString)
        for obj in attributedString{
            let range = str.range(of: obj)
            attributedNewString.setAttributes(attributes, range: range)
        }
        self.attributedText = attributedNewString
    }
    func setAttributedString(_ arrStr : [String] , attributes : [[NSAttributedString.Key : Any]]) {
        let str = self.text!
        let attributedString = NSMutableAttributedString(string: str, attributes: [NSAttributedString.Key.font: self.font])
        
        for index in 0...arrStr.count - 1 {
            
            let attr = attributes[index]
            attributedString.addAttributes(attr, range: (str as NSString).range(of: arrStr[index]))
        }
        
        self.attributedText = attributedString
    }
    
    func addCharacterSpacing(kernValue: Double = 1.15) {
      if let labelText = text, labelText.count > 0 {
        let attributedString = NSMutableAttributedString(string: labelText)
          attributedString.addAttribute(NSAttributedString.Key.kern, value: kernValue, range: NSRange(location: 0, length: attributedString.length - 1))
        attributedText = attributedString
      }
    }
    
    
}
