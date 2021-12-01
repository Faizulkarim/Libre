//
//  TutorialViewController.swift
//  Libre
//
//  Created by piash sarker on 25/7/21.
//

import UIKit

class TutorialViewController: UIViewController {
    @IBOutlet weak var dontHaveAccountLabel: UILabel!
    @IBOutlet weak var signupButton: UIButton!
    @IBOutlet weak var skipButton: UIButton!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var libre: UILabel!
    @IBOutlet weak var WellcomeView: UIView!
    @IBOutlet weak var socialView: UIView!
    @IBOutlet weak var FaceAnnomView: UIView!
    @IBOutlet weak var dotOne: UIView!
    @IBOutlet weak var dotTwo: UIView!
    @IBOutlet weak var dotThree: UIView!
    
    //MARK:- Class Variable
    var viewTrack = 0

    
    //MARK:- Memory Management Method
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    deinit {
        print("💥💥💥 Tutorial Deinit 💥💥💥")
    }
    
    //MARK:- Custom Method
    
    func setupView(){
        dontHaveAccountLabel.addCharacterSpacing()
        libre.addCharacterSpacing(kernValue: 5.00)
        skipButton.clipsToBounds = true
        skipButton.layer.cornerRadius = 5
        nextButton.clipsToBounds = true
        nextButton.layer.cornerRadius = 5
        nextButton.applyGradient(colours: [ UIColor.colorFromHex(hex: 0x545454), UIColor.colorFromHex(hex: 0x000000),UIColor.colorFromHex(hex: 0x545454)], locations: [0.0 , 05, 1.0])
        skipButton.handleTapToAction {
            self.PushToNextViewController()
        }
        
    
        
    }
    
    func PushToNextViewController(){
        let vc = LoginAndSignUpViewController.instantiate(fromAppStoryboard: .kLoginStoryboard)

        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    
    //------------------------------------------------------
    
    //MARK:- Action Method

    @IBAction func Next(_ sender: Any) {
        switch viewTrack {
        case 0:
            WellcomeView.isHidden = true
            viewTrack = 1
            dotTwo.backgroundColor = UIColor.black
            dotOne.alpha = 0.28
        case 1:
            socialView.isHidden = true
            viewTrack = 2
            dotTwo.alpha = 0.28
            dotThree.backgroundColor = UIColor.black
            nextButton.backgroundColor = UIColor.red
           // nextButton.applyGradient(colours: [UIColor.colorFromHex(hex: 0xD92424), UIColor.colorFromHex(hex: 0xA40606)])
        case 2:
            UserDefaults.standard.set(1, forKey: isWalkthrough)
            PushToNextViewController()
          
        default:
            break
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

    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
}
