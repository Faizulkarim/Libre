//
//  ThemeStyle.swift
//  FormatStyle
//
//  Created by  on 14/07/19.
//  Copyright © 2019 . All rights reserved.
//

import UIKit

// Add paramters based on your requirement
struct ThemeStyle {
    var textColor : UIColor?
    var backGroundColor: UIColor?
    var fontName : CustomFont?
    var fontSize : CGFloat?
}

// Make your own theme
// Create theme only if your application has global theme

enum Theme {
    case header
    case subtitle
    case caption1
    case caption2
    case caption3
    
    var theme : ThemeStyle {
        switch self {
        case .header:
            return ThemeStyle(textColor: .white, backGroundColor: UIColor.red, fontName: .FontRegular, fontSize: 20.0)
        case .subtitle:
            return ThemeStyle(textColor: .green, backGroundColor: nil, fontName: .FontRegular, fontSize: 13.0)
        case .caption1:
            return ThemeStyle(textColor: UIColor.ColorTextColor, backGroundColor: UIColor.ColorTextColor, fontName: .FontRegular, fontSize: 13.0)
        case .caption2:
            return ThemeStyle(textColor: UIColor.ColorTextColor, backGroundColor: UIColor.ColorTheme, fontName: .FontRegular, fontSize: 13.0)
        case .caption3:
            return ThemeStyle(textColor: .green, backGroundColor: nil, fontName: nil, fontSize: nil)
        }
    }
}



