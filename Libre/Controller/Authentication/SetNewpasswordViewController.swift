//
//  SetNewpasswordViewController.swift
//  Libre
//
//  Created by piash sarker on 29/7/21.
//

import UIKit

class SetNewpasswordViewController: UIViewController {
    @IBOutlet weak var confirmPassword: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var reset: ButtonWordSpecing!
  
    //------------------------------------------------------
    //MARK:- Class Variable
    
    var isComFromFrogotPass = false
    var userId = 0
    
    //MARK:- Memory Management Method
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    deinit {
        print("💥💥💥 SetNewpasswordViewController Deinit💥💥💥")
    }
    
    //------------------------------------------------------
    //MARK:- Custom Method
    func isValidView() -> Bool {
        self.view.endEditing(true)

        if self.password.text!.isEmpty && password.text!.count > 7{
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
        reset.applyGradient(colours: [UIColor.colorFromHex(hex: 0xD92424), UIColor.colorFromHex(hex: 0xA40606)])
        self.password.setBorderWithCornerRedious(cornerRedius: 5.0, borderWidth: 3, borderColor: UIColor.colorFromHex(hex: 0xD5D5D5).cgColor)
        self.confirmPassword.setBorderWithCornerRedious(cornerRedius: 5.0, borderWidth: 3, borderColor: UIColor.colorFromHex(hex: 0xD5D5D5).cgColor)
        reset.handleTapToAction {
            if self.isValidView() {
                self.APICallSetNewPassword()
            }

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

extension SetNewpasswordViewController {
    
    private func APICallSetNewPassword() {
        
        let params : [String : Any] = [
            "userId" : userId,
            "password": password.text!
           
        ]
    
            ApiManager.shared.makeRequest(method:.auth(.setNewPassword), methodType: .post, parameter: params, withErrorAlert: true, withLoader: true, withdebugLog: true) { (result) in
                
                
                print("This is response \(result)")
                switch result {
                case .success(let apiData):
                    
                    debugPrint(apiData)
                    
                    switch apiData.apiCode {
                        
                    case .success:
                        print("success")
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
