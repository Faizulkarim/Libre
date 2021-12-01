//
//  TabbarMainVC.swift
//  Convenient Cuts
//
//  Created by apple on 28/08/19.
//  Copyright © 2019 apple. All rights reserved.
//

import UIKit
import Foundation

class TabbarMainVC: UITabBarController {
        
    //MARK:- Class Variable
    let vwBack = UIView()

    //MARK: - Memory Managment Method -
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    //--------------------------------------------------------------------------------------
    
    deinit {}
    
    //--------------------------------------------------------------------------------------
    
    //MARK: - View Life Cycle Method -
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tabBar.backgroundColor = .white
        self.tabBar.backgroundImage = UIImage()
        self.tabBar.shadowImage = UIImage()
        
        self.tabBar.tintColor = UIColor.ColorTheme
        
        vwBack.backgroundColor = .clear
        self.view.addSubview(vwBack)
        self.view.bringSubviewToFront(tabBar)
        self.viewDidLayoutSubviews()
        
        self.delegate = self
    }
    //--------------------------------------------------------------------------------------
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    //--------------------------------------------------------------------------------------
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        let path = UIBezierPath(roundedRect: CGRect(x: 0, y: 0, width: view.frame.width, height: tabBar.frame.height), byRoundingCorners: [.topRight, .topLeft], cornerRadii: CGSize(width: 15.0, height: 15.0))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        tabBar.layer.mask = mask
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.vwBack.frame = tabBar.frame
        self.vwBack.roundCornersWithShdow(corners: [.topLeft,.topRight], radius: 0.0, shdowColor: UIColor.ColorGrey)
    }

}

extension TabbarMainVC : UITabBarControllerDelegate{
    
//    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
//
//        switch viewController {
//
//        case self.viewControllers?[1], self.viewControllers?[2] ,self.viewControllers?[0] :
//            if UserDefaults.standard.value(forKey: UserDefaultsKeys.kIsLogin.rawValue) as? Bool == false {
//                return false
//            }
//            break
//        default:
//            break
//        }
//
//        return true
//    }
}
