//
//  AboutYouViewController.swift
//  Libre
//
//  Created by piash sarker on 29/7/21.
//

import UIKit

class AboutYouViewController: UIViewController,UITextViewDelegate {
    @IBOutlet weak var aboutText: UITextView!
    @IBOutlet weak var remainigTxt: UILabel!
    

    
    //MARK:- Memory Management Method
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    deinit {
        print("💥💥💥 AboutYouViewController Deinit💥💥💥")
    }
    
    //------------------------------------------------------
    //MARK:- Custom Method
    
    
    func setupView(){
    
        aboutText.delegate = self
        aboutText.applyStyle(titleFont: nil, titleColor: nil, cornerRadius: 2, borderColor: UIColor.black, borderWidth: 1.0, backgroundColor: nil, state: .normal, leftImage: nil, rightImage: nil)
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        guard let viewText = aboutText.text else { return true }
          let length = viewText.count + text.count - range.length

          // create an Integer of 55 - the length of your TextField.text to count down
          let count = 300 - length

          // set the .text property of your UILabel to the live created String
          remainigTxt.text =  "\(count)/300"

          // if you want to limit to 55 charakters
          // you need to return true and <= 55

          return length <= 300
    }
    
    
    //------------------------------------------------------
    //MARK:- Action method
    
    @IBAction func next(_ sender: Any) {
        if !aboutText.text.isEmpty{
            userChosenData.aboutText = aboutText.text!
            APICallToSaveUserData()
        }
       
    }
    
    

    
    //------------------------------------------------------
    //MARK:- Life Cycle Method

    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
        
    }



}

extension AboutYouViewController {
    private func APICallToSaveUserData() {
        
        let params : [String : Any] = [
            "name": userChosenData.name,
            "userId": UserModel.currentUser?.userId! as Any,
            "profileImageUrl": userChosenData.userImage,
            "distance": userChosenData.distance,
            "profession": userChosenData.professon,
            "whatYouLove": userChosenData.prefarance,
            "backgroundImageUrl": userChosenData.backgroundImage,
            "aboutYou": aboutText.text!
        ]
        print(params)
        
        ApiManager.shared.makeRequestWithModel(method: .auth(.saveuserData), modelType: UserModel.self, parameter: params)  { (result) in
            
            
            print("This is response \(result)")
            switch result {
                
            
            case .success(let apiData):
                
                debugPrint(apiData)
                
                switch apiData.success {
                    
                case true:
                   
                    UserModel.currentUser = apiData.data
                    GFunction.shared.saveDataIntoUserDefault(object: apiData.response[ApiKeys.ApiResponseKey.data.rawValue].dictionaryObject as AnyObject, key: UserDefaultsKeys.kSignUpUserData.rawValue)
                    if let user = UserModel.currentUser {
                        GFunction.shared.saveDataIntoUserDefault(object: user.accessToken as AnyObject, key: UserDefaultsKeys.kAccessToken.rawValue)
                    }
                    GFunction.shared.emtyUserdata()
                    GFunction.shared.setBoolValueWithKey(true, key: UserDefaultsKeys.kIsLogin.rawValue)
                    GFunction.shared.setHomeScreen()
                    print("This is app data reponse\(apiData.response[ApiKeys.ApiResponseKey.data.rawValue].dictionaryObject as AnyObject)")
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
