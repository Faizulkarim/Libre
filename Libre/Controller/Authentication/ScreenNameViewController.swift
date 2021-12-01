//
//  ScreenNameViewController.swift
//  Libre
//
//  Created by piash sarker on 28/7/21.
//

import UIKit

class ScreenNameViewController: UIViewController {
    @IBOutlet weak var uploadView: UIView!
    @IBOutlet weak var imgBg: UIImageView!
    @IBOutlet weak var displayName: UITextField!
    
    @IBOutlet weak var btnCamera: UIButton!
    
    
    //------------------------------------------------------
    //MARK:- Class variable

    var isImage = false
    
    
    //MARK:- Memory Management Method
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    deinit {
        print("💥💥💥 Screen name Deinit💥💥💥")
    }
    
    //------------------------------------------------------
    //MARK:- Custom Method
    
    
    func setupView(){
        uploadView.applyViewShadowWithCornerRadius(shadowOffset: nil, shadowColor: UIColor.gray, shadowOpacity: 0.5, cornerRadius: 5, shadowRadius: 5)
        self.btnCamera.handleTapToAction {
            ImagePickerManager().pickImage(self){ image in
                
                DispatchQueue.main.async {
                    self.imgBg.image = image
                    self.btnCamera.isHidden = true
                    self.isImage = true
                    
                }
            }
        }
    }
    
    func isValidView() -> Bool {
        self.view.endEditing(true)
        if self.displayName.text!.empty(){
            GFunction.shared.showSnackBar(ValidationMessage.ErrorName.rawValue)
            return false
        }
        if isImage == false {
            GFunction.shared.showSnackBar(ValidationMessage.ImageError.rawValue)
            return false
        }

  
        
        return true
    }
    
    func pushToSelectedPhotoViewController(){
        let vc = SelectedPhotoViewController.instantiate(fromAppStoryboard: .kLoginStoryboard)
        vc.selectedImage = self.imgBg.image!
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    //------------------------------------------------------
    //MARK:- Action method
    
    @IBAction func back(_ sender: Any) {
        
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func gotoSelectedPhoto(_ sender: Any) {
        if isValidView(){
            userChosenData.name = self.displayName.text!
            self.pushToSelectedPhotoViewController()
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
        self.navigationController?.navigationBar.isHidden = true

    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }

}
