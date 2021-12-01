//
//  SettingViewController.swift
//  Libre
//
//  Created by piash sarker on 2/8/21.
//

import UIKit

class SettingViewController: UIViewController {
    @IBOutlet weak var changePasswordTapped: UIView!
    @IBOutlet weak var matchSettings: UIView!
    
    //MARK:- Memory Management Method
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    deinit {
        print("💥💥💥 SettingViewController Deinit💥💥💥")
    }
    
    //------------------------------------------------------
    //MARK:- Custom Method
    
    
    func setupView(){
        self.matchSettings.handleTapToAction {
            self.pushToMatchingViewController()
        }
        self.changePasswordTapped.handleTapToAction {
            self.pushToChangePasswordViewController()
        }
        
        
    }
    
    func pushToChangePasswordViewController(){
        let vc = ChangePasswordViewController.instantiate(fromAppStoryboard: .kMenuStoryboard)
      
        self.navigationController?.pushViewController(vc, animated: true)
    }
    func pushToMatchingViewController(){
        let vc = MatchSettingsViewController.instantiate(fromAppStoryboard: .kMenuStoryboard)
      
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    //------------------------------------------------------
    //MARK:- Action method
    

    @IBAction func goToHome(_ sender: Any) {
        GFunction.shared.setHomeScreen()
    }
    

    
    
    //------------------------------------------------------
    //MARK:- Life Cycle Method

    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.setGradientBackground(colors: [UIColor.colorFromHex(hex: 0x4D4347), UIColor.colorFromHex(hex: 0x5D4147)])

    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }

}
