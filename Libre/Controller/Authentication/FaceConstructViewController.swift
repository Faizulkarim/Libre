//
//  FaceConstructViewController.swift
//  Libre
//
//  Created by piash sarker on 28/7/21.
//

import UIKit

class FaceConstructViewController: UIViewController {

    @IBOutlet weak var faceAnnomImage: UIImageView!
    var selectedImage = UIImage()
    
    //MARK:- Memory Management Method
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    deinit {
        print("💥💥💥 FaceConstructViewController Deinit💥💥💥")
    }
    
    //------------------------------------------------------
    //MARK:- Custom Method
    
    
    func setupView(){
        self.faceAnnomImage.applyViewShadowWithCornerRadius(shadowOffset: nil, shadowColor: UIColor.gray, shadowOpacity: 0.5, cornerRadius: 5, shadowRadius: 5)
        self.faceAnnomImage.image = selectedImage
    }
    func pushToUploadaPhotoViewController(){
        let vc = UploadPhotoViewController.instantiate(fromAppStoryboard: .kLoginStoryboard)
        vc.selectedImage = selectedImage
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    //------------------------------------------------------
    //MARK:- Action method
    
    
    @IBAction func nextVC(_ sender: Any) {
        self.pushToUploadaPhotoViewController()
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
