//
//  ReportViewController.swift
//  Libre
//
//  Created by piash sarker on 31/7/21.
//

import UIKit

class ReportViewController: UIViewController {
    @IBOutlet weak var reportText: UITextView!
    
    //MARK:- Memory Management Method
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    deinit {
        print("💥💥💥 ReportViewController Deinit💥💥💥")
    }
    
    //------------------------------------------------------
    //MARK:- Custom Method
    
    
    func setupView(){
    
        self.reportText.applyCornerRadius(cornerRadius: 10, borderColor: UIColor.gray, borderWidth: 1)
    }
    
    func pushToBackgroundImageViewController(){
        let vc = UploadBackgroundViewController.instantiate(fromAppStoryboard: .kLoginStoryboard)
      
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    //------------------------------------------------------
    //MARK:- Action method
    
    @IBAction func reportUser(_ sender: Any) {
        self.popViewController(sender: self)
    }
    
    
    
    //------------------------------------------------------
    //MARK:- Life Cycle Method

    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.hideTabBar()

    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }

}
