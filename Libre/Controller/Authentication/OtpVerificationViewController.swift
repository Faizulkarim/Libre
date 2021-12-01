//
//  OtpVerificationViewController.swift
//  Libre
//
//  Created by piash sarker on 29/7/21.
//

import UIKit

class OtpVerificationViewController: UIViewController, UITextFieldDelegate {
    @IBOutlet weak var submitButton: ButtonWordSpecing!
    @IBOutlet var txtOTP1: UITextField!
    @IBOutlet var txtOTP2: UITextField!
    @IBOutlet var txtOTP3: UITextField!
    @IBOutlet var txtOTP4: UITextField!
    @IBOutlet var txtOTP5: UITextField!
    @IBOutlet var txtOTP6: UITextField!
 // MARK:- Class variable
    
    var otp = ""
    var mobileNumber = ""
    var isComeFromResetPasswrod: Bool?
    
    //MARK:- Memory Management Method
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    deinit {
        print("💥💥💥 OtpVerificationViewController Deinit💥💥💥")
    }
    
    //------------------------------------------------------
    //MARK:- Custom Method
    
    @objc func textFieldDidChange(textField: UITextField){
        let text = textField.text
            if  text?.count == 1 {
                switch textField{
                case self.txtOTP1:
                    self.txtOTP2.becomeFirstResponder()
                    self.txtOTP2.text = ""
                case self.txtOTP2:
                    self.txtOTP3.becomeFirstResponder()
                    self.txtOTP3.text = ""
                case self.txtOTP3:
                    self.txtOTP4.becomeFirstResponder()
                    self.txtOTP4.text = ""
                case self.txtOTP4:
                    self.txtOTP5.becomeFirstResponder()
                    self.txtOTP5.text = ""
                case self.txtOTP5:
                    self.txtOTP6.resignFirstResponder()
                    self.txtOTP6.text = ""
                case self.txtOTP6:
                    self.txtOTP6.resignFirstResponder()
                default:
                    break
                }
            }else{
                switch textField{
                case self.txtOTP1:
                    self.txtOTP1.becomeFirstResponder()
                case self.txtOTP2:
                    self.txtOTP1.becomeFirstResponder()
                case self.txtOTP3:
                    self.txtOTP2.becomeFirstResponder()
                case self.txtOTP4:
                    self.txtOTP3.becomeFirstResponder()
                case self.txtOTP5:
                    self.txtOTP4.becomeFirstResponder()
                case self.txtOTP6:
                    self.txtOTP5.becomeFirstResponder()
                default:
                    break
                }
       

        }
    }
    
    func validateAllFileds() -> Bool{
        
        let otp1 = self.txtOTP1.text!+self.txtOTP2.text!+self.txtOTP3.text!
        
            otp = otp1+self.txtOTP4.text!+self.txtOTP5.text!+self.txtOTP6.text!
        if (txtOTP1.text?.count)! < 1 || (txtOTP2.text?.count)! < 1 || (txtOTP3.text?.count)! < 1 || (txtOTP4.text?.count)! < 1 || (txtOTP5.text?.count)! < 1 || (txtOTP6.text?.count)! < 1{
            GFunction.shared.showSnackBar(ValidationMessage.ErrorOTP.rawValue)
            return false
        }
        return true
    }
    
