//
//  LoginViewController.swift
//  Libre
//
//  Created by piash sarker on 27/7/21.
//

import UIKit

class LoginViewController: UIViewController {
    @IBOutlet weak var mobileNumber: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var loginButton: ButtonWordSpecing!
    @IBOutlet weak var btnRemember: UIButton!
    
    //------------------------------------------------------
    //MARK:- Class Variable
    

    //------------------------------------------------------
    //MARK:- Memory Management Method
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    deinit {
        print("💥💥💥 Login Deinit 💥💥💥")
    }
    
    //------------------------------------------------------
    //MARK:- Custom Method
    
    func setupView(){
        loginButton.applyGradient(colours: [UIColor.colorFromHex(hex: 0xD92424), UIColor.colorFromHex(hex: 0xA40606)])
        self.mobileNumber.setBorderWithCornerRedious(cornerRedius: 5.0, borderWidth: 3, borderColor: UIColor.colorFromHex(hex: 0xD5D5D5).cgColor)
        self.password.setBorderWithCornerRedious(cornerRedius: 5.0, borderWidth: 3, borderColor: UIColor.colorFromHex(hex: 0xD5D5D5).cgColor)
        self.mobileNumber.setLeftPaddingPoints(5)
        self.password.setLeftPaddingPoints(5)
//        if let mobile = GFunction.shared.getStringValueForKey(UserDefaultsKeys.kMobilenumber.rawValue) {
//            self.txtEmail.text = JSON(email).stringValue
//            self.btnRemember.isSelected = true
//        }
//        if let password = USERDEFAULTS.value(forKey: UserDefaultsKeys.kPassword){
//            self.txtPassword.text = JSON(password).stringValue
//        }
        
    }
    func PushToForgotpasswordViewController(){
        let vc = ForgotPasswordViewController.instantiate(fromAppStoryboard: .kLoginStoryboard)
      
        self.navigationController?.pushViewController(vc, animated: true)
    }
    func PushToOtpViewController(){
        let vc = OtpVerificationViewController.instantiate(fromAppStoryboard: .kLoginStoryboard)
        vc.mobileNumber = mobileNumber.text!
        self.navigationController?.pushViewController(vc, animated: true)
    }
    func pushToChooseInterestViewController(){
        let vc = ChooseInterestViewController.instantiate(fromAppStoryboard: .kLoginStoryboard)
      
        self.navigationController?.pushViewController(vc, animated: true)
    }

    
    func isValidView() -> Bool {
        self.view.endEditing(true)
        if self.mobileNumber.text!.empty(){
            GFunction.shared.showSnackBar(ValidationMessage.ErrorEnterEmail.rawValue)
            return false
        }
        if self.password.text!.empty(){
            GFunction.shared.showSnackBar(ValidationMessage.ErrorPassword.rawValue)
            return false
        }
        
        return true
    }
    
    
    
    //------------------------------------------------------
    
    //MARK:- Action Method
    @IBAction func btnRememberTapped(_ sender: Any) {
        self.btnRemember.isSelected = !self.btnRemember.isSelected
    }
    @IBAction func forgotPassword(_ sender: Any) {
        PushToForgotpasswordViewController()
    }
    
    @IBAction func login(_ sender: Any) {
        if self.isValidView() {
            APICallToLogin(mobile: self.mobileNumber.text!, password: password.text!)
        }
    }
    
    
    
    //------------------------------------------------------
    
    //MARK:- Life Cycle Method
    override func viewDidLoad() {
        super.viewDidLoad()

        self.setupView()
    }
    



}

extension LoginViewController {
    
    //MARK:- Web Service
    
    /**
     ===========API CALL===========
     Method Name : login
     Method      : POST
     Comment     : This function is used to validate login request
     ==============================
     */
    private func APICallToLogin(mobile:String, password:String) {
        
        let params : [String : Any] = [
            "phoneNumber" : mobile,
            "password" : password
        ]
        print(params)
        
        ApiManager.shared.makeRequestWithModel(method: .auth(.login), modelType: UserModel.self, parameter: params)  { (result) in
            switch result {
            case .success(let apiData):
                print(result)
                switch apiData.success {
                    
                
              
                case true :
                    print(apiData)
                    
                    if apiData.data.isOtpVerified == 0{
                        self.PushToOtpViewController()
                    }else{
                        if apiData.data.profileStatus == 1 {
                            self.pushToChooseInterestViewController()
                        }else{
                            GFunction.shared.saveDataIntoUserDefault(object: apiData.response[ApiKeys.ApiResponseKey.data.rawValue].dictionaryObject as AnyObject, key: UserDefaultsKeys.kSignUpUserData.rawValue)
                            if let user = UserModel.currentUser {
                                GFunction.shared.saveDataIntoUserDefault(object: user.accessToken as AnyObject, key: UserDefaultsKeys.kAccessToken.rawValue)
                            }
                            GFunction.shared.setBoolValueWithKey(true, key: UserDefaultsKeys.kIsLogin.rawValue)
    
                            GFunction.shared.setHomeScreen()
                        }
                    }

                    UserModel.currentUser = apiData.data

                    
                default:
                    GFunction.shared.showSnackBar(apiData.message)
                }
                
            case .failure(let failedMsg):
                print(failedMsg)
                break
            }
        }
    }
}
