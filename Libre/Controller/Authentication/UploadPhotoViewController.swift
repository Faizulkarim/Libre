//
//  UploadPhotoViewController.swift
//  Libre
//
//  Created by piash sarker on 28/7/21.
//

import UIKit

class UploadPhotoViewController: UIViewController {
    @IBOutlet weak var imgBg: UIImageView!
    @IBOutlet weak var uploadView: UIView!
    @IBOutlet weak var finalName: UITextField!
    
    
    var selectedImage = UIImage()
    //MARK:- Memory Management Method
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    deinit {
        print("💥💥💥 UploadPhotoViewController Deinit💥💥💥")
    }
    
    //------------------------------------------------------
    //MARK:- Custom Method
    
    
    func setupView(){
        self.uploadView.applyViewShadowWithCornerRadius(shadowOffset: nil, shadowColor: UIColor.gray, shadowOpacity: 0.5, cornerRadius: 5, shadowRadius: 5)
        self.imgBg.image = selectedImage
        self.finalName.text = userChosenData.name
    }
    func pushToDistanceViewController(){
        let vc = DistanceViewController.instantiate(fromAppStoryboard: .kLoginStoryboard)
      
        self.navigationController?.pushViewController(vc, animated: true)
    }
    func pushToScreenNameViewController(){
        let vc = ScreenNameViewController.instantiate(fromAppStoryboard: .kLoginStoryboard)
      
        self.navigationController?.pushViewController(vc, animated: true)
    }
    func uploadImage(){
        ImageUpload.shared.uploadImage(showLoader: true, image: self.imgBg.image!.resizedTo1MB()!, mimeType: "image/jpeg", imageType: S3Bucket.kAWSUserPath) { (full, last, response, idx) in
            debugPrint(full as Any)
            GFunction.shared.removeLoader()
           // self.imageName = last
            userChosenData.userImage = full!
            self.pushToDistanceViewController()
          
            print(userChosenData.userImage)
           
            print("This is image name")
        }
        
     
    }
    

    
    
    //------------------------------------------------------
    //MARK:- Action
    
    @IBAction func removeImage(_ sender: Any) {
        self.pushToScreenNameViewController()
        imgBg.image = UIImage(named: "")
        
    }
    
    @IBAction func goToDistanceView(_ sender: Any) {
        self.uploadImage()
       // pushToDistanceViewController()
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
        self.navigationController?.navigationBar.isHidden = true

    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }

}
