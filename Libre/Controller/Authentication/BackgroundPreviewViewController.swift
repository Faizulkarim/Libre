//
//  BackgroundPreviewViewController.swift
//  Libre
//
//  Created by piash sarker on 29/7/21.
//

import UIKit

class BackgroundPreviewViewController: UIViewController {
    @IBOutlet weak var backgroundImage: UIImageView!
    @IBOutlet weak var selectionText: UITextField!
    @IBOutlet weak var girlSingleImage: UIImageView!
    //------------------------------------------------------
    //MARK:- Class variable
    

    
    
    //MARK:- Memory Management Method
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    deinit {
        print("💥💥💥 BackgroundPreviewViewController Deinit💥💥💥")
    }
    
    //------------------------------------------------------
    //MARK:- Custom Method
    
    
    func setupView(){
        if let url = URL(string: userChosenData.backgroundImage){
            print(url)
            self.backgroundImage.setImageWithDownload(url)
        }
        if let url = URL(string: userChosenData.userImage){
            print(url)
            self.girlSingleImage.setImageWithDownload(url)
        }
        self.selectionText.text = userChosenData.prefarance
    }
    func pushToaboutYouViewController(){
        let vc = AboutYouViewController.instantiate(fromAppStoryboard: .kLoginStoryboard)
      
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    //------------------------------------------------------
    //MARK:- Action method
    
    @IBAction func aboutYou(_ sender: Any) {
        self.pushToaboutYouViewController()
        
    }
    
    
    //------------------------------------------------------
    //MARK:- Life Cycle Method

    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
        
    }


}
