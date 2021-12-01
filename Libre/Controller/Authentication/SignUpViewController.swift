//
//  SignUpViewController.swift
//  Libre
//
//  Created by piash sarker on 27/7/21.
//

import UIKit

class SignUpViewController: UIViewController {
    @IBOutlet weak var mobileNumber: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var confirmPassword: UITextField!
    @IBOutlet weak var createAccount: ButtonWordSpecing!
    
    //------------------------------------------------------
    //MARK:- Class Variable
    

    //------------------------------------------------------
    //MARK:- Memory Management Method
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    deinit {
        print("💥💥💥 Signup Deinit 💥💥💥")
    }
    
    //------------------------------------------------------
    //MARK:- Custom Method
    func isValidView() -> Bool {
        self.view.endEditing(true)
        if self.mobileNumber.text!.isEmpty && self.mobileNumber.text!.count < 12 && ((self.mobileNumber.text!.count) > 8){
            GFunction.shared.showSnackBar(ValidationMessage.ErrorEnterEmail.rawValue)
            return false
        }
        if self.password.text!.isEmpty{
            GFunction.shared.showSnackBar(ValidationMessage.ErrorPassword.rawValue)
            return false
        }
        if self.confirmPassword.text!.isEmpty && self.password.text! != self.confirmPassword.text!{
            GFunction.shared.showSnackBar(ValidationMessage.ErrorPassword.rawValue)
            return false
        }
        
        return true
    }
    func setupView(){
        createAccount.applyGradient(colours: [UIColor.colorFromHex(hex: 0x6F4E55), UIColor.colorFromHex(hex: 0x4D4347)])
        self.mobileNumber.setBorderWithCornerRedious(cornerRedius: 5.0, borderWidth: 3, borderColor: UIColor.colorFromHex(hex: 0xD5D5D5).cgColor)
        self.password.setBorderWithCornerRedious(cornerRedius: 5.0, borderWidth: 3, borderColor: UIColor.colorFromHex(hex: 0xD5D5D5).cgColor)
        self.confirmPassword.setBorderWithCornerRedious(cornerRedius: 5.0, borderWidth: 3, borderColor: UIColor.colorFromHex(hex: 0xD5D5D5).cgColor)
        createAccount.handleTapToAction {
            if self.isValidView() {
                self.APICallSignUp(phone: self.mobileNumber.text!.trim(), password: self.password.text!)
            }
        }
        self.mobileNumber.setLeftPaddingPoints(5)
        self.password.setLeftPaddingPoints(5)
        self.confirmPassword.setLeftPaddingPoints(5)
        
    }

    func PushToOtpViewController(){
        let vc = OtpVerificationViewController.instantiate(fromAppStoryboard: .kLoginStoryboard)
        vc.mobileNumber = mobileNumber.text!
        self.navigationController?.pushViewController(vc, animated: true)
    }

    
    
    //------------------------------------------------------
    
    //MARK:- Action Method
    
    
    
    
    
    //------------------------------------------------------
    
    //MARK:- Life Cycle Method
    override func viewDidLoad() {
        super.viewDidLoad()

        self.setupView()
    }
    


}

extension SignUpViewController {
    
    //MARK:- Web Service
    
    /**
     ===========API CALL===========
     Method Name : signup
     Method      : POST
     Comment     : This function is used to validate login request
     ==============================
            */
    
    private func APICallSignUp(phone : String, password:String) {
        
 

        //let countryC = code.replacingOccurrences(of: "+", with: "")
        let params : [String : Any] = [
        
            "phoneNumber" : phone,
            "password"      : password,
        ]
        
        print(params)
        
        ApiManager.shared.makeRequestWithModel(method: .auth(.signup), modelType: UserModel.self, parameter: params)  { (result) in
            switch result {
            case .success(let apiData):
                print(result)
                switch apiData.success {
                    
                
              
                case true:
                    print(apiData)
                    
                    
                    self.PushToOtpViewController()
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
