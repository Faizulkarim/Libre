//
//  InfoProfileViewController.swift
//  Libre
//
//  Created by piash sarker on 31/7/21.
//

import UIKit


class InfoProfileViewController: UIViewController, UITextFieldDelegate {
    @IBOutlet weak var screenName: UITextField!
    @IBOutlet weak var ProfileImage: RoundImage!
    @IBOutlet weak var name: UITextField!
    @IBOutlet weak var professon: UITextField!
    @IBOutlet weak var prefarace: UITextField!
    @IBOutlet weak var backgroundImage: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var uploadImage: UIView!
    
    //------------------------------------------------------
    //MARK:- Class varibale
    var myImages :[JSON] = []
    var prefaranceList: [JSON] = []
    
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
        self.tableView.isHidden = true
        self.name.delegate = self
        self.professon.delegate = self
        self.screenName.applyCornerRadius(cornerRadius: 5, borderColor: UIColor.gray, borderWidth: 1)
     self.uploadImage.handleTapToAction {
            ImagePickerManager().pickImage(self){ image in
                
                DispatchQueue.main.async {
                    self.ProfileImage.image = image
                    self.uploadImage(image: image)
                }
            }
        }
        self.prefarace.delegate = self
        self.prefarace.handleTapToAction {
            self.tableView.isHidden = false
        }
    
    }
  
    func setupData(){
        if UserModel.currentUser != nil {
            if !(UserModel.currentUser?.professon.isEmpty)! {
                self.professon.text = UserModel.currentUser?.professon
            }
            if !(UserModel.currentUser?.name.isEmpty)! {
                self.name.text = UserModel.currentUser?.name.capitalized
            }
            if !(UserModel.currentUser?.profileImage.isEmpty)! {
                if let url = URL(string: (UserModel.currentUser?.profileImage)!){
                    print(url)
                    self.ProfileImage.setImageWithDownload(url)
                }
                
            }
            if !(UserModel.currentUser?.prefarance.isEmpty)! {
                self.prefarace.text = UserModel.currentUser?.prefarance
            }
            if !(UserModel.currentUser?.backgrounImage.isEmpty)! {
                if let url = URL(string: (UserModel.currentUser?.backgrounImage)!){
                    print(url)
                    self.backgroundImage.setImageWithDownload(url)
                }
                
            }

        }

    }
    func isValidView() -> Bool {
        self.view.endEditing(true)
        if self.name.text!.empty(){
            GFunction.shared.showSnackBar(ValidationMessage.ErrorName.rawValue)
            return false
        }
        if self.prefarace.text!.empty(){
            GFunction.shared.showSnackBar(ValidationMessage.ErrorPassword.rawValue)
            return false
        }
        
        return true
    }
    
    func uploadImage(image : UIImage){
        ImageUpload.shared.uploadImage(showLoader: true, image: image, mimeType: "image/jpeg", imageType: S3Bucket.kAWSUserPath) { (full, last, response, idx) in
            debugPrint(full as Any)
           // self.imageName = last
            userChosenData.userImage = full!
          
           
            print("This is image name")
        }
    }
    
    func pushToAnonemViewController(){
        let vc = FaceConstructViewController.instantiate(fromAppStoryboard: .kLoginStoryboard)
      
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func pushToChooseBackgroundImgController(){
        let vc = BackgroundImageViewController.instantiate(fromAppStoryboard: .kTabbarStoryboard)
      
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == self.name {
            userChosenData.name = textField.text!
        }else if textField == self.professon {
            userChosenData.professon = textField.text!
        }
    }
    
    //------------------------------------------------------
    //MARK:- Action method
    
    
    @IBAction func annonimys(_ sender: Any) {
        self.pushToAnonemViewController()
    }
    
    @IBAction func ChooseBackGround(_ sender: Any) {
        self.pushToChooseBackgroundImgController()
        
        
    }
    
    
    //------------------------------------------------------
    //MARK:- Life Cycle Method

    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
        APICallPrefanceList()
        setupData()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //self.navigationController?.clearNavigation()
        self.navigationController?.navigationBar.isHidden = false
        

    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }

    



}
extension InfoProfileViewController : UITableViewDataSource,UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return prefaranceList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)as? prefarenceCell

        if let title = prefaranceList[indexPath.row]["name"].string{
            cell?.title.text = title
        }
  
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let name = self.prefaranceList[indexPath.row]["name"].string {
            self.prefarace.text = name
            userChosenData.prefarance = name
        }
       
        self.tableView.isHidden = true
    }
    
    
}
extension InfoProfileViewController {
    private func APICallPrefanceList() {
        
        let params : [String : Any] = [
            "userId" : UserModel.currentUser?.userId! ?? 00
           
        ]
    
        ApiManager.shared.makeRequest(method:.user(.preferredLoveList), methodType: .post, parameter: params, withErrorAlert: true, withLoader: true, withToken: true, withdebugLog: true) { (result) in
                
                
           // print("This is response \(apiData.data)")
                switch result {
                    
                
                case .success(let apiData):
                    
                    debugPrint(apiData)
                    
                    switch apiData.apiCode {
                        
                    case .success:
                    
                        let res = JSON(apiData.response)
                        print("This is response \(res)")
                        if let data = res["list"].array{
                            self.prefaranceList = data
                        }
                       
                        self.tableView.reloadData()
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
