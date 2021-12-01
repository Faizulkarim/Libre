//
//  LoginAndSignUpViewController.swift
//  Libre
//
//  Created by piash sarker on 27/7/21.
//

import UIKit

class LoginAndSignUpViewController: UIViewController {
    
    @IBOutlet weak var loginBottomView: UIView!
    @IBOutlet weak var signUpBottomView: UIView!
    @IBOutlet weak var LoginContainerView: UIView!
    @IBOutlet weak var signUpContainerView: UIView!
    
    

    //MARK:- Class Variable
    
    
    //MARK:- Memory Management Method
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    deinit {
        print("💥💥💥 Tutorial Deinit 💥💥💥")
    }
    
    
    
    //MARK:- Custom Method
    
    
    
    //MARK:- Action Method
    
    @IBAction func ChangeToLoginView(_ sender: Any) {
        self.loginBottomView.isHidden = false
        self.signUpBottomView.isHidden = true
        self.signUpContainerView.isHidden = true
        self.LoginContainerView.isHidden = false
    }
    
    @IBAction func ChangeToSignUpView(_ sender: Any) {
        self.loginBottomView.isHidden = true
        self.signUpBottomView.isHidden = false
        self.LoginContainerView.isHidden = true
        self.signUpContainerView.isHidden = false
    }
    
    
    //------------------------------------------------------
    
    //MARK:- Life Cycle Method
    override func viewDidLoad() {
        super.viewDidLoad()

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
