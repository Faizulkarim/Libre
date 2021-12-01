//
//  aboutMeViewController.swift
//  Libre
//
//  Created by piash sarker on 1/8/21.
//

import UIKit

class aboutMeViewController: UIViewController,UITextViewDelegate {

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
        if UserModel.currentUser != nil {
            if !(UserModel.currentUser?.aboutYou.isEmpty)!{
                self.aboutText.text = UserModel.currentUser?.aboutYou
            }
        }
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView == self.aboutText {
            userChosenData.aboutText = textView.text!
        }
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        guard let viewText = aboutText.text else { return true }
          let length = viewText.count + text.count - range.length
          let count = 300 - length
          remainigTxt.text =  "\(count)/300"
          return length <= 300
    }
    
    
    //------------------------------------------------------
    //MARK:- Action method
    
    @IBAction func next(_ sender: Any) {
        GFunction.shared.setHomeScreen()
    }
    
    

    
    //------------------------------------------------------
    //MARK:- Life Cycle Method

    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
        
    }

}
