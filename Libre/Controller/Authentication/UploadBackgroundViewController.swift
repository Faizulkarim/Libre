//
//  UploadBackgroundViewController.swift
//  Libre
//
//  Created by piash sarker on 29/7/21.
//

import UIKit

class prefarenceCell : UITableViewCell {
    @IBOutlet weak var title: UILabel!
    
    override class func awakeFromNib() {
       
    }

}

class UploadBackgroundViewController: UIViewController, UITextFieldDelegate {
    @IBOutlet weak var uploadPhotoButton: UIButton!
    @IBOutlet weak var chooseFromBackgroundButton: UIButton!
    @IBOutlet weak var selectionText: UITextField!
    @IBOutlet weak var tableView: UITableView!
    
    var prefaranceList: [JSON] = []
   
    //MARK:- Memory Management Method
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    deinit {
        print("💥💥💥 UploadBackgroundViewController Deinit💥💥💥")
    }
    
    //------------------------------------------------------
    //MARK:- Custom Method
    
    func isValidView() -> Bool {
        self.view.endEditing(true)
        if userChosenData.prefarance.empty(){
            GFunction.shared.showSnackBar(ValidationMessage.ErrorPrefarance.rawValue)
            return false
        }
        if userChosenData.backgroundImage.empty(){
            GFunction.shared.showSnackBar(ValidationMessage.ImageError.rawValue)
            return false
        }
        
        return true
    }
    
    func setupView(){
        self.selectionText.delegate = self
        self.selectionText.addTarget(self, action: #selector(showTableView), for: .touchDown)
       self.tableView.isHidden = true
        self.uploadPhotoButton.applyViewShadowWithCornerRadius(shadowOffset: nil, shadowColor: UIColor.gray, shadowOpacity: 0.4, cornerRadius: 5, shadowRadius: 2)
        self.chooseFromBackgroundButton.applyViewShadowWithCornerRadius(shadowOffset: nil, shadowColor: UIColor.gray, shadowOpacity: 0.4, cornerRadius: 5, shadowRadius: 2)
        
        self.uploadPhotoButton.handleTapToAction {
            ImagePickerManager().pickImage(self){ image in
                
                DispatchQueue.main.async {
                    self.uploadImage(image: image)
                    
                }
            }
        }
        self.chooseFromBackgroundButton.handleTapToAction {
            self.pushToChooseBackgroundeViewController()
        }
    }
   @objc func showTableView(){
    self.tableView.isHidden = false
    }
    func uploadImage(image : UIImage){
        ImageUpload.shared.uploadImage(showLoader: true, image: image.resizedTo1MB()!, mimeType: "image/jpeg", imageType: S3Bucket.kAWSUserPath) { (full, last, response, idx) in
            debugPrint(full as Any)
           // self.imageName = last
            userChosenData.backgroundImage = full!
            print(userChosenData.userImage)
           
            print("This is image name")
        }
        
     
    }
    
    func pushToChooseBackgroundeViewController(){
        let vc = ChooseBackgroundViewController.instantiate(fromAppStoryboard: .kLoginStoryboard)
      
        self.navigationController?.pushViewController(vc, animated: true)
    }
    func pushToBackgroundPreview(){
        let vc = BackgroundPreviewViewController.instantiate(fromAppStoryboard: .kLoginStoryboard)
      
        self.navigationController?.pushViewController(vc, animated: true)
    }
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField == self.selectionText {
            return false; //do not show keyboard nor cursor
        }
        return true
    }
    
    //------------------------------------------------------
    //MARK:- Action method
    

    @IBAction func gotoChooseBackground(_ sender: Any) {
        print(userChosenData.backgroundImage)
        if isValidView() {
            
            self.pushToBackgroundPreview()
        }
    }
    
//
//    func textFieldDidBeginEditing(_ textField: UITextField) {
//        self.tableView.isHidden = true
//    }
    
    //------------------------------------------------------
    //MARK:- Life Cycle Method

    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.APICallPrefanceList()
    }



}

extension UploadBackgroundViewController : UITableViewDataSource,UITableViewDelegate {
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
            self.selectionText.text = name
            userChosenData.prefarance = name
        }
       
        self.tableView.isHidden = true
    }
    
    
}

extension UploadBackgroundViewController {
    private func APICallPrefanceList() {
        
        let params : [String : Any] = [
            "userId" : UserModel.currentUser?.userId ?? 00
           
        ]
    
        ApiManager.shared.makeRequest(method:.user(.preferredLoveList), methodType: .post, parameter: params, withErrorAlert: true, withLoader: true, withdebugLog: true) { (result) in
                
                
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
