//
//  ForgotPasswordViewController.swift
//  Libre
//
//  Created by piash sarker on 29/7/21.
//

import UIKit

class ForgotPasswordViewController: UIViewController {
    @IBOutlet weak var numberText: UITextField!
    @IBOutlet weak var submitButton: ButtonWordSpecing!
    
   
    
    //MARK:- Memory Management Method
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    deinit {
        print("💥💥💥 ForgotPasswordViewController Deinit💥💥💥")
    }
    
    //------------------------------------------------------
    //MARK:- Custom Method
    
    
    func setupView(){
        self.numberText.setBorderWithCornerRedious(cornerRedius: 5.0, borderWidth: 3, borderColor: UIColor.colorFromHex(hex: 0xD5D5D5).cgColor)
        submitButton.applyGradient(colours: [UIColor.colorFromHex(hex: 0x6F4E55), UIColor.colorFromHex(hex: 0x4D4347)])
    }
    func PushToOtpViewController(){
        let vc = OtpVerificationViewController.instantiate(fromAppStoryboard: .kLoginStoryboard)
        vc.mobileNumber = numberText.text!.description
        vc.isComeFromResetPasswrod = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    //------------------------------------------------------
    //MARK:- Action method
    
    @IBAction func goToOtp(_ sender: Any) {
        if !numberText.text!.isEmpty{
            self.APICallRESENOTPVerify()
        }
       
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
        self.navigationController?.navigationBar.isHidden = false

    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }


}

extension ForgotPasswordViewController {
    private func APICallRESENOTPVerify() {
        
        let params : [String : Any] = [
            "phoneNumber" : self.numberText.text!,
           
        ]
        

        ApiManager.shared.makeRequest(method:.auth(.resendOtp), methodType: .post, parameter: params, withErrorAlert: true, withLoader: true, withdebugLog: true) { (result) in
            
            
            print("This is response \(result)")
            switch result {
                
            
            case .success(let apiData):
                
                debugPrint(apiData)
                
                switch apiData.success {
                    
                case true:
                    self.PushToOtpViewController()
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
