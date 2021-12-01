//
//  ChooseInterestViewController.swift
//  Libre
//
//  Created by piash sarker on 27/7/21.
//

import UIKit

struct userChosenData {
   static var iam = ""
   static var lookingfor = ""
   static var name = ""
   static var userImage = ""
   static var distance = ""
   static var professon = ""
   static var backgroundImage = ""
   static var selection = ""
   static var aboutText = ""
   static var prefarance = ""
}
class ChooseInterestViewController: UIViewController {
    @IBOutlet weak var IamWoman: ButtonWordSpecing!
    @IBOutlet weak var Iamman: ButtonWordSpecing!
    @IBOutlet weak var IamOthere: ButtonWordSpecing!
    @IBOutlet weak var lokingmen: ButtonWordSpecing!
    @IBOutlet weak var lookinWomen: ButtonWordSpecing!
    @IBOutlet weak var lookingEveryone: ButtonWordSpecing!
    
    
    //------------------------------------------------------
    //MARK:- Class variable
    
    var iAmA = ""
    var lookingfor = ""
    
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
        Iamman.roundCorners(corners: .allCorners, radius: 5)
        IamWoman.roundCorners(corners: .allCorners, radius: 5)
        IamOthere.roundCorners(corners: .allCorners, radius: 5)
        lokingmen.roundCorners(corners: .allCorners, radius: 5)
        lookinWomen.roundCorners(corners: .allCorners, radius: 5)
        lookingEveryone.roundCorners(corners: .allCorners, radius: 5)
        
    }
    
  
    
    //------------------------------------------------------
    //MARK:- action method
    
    @IBAction func iam(_ sender: UIButton) {
        
        if sender.tag == 500 {
            userChosenData.iam = "Woman"
            iAmA = "Woman"
            IamWoman.backgroundColor = UIColor.colorFromHex(hex: 0xD92424)
            IamWoman.titleLabel?.textColor = UIColor.white
            Iamman.backgroundColor  = UIColor.colorFromHex(hex: 0xDFDDDD)
            IamOthere.backgroundColor  = UIColor.colorFromHex(hex: 0xDFDDDD)
            IamOthere.titleLabel?.textColor = UIColor.colorFromHex(hex: 0x716C6C)
            Iamman.titleLabel?.textColor = UIColor.colorFromHex(hex: 0x716C6C)
        }else if sender.tag == 501 {
            iAmA = "Man"
            userChosenData.lookingfor = "Man"
            IamWoman.backgroundColor = UIColor.colorFromHex(hex: 0xDFDDDD)
            Iamman.backgroundColor  = UIColor.colorFromHex(hex: 0xD92424)
            IamOthere.backgroundColor  = UIColor.colorFromHex(hex: 0xDFDDDD)
            IamOthere.titleLabel?.textColor = UIColor.colorFromHex(hex: 0x716C6C)
            IamWoman.titleLabel?.textColor = UIColor.colorFromHex(hex: 0x716C6C)
            Iamman.titleLabel?.textColor = UIColor.white
        }else if sender.tag == 502 {
            iAmA = "Others"
            userChosenData.lookingfor = "Others"
            IamWoman.backgroundColor = UIColor.colorFromHex(hex: 0xDFDDDD)
            Iamman.backgroundColor  = UIColor.colorFromHex(hex: 0xDFDDDD)
            IamOthere.backgroundColor  = UIColor.colorFromHex(hex: 0xD92424)
            IamWoman.titleLabel?.textColor = UIColor.colorFromHex(hex: 0x716C6C)
            Iamman.titleLabel?.textColor = UIColor.colorFromHex(hex: 0x716C6C)
            IamOthere.titleLabel?.textColor = UIColor.white
        }
        
    }
    
    @IBAction func lookingFor(_ sender: UIButton) {
        if sender.tag == 503 {
            iAmA = "Men"
            userChosenData.lookingfor = "Men"
            lokingmen.backgroundColor = UIColor.colorFromHex(hex: 0xD92424)
            lokingmen.titleLabel?.textColor = UIColor.white
            lookinWomen.backgroundColor  = UIColor.colorFromHex(hex: 0xDFDDDD)
            lookingEveryone.backgroundColor  = UIColor.colorFromHex(hex: 0xDFDDDD)
            lookingEveryone.titleLabel?.textColor = UIColor.colorFromHex(hex: 0x716C6C)
            lookinWomen.titleLabel?.textColor = UIColor.colorFromHex(hex: 0x716C6C)
        }else if sender.tag == 504 {
            iAmA = "Women"
            userChosenData.lookingfor = "Women"
            lokingmen.backgroundColor = UIColor.colorFromHex(hex: 0xDFDDDD)
            lookinWomen.backgroundColor  = UIColor.colorFromHex(hex: 0xD92424)
            lookingEveryone.backgroundColor  = UIColor.colorFromHex(hex: 0xDFDDDD)
            lookingEveryone.titleLabel?.textColor = UIColor.colorFromHex(hex: 0x716C6C)
            lokingmen.titleLabel?.textColor = UIColor.colorFromHex(hex: 0x716C6C)
            lookinWomen.titleLabel?.textColor = UIColor.white
        }else if sender.tag == 505 {
            lookingfor = "Everyone"
            userChosenData.lookingfor = "Everyone"
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
        self.navigationController?.clearNavigation()
        self.navigationController?.navigationBar.isHidden = true

    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }

    



}
