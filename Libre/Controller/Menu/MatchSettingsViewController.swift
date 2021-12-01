//
//  MatchSettingsViewController.swift
//  Libre
//
//  Created by piash sarker on 2/8/21.
//

import UIKit

class MatchSettingsViewController: UIViewController {
    @IBOutlet weak var lokingmen: ButtonWordSpecing!
    @IBOutlet weak var lookinWomen: ButtonWordSpecing!
    @IBOutlet weak var lookingEveryone: ButtonWordSpecing!
    
    
    //MARK:- Memory Management Method
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    deinit {
        print("💥💥💥 ChooseInterestViewController Deinit💥💥💥")
    }
    
    //------------------------------------------------------
    //MARK:- Custom Method
    
    
    func setupView(){

        lokingmen.roundCorners(corners: .allCorners, radius: 5)
        lookinWomen.roundCorners(corners: .allCorners, radius: 5)
        lookingEveryone.roundCorners(corners: .allCorners, radius: 5)
        self.navigationController?.navigationBar.setGradientBackground(colors: [UIColor.colorFromHex(hex: 0x4D4347), UIColor.colorFromHex(hex: 0x5D4147)])
        
    }
    
  
    
    //------------------------------------------------------
    //MARK:- action method
    
    @IBAction func lookingFor(_ sender: UIButton) {
        if sender.tag == 503 {
            
            lokingmen.backgroundColor = UIColor.colorFromHex(hex: 0xD92424)
            lokingmen.titleLabel?.textColor = UIColor.white
            lookinWomen.backgroundColor  = UIColor.colorFromHex(hex: 0xDFDDDD)
            lookingEveryone.backgroundColor  = UIColor.colorFromHex(hex: 0xDFDDDD)
            lookingEveryone.titleLabel?.textColor = UIColor.colorFromHex(hex: 0x716C6C)
            lookinWomen.titleLabel?.textColor = UIColor.colorFromHex(hex: 0x716C6C)
        }else if sender.tag == 504 {
            lokingmen.backgroundColor = UIColor.colorFromHex(hex: 0xDFDDDD)
            lookinWomen.backgroundColor  = UIColor.colorFromHex(hex: 0xD92424)
            lookingEveryone.backgroundColor  = UIColor.colorFromHex(hex: 0xDFDDDD)
            lookingEveryone.titleLabel?.textColor = UIColor.colorFromHex(hex: 0x716C6C)
            lokingmen.titleLabel?.textColor = UIColor.colorFromHex(hex: 0x716C6C)
            lookinWomen.titleLabel?.textColor = UIColor.white
        }else if sender.tag == 505 {
            lokingmen.backgroundColor = UIColor.colorFromHex(hex: 0xDFDDDD)
            lookinWomen.backgroundColor  = UIColor.colorFromHex(hex: 0xDFDDDD)
            lookingEveryone.backgroundColor  = UIColor.colorFromHex(hex: 0xD92424)
            lokingmen.titleLabel?.textColor = UIColor.colorFromHex(hex: 0x716C6C)
            lookinWomen.titleLabel?.textColor = UIColor.colorFromHex(hex: 0x716C6C)
            lookingEveryone.titleLabel?.textColor = UIColor.white
        }
    }
    
    func pushToScreenNameViewController(){
        let vc = ScreenNameViewController.instantiate(fromAppStoryboard: .kLoginStoryboard)
      
        self.navigationController?.pushViewController(vc, animated: true)
    }
    

    @IBAction func continueNext(_ sender: Any) {
        pushToScreenNameViewController()
    }
    
 
    
    
    
    
    //------------------------------------------------------
    //MARK:- Life Cycle Method

    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)


    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }

    


}
