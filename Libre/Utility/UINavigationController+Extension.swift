//
//  UINavigationController+Extension.swift
//  Ghaf
//
//  Created by Ashish on 11/06/19.
//  Copyright © 2019 Hyperlink. All rights reserved.
//

import UIKit

extension UITabBarItem {
    open override func awakeFromNib() {
        super.awakeFromNib()
        if let title = self.title {
            self.title = title
        }
    }
}

extension UINavigationController : UIGestureRecognizerDelegate {
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        interactivePopGestureRecognizer?.delegate = self
    }
    
    open override func awakeFromNib() {
        self.clearNavigation(foregroundColor: UIColor.white, fontType: CustomFont.FontRegular,fontSize: 16)
    }
    
    func clear() {
        self.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationBar.shadowImage = UIImage()
        self.navigationBar.barTintColor = UIColor.ColorTextColor
    }
    
    func clearNavigation(foregroundColor : UIColor? = UIColor.white, fontType : CustomFont = CustomFont.FontRegular, fontSize : CGFloat = kFontSize18, backGroundColor : UIColor = UIColor.clear) {
        
        self.navigationBar.titleTextAttributes =
            [NSAttributedString.Key.foregroundColor: foregroundColor!,
             NSAttributedString.Key.font: UIFont.applyFont(fontType: fontType, fontSize: fontSize, false)]
        
        
        self.navigationBar.barTintColor = foregroundColor
        self.navigationBar.backgroundColor = backGroundColor
        self.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationBar.isOpaque = true
        UIApplication.statusBarBackgroundColor = .clear
        self.navigationBar.isTranslucent = true
        self.navigationBar.barStyle = .default
        self.navigationBar.setValue(true, forKey: "hidesShadow")
    }
    
    func whiteNavigation(foregroundColor : UIColor? = UIColor.ColorTextColor, fontType : CustomFont = CustomFont.FontRegular, fontSize : CGFloat = kFontSize18, backGroundColor : UIColor = UIColor.white) {
        self.navigationBar.titleTextAttributes =
            [NSAttributedString.Key.foregroundColor: foregroundColor!,
             NSAttributedString.Key.font: UIFont.applyFont(fontType: fontType, fontSize: fontSize, false)]
        
        self.navigationBar.barTintColor = UIColor.ColorTextColor
        self.navigationBar.backgroundColor = backGroundColor
        self.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationBar.isOpaque = true
        UIApplication.statusBarBackgroundColor = .white
        self.navigationBar.isTranslucent = true
        self.navigationBar.barStyle = .default
        self.navigationBar.setValue(true, forKey: "hidesShadow")
    }
}

extension UINavigationItem {
    /*@IBInspectable var localizedTitle: String {
     get { return "" }
     set {
     self.title = NSLocalizedString(newValue, tableName: nil, bundle: GFunction.shared.getBundleName(), value: "", comment: "")
     }
     }*/
    open override func awakeFromNib() {
        self.titleView?.tintColor = UIColor.white
        if let text = self.title{
            self.title = text
        }
    }
}

extension UIBarButtonItem {
    
    open override func awakeFromNib() {
        self.tintColor = UIColor.white
        
        if let textValue = self.title {
            self.title = textValue
        }
    }
}

extension UIApplication {
    
    class var statusBarBackgroundColor: UIColor? {
        get {
            return statusBarUIView?.backgroundColor
        } set {
            statusBarUIView?.backgroundColor = newValue
        }
    }
    
    class var statusBarUIView: UIView? {
        if #available(iOS 13.0, *) {
            let tag = 987654321
            
            if let statusBar = UIApplication.shared.keyWindow?.viewWithTag(tag) {
                
                return statusBar
            }
            else {
                let statusBarView = UIView(frame: UIApplication.shared.statusBarFrame)
                statusBarView.tag = tag
                
                UIApplication.shared.keyWindow?.addSubview(statusBarView)
                return statusBarView
            }
        } else {
            if responds(to: Selector(("statusBar"))) {
                return value(forKey: "statusBar") as? UIView
            }
        }
        return nil
    }
}
extension UINavigationBar {
    func setGradientBackground(colors: [UIColor],
                               startPoint: UINavigationBarGradientView.Point = .topLeft,
                               endPoint: UINavigationBarGradientView.Point = .bottomLeft,
                               locations: [NSNumber] = [0, 1]) {
        guard let backgroundView = value(forKey: "backgroundView") as? UIView else { return }
        guard let gradientView = backgroundView.subviews.first(where: { $0 is UINavigationBarGradientView }) as? UINavigationBarGradientView else {
            let gradientView = UINavigationBarGradientView(colors: colors, startPoint: startPoint,
                                                           endPoint: endPoint, locations: locations)
            backgroundView.addSubview(gradientView)
            gradientView.setupConstraints()
            return
        }
        gradientView.set(colors: colors, startPoint: startPoint, endPoint: endPoint, locations: locations)
    }
}

