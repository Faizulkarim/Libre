//
//  ContactUsViewController.swift
//  Libre
//
//  Created by piash sarker on 2/8/21.
//

import UIKit

class ContactUsViewController: UIViewController {
    @IBOutlet weak var name: UITextField!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var text: UITextView!
    @IBOutlet weak var SubmitButton: ButtonWordSpecing!
    
    
    //MARK:- Memory Management Method
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    deinit {
        print("💥💥💥 ProfessonViewController Deinit💥💥💥")
    }
    
    //------------------------------------------------------
    //MARK:- Custom Method
    
    
    func setupView(){
        self.name.setBorderWithCornerRedious(cornerRedius: 5.0, borderWidth: 3, borderColor: UIColor.colorFromHex(hex: 0xD5D5D5).cgColor)
        self.email.setBorderWithCornerRedious(cornerRedius: 5.0, borderWidth: 3, borderColor: UIColor.colorFromHex(hex: 0xD5D5D5).cgColor)
        self.text.applyStyle(titleFont: nil, titleColor: nil, cornerRadius: 2, borderColor: UIColor.black, borderWidth: 1.0, backgroundColor: nil, state: .normal, leftImage: nil, rightImage: nil)
        self.SubmitButton.applyGradient(colours: [UIColor.colorFromHex(hex: 0xCF4E4E), UIColor.colorFromHex(hex: 0x6E2A2A)])
   

    
    }
    
    func pushToBackgroundImageViewController(){
        let vc = UploadBackgroundViewController.instantiate(fromAppStoryboard: .kLoginStoryboard)
      
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    //------------------------------------------------------
    //MARK:- Action method

    @IBAction func gotoHome(_ sender: Any) {
        GFunction.shared.setHomeScreen()
    }

    
    
    
    //------------------------------------------------------
    //MARK:- Life Cycle Method

    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.setGradientBackground(colors: [UIColor.colorFromHex(hex: 0x4D4347), UIColor.colorFromHex(hex: 0x5D4147)])

    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }

}