    func setUp(){
        
        self.txtOTP1.textAlignment = .center
        self.txtOTP2.textAlignment = .center
        self.txtOTP3.textAlignment = .center
        self.txtOTP4.textAlignment = .center
        self.txtOTP5.textAlignment = .center
        self.txtOTP6.textAlignment = .center
        
//        self.txtOTP1.font(name: .FontRegular, size: kFontSize24).textColor(color: .ColorTextColor)
//        self.txtOTP2.font(name: .FontRegular, size: kFontSize24).textColor(color: .ColorTextColor)
//        self.txtOTP3.font(name: .FontRegular, size: kFontSize24).textColor(color: .ColorTextColor)
//        self.txtOTP4.font(name: .FontRegular, size: kFontSize24).textColor(color: .ColorTextColor)
//        self.txtOTP5.font(name: .FontRegular, size: kFontSize24).textColor(color: .ColorTextColor)
//        self.txtOTP6.font(name: .FontRegular, size: kFontSize24).textColor(color: .ColorTextColor)
        
        self.txtOTP5.delegate = self
        self.txtOTP6.delegate = self
        self.txtOTP1.delegate = self
        self.txtOTP2.delegate = self
        self.txtOTP3.delegate = self
        self.txtOTP4.delegate = self
    
        
        self.txtOTP1.addTarget(self, action: #selector(textFieldDidChange(textField:)), for: UIControl.Event.editingChanged)
        self.txtOTP2.addTarget(self, action: #selector(textFieldDidChange(textField:)), for: UIControl.Event.editingChanged)
        self.txtOTP3.addTarget(self, action: #selector(textFieldDidChange(textField:)), for: UIControl.Event.editingChanged)
        self.txtOTP4.addTarget(self, action:#selector(textFieldDidChange(textField:)), for: UIControl.Event.editingChanged)
        self.txtOTP5.addTarget(self, action: #selector(textFieldDidChange(textField:)), for: UIControl.Event.editingChanged)
        self.txtOTP6.addTarget(self, action:#selector(textFieldDidChange(textField:)), for: UIControl.Event.editingChanged)
        
        submitButton.applyGradient(colours: [UIColor.colorFromHex(hex: 0x6F4E55), UIColor.colorFromHex(hex: 0x4D4347)])
    }

    
    func PushToSetNewPassViewController(userId : Int){
        let vc = SetNewpasswordViewController.instantiate(fromAppStoryboard: .kLoginStoryboard)
        vc.isComFromFrogotPass = true
        vc.userId = userId
        self.navigationController?.pushViewController(vc, animated: true)
    }
    func pushToChooseInterestViewController(){
        let vc = ChooseInterestViewController.instantiate(fromAppStoryboard: .kLoginStoryboard)
      
        self.navigationController?.pushViewController(vc, animated: true)
    }
    //------------------------------------------------------
    //MARK:- Action method
    
    
    @IBAction func goToNewPasswordView(_ sender: Any) {
        if validateAllFileds() {
            APICallOTPVerify()
        }
       
    }
    
    @IBAction func resenCode(_ sender: Any) {
        
        self.APICallRESENOTP()
    }
    
    
    //------------------------------------------------------
    //MARK:- Life Cycle Method

    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.setUp()
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.clearNavigation()
        self.navigationController?.navigationBar.isHidden = false

    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }



}
extension OtpVerificationViewController {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if let char = string.cString(using: String.Encoding.utf8) {
            let isBackSpace = strcmp(char, "\\b")
            if (isBackSpace == -92) {
                return true
            }
        }
        if textField == txtOTP1 || textField == txtOTP2 || textField == txtOTP3 || textField == txtOTP4 || textField == txtOTP5 || textField == txtOTP6 {
        }
        let maxLength = 1
        let currentString: NSString = textField.text! as NSString
        let newString: NSString =
            currentString.replacingCharacters(in: range, with: string) as NSString
        return newString.length <= maxLength
    }
    

    

}

extension OtpVerificationViewController {
    //MARK:- Web Service
    
    /**
     ===========API CALL===========
     Method Name : otp
     Method      : POST
     Comment     : This function is used to validate login request
     ==============================
     */

    
    
    private func APICallOTPVerify() {
        
        let params : [String : Any] = [
            "phoneNumber" : mobileNumber,
            "code" : otp,

        ]
        

        ApiManager.shared.makeRequest(method:.auth(.verify), methodType: .post, parameter: params, withErrorAlert: true, withLoader: true, withdebugLog: true) { (result) in
            
            
            print("This is response \(result)")
            switch result {
                
            
            case .success(let apiData):
                
                debugPrint(apiData)
                
                switch apiData.success{
                    
                case true:
                    if self.isComeFromResetPasswrod == true{
                        if let data = apiData.response["data"].dictionary {
                         if let userId = data["userId"]?.int{
                            self.PushToSetNewPassViewController(userId: userId)
                         }
                         }
                       
                    }else{
                        self.pushToChooseInterestViewController()
                    }
                   
                default:
                    GFunction.shared.showSnackBar(apiData.message)
                }
                
            case .failure(let failedMsg):
                print(failedMsg)
                break
            }
        }
    }
    
    private func APICallRESENOTP() {
        
        let params : [String : Any] = [
            "phoneNumber" : mobileNumber,
           
        ]
    
            ApiManager.shared.makeRequest(method:.auth(.resendOtp), methodType: .post, parameter: params, withErrorAlert: true, withLoader: true, withdebugLog: true) { (result) in
                
                
                print("This is response \(result)")
                switch result {
                    
                
                case .success(let apiData):
                    
                    debugPrint(apiData)
                    
                    switch apiData.success {
                        
                    case true:
                        GFunction.shared.showAlert(message: apiData.message)
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
