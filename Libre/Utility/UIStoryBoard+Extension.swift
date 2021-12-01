//
//  UIStoryBoard+Extension.swift
//  Ghaf
//
//  Created by Ashish on 11/06/19.
//  Copyright © 2019 Hyperlink. All rights reserved.
//

import UIKit

extension UIStoryboard{
    

    
    static let kLoginStoryboard                 = UIStoryboard(name: "Main", bundle: nil)
    static let kTabbarStoryboard                = UIStoryboard(name: "Tabbar", bundle: nil)
    static let kMenuStoryboard                = UIStoryboard(name: "menu", bundle: nil)
    func viewController<T : UIViewController>(viewControllerClass : T.Type, function : String = #function, line : Int = #line, file : String = #file) -> T {
        
        let storyboardID = (viewControllerClass as UIViewController.Type).storyboardID
        
        guard let scene = self.instantiateViewController(withIdentifier: storyboardID) as? T else {
            
            fatalError("ViewController with identifier \(storyboardID), not found in \(self) Storyboard.\nFile : \(file) \nLine Number : \(line) \nFunction : \(function)")
        }
        
        return scene
    }
}
