//
//  EditProfileViewController.swift
//  Libre
//
//  Created by piash sarker on 31/7/21.
//

import UIKit

class EditProfileViewController: UIViewController {
    @IBOutlet weak var yourInfo: UIView!
    @IBOutlet weak var aboutMe: UIView!
    @IBOutlet weak var myPhotos: UIView!
    @IBOutlet weak var infoButton: UIButton!
    @IBOutlet weak var aboutMebutton: UIButton!
    @IBOutlet weak var myphotos: UIButton!
    @IBOutlet weak var infoBottomView: UIView!
    @IBOutlet weak var AboutBottomview: UIView!
    @IBOutlet weak var photosbottomView: UIView!
    
    //------------------------------------------------------
    //MARK:- Class variable
    var ContainViewStage = 1
    
    
    //-----------------------------------------------------
    //MARK:- Memory Management Method
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    deinit {
        print("💥💥💥 EditProfileViewController Deinit💥💥💥")
    }
    
    //------------------------------------------------------
    //MARK:- Custom Method
    
    
    func setupView(){
        self.infoButton.applyViewShadowWithCornerRadius(shadowOffset: nil, shadowColor: UIColor.gray, shadowOpacity: 0.5, cornerRadius: 1, shadowRadius: 1)
        self.aboutMebutton.applyViewShadowWithCornerRadius(shadowOffset: nil, shadowColor: UIColor.gray, shadowOpacity: 0.5, cornerRadius: 1, shadowRadius: 1)
        self.myphotos.applyViewShadowWithCornerRadius(shadowOffset: nil, shadowColor: UIColor.gray, shadowOpacity: 0.5, cornerRadius: 1, shadowRadius: 1)
    }
    
    func pushToBackgroundImageViewController(){
        let vc = UploadBackgroundViewController.instantiate(fromAppStoryboard: .kLoginStoryboard)
      
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    //------------------------------------------------------
    //MARK:- Action method
    
    @IBAction func save(_ sender: Any) {
        self.APICallToSaveUserData()
    }
    
   
    @IBAction func manageContainerView(_ sender: UIButton) {
        switch sender.tag  {
        case 601 :
            self.yourInfo.isHidden = false
            self.aboutMe.isHidden = true
            self.myPhotos.isHidden = true
            self.infoBottomView.isHidden = false
            self.AboutBottomview.isHidden = true
            self.photosbottomView.isHidden = true
            self.infoButton.titleLabel?.font = UIFont(name: "Agatho_ Bold", size: 16)
            self.aboutMebutton.titleLabel?.font = UIFont(name: "Agatho Medium", size: 12)
            self.myphotos.titleLabel?.font = UIFont(name: "Agatho Medium", size: 12)
        case 602 :
            self.yourInfo.isHidden = true
            self.aboutMe.isHidden = false
            self.myPhotos.isHidden = true
            self.infoBottomView.isHidden = true
            self.AboutBottomview.isHidden = false
            self.photosbottomView.isHidden = true
            self.aboutMebutton.titleLabel?.font = UIFont(name: "Agatho_ Bold", size: 16)
            self.infoButton.titleLabel?.font = UIFont(name: "Agatho Medium", size: 12)
            self.myphotos.titleLabel?.font = UIFont(name: "Agatho Medium", size: 12)
        case 603:
            self.yourInfo.isHidden = true
            self.aboutMe.isHidden = true
            self.myPhotos.isHidden = false
            self.infoBottomView.isHidden = true
            self.AboutBottomview.isHidden = true
            self.photosbottomView.isHidden = false
            self.myphotos.titleLabel?.font = UIFont(name: "Agatho_ Bold", size: 16)
            self.infoButton.titleLabel?.font = UIFont(name: "Agatho Medium", size: 12)
            self.aboutMebutton.titleLabel?.font = UIFont(name: "Agatho Medium", size: 12)
        default:
            break;
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
        self.navigationController?.navigationBar.isHidden = false
        self.hideTabBar()

    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }

}

extension EditProfileViewController {
    private func APICallToSaveUserData() {
        
        var params = [String : Any]()
            params["userId"] = UserModel.currentUser?.userId! as Any
            params["distance"] = UserModel.currentUser?.distance as Any
        if userChosenData.name != ""{
            params["name"] = userChosenData.name
        }else{
            params["name"] = UserModel.currentUser?.name as Any
        }
        if userChosenData.professon != ""{
            params["profession"] = userChosenData.professon
        }else{
            params["profession"] = UserModel.currentUser?.professon
        }
        if userChosenData.backgroundImage != ""{
            params["backgroundImageUrl"] = userChosenData.backgroundImage
        }else{
            params["backgroundImageUrl"] = UserModel.currentUser?.backgrounImage
        }
        if userChosenData.userImage != ""{
            params["profileImageUrl"] = userChosenData.userImage
        }else{
            params["profileImageUrl"] = UserModel.currentUser?.profileImage
        }
        if userChosenData.aboutText != ""{
            params["aboutYou"] = userChosenData.aboutText
        }else{
            params["aboutYou"] = UserModel.currentUser?.aboutYou
        }
        if userChosenData.prefarance != ""{
            params["whatYouLove"] = userChosenData.prefarance
        }else{
            params["whatYouLove"] = UserModel.currentUser?.prefarance
        }
           
     
      
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
                    GFunction.shared.showSnackBar(apiData.message)
                    self.navigationController?.popToRootViewController(animated: true)
                    

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
