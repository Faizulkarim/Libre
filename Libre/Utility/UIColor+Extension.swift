//
//  UIColor+Extension.swift
//  Ghaf
//
//  Created by Ashish on 11/06/19.
//  Copyright © 2019 Hyperlink. All rights reserved.
//

import UIKit

extension UIColor {
    
    /**
     TO get the UIColor from Hexa code
     
     - Parameter hex: Hexa code of the color
     
     - Returns: UIColor
     
     */
    
    class func colorFromHex(hex: Int) -> UIColor { return UIColor(red: (CGFloat((hex & 0xFF0000) >> 16)) / 255.0, green: (CGFloat((hex & 0xFF00) >> 8)) / 255.0, blue: (CGFloat(hex & 0xFF)) / 255.0, alpha: 1.0)
    }
    
    class func colorFromHexWithAlpha(hex: Int, opacity:CGFloat) -> UIColor { return UIColor(red: (CGFloat((hex & 0xFF0000) >> 16)) / 255.0, green: (CGFloat((hex & 0xFF00) >> 8)) / 255.0, blue: (CGFloat(hex & 0xFF)) / 255.0, alpha: opacity)
    }
    
    static var ColorTheme                               : UIColor {return UIColor.init(named: "ThemeColor")! }
    static var ColorTextColor                           : UIColor {return UIColor.init(named: "TextColor")! }
    static var ColorGreen                               : UIColor {return UIColor.init(named: "Green")! }
    static var ColorRed                                 : UIColor {return UIColor.init(named: "Red")! }
    static var ColorBlue                                 : UIColor {return UIColor.init(named: "Blue")! }
    static var ColorYellow                                 : UIColor {return UIColor.init(named: "Yellow")! }
    static var ColorPlaceholder                         : UIColor {return UIColor.init(named: "Placeholder")! }
    static var ColorDarkGrey                            : UIColor {return UIColor.init(named: "ColorDarkGrey")! }
    static var ColorGrey                                : UIColor {return UIColor.init(named: "ColorGrey")! }
    static var Color647178                               : UIColor {return UIColor.init(named: "Color#647178")! }
    
    static var ColorBorderColor                         : UIColor {return UIColor.colorFromHex(hex: 0xE6E6E6) }
    static var ColorTextGrey                            : UIColor {return UIColor.colorFromHex(hex: 0x898E95) }
    static var ColorGrey2                               : UIColor {return UIColor.colorFromHex(hex: 0xF3F3F3) }
}
