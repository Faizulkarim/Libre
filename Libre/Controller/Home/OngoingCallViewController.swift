//
//  OngoingCallViewController.swift
//  Libre
//
//  Created by piash sarker on 30/7/21.
//

import UIKit
import CallKit
import AgoraRtcKit
class OngoingCallViewController: UIViewController {
    @IBOutlet weak var backgorundView: UIView!
    @IBOutlet weak var muteButton: UIButton!
    @IBOutlet weak var spekerbutton: UIButton!
    @IBOutlet weak var callend: UIButton!
    @IBOutlet weak var time: UILabel!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var ringStatus: UILabel!
    
    var recipientId = ""
    var recipientName = ""
    //MARK:- Memory Management Method
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    deinit {
        print("💥💥💥 OngoingCallViewController Deinit💥💥💥")
    }
    
    //------------------------------------------------------
    //MARK:- Custom Method
    func setupView(){
        
        self.backgorundView.applyGradient(colours: [UIColor.colorFromHex(hex: 0x53494C), UIColor.colorFromHex(hex: 0x110F0F)])
        self.muteButton.roundCorners(corners: .allCorners, radius: 27.5)
        self.spekerbutton.roundCorners(corners: .allCorners, radius: 27.5)
        self.time.isHidden = true
        self.name.text = recipientName.capitalized
        self.callend.handleTapToAction { [self] in
            communicationManager.shared.leaveChannel()
            if AppDelegate.shared.uid != nil {
            endCall(call: AppDelegate.shared.uid!)
            }
            self.pushToCallHistoryViewController()
        }
        
    }

    
    func endCall(call: UUID) {
        let controller = CXCallController()
        let transaction = CXTransaction(action:
        CXEndCallAction(call: call))
        controller.request(transaction,completion: { error in })

    }
    func pushToCallHistoryViewController(){
        let vc = CallHistoryViewController.instantiate(fromAppStoryboard: .kTabbarStoryboard)
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    //------------------------------------------------------
    //MARK:- Action method
    @IBAction func mute(_ sender: UIButton) {
        if communicationManager.shared.mute(sender: spekerbutton) {
            self.muteButton.backgroundColor = UIColor.ColorTheme
        }else{
            self.muteButton.backgroundColor = UIColor.white.withAlphaComponent(0.19)
            
        }
    }
    
    @IBAction func loudSpeaker(_ sender: UIButton) {
        if communicationManager.shared.loudSpeaker(sender: spekerbutton) {
            self.spekerbutton.backgroundColor = UIColor.ColorTheme
        }else{
            self.spekerbutton.backgroundColor = UIColor.white.withAlphaComponent(0.19)
            
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
        self.hideTabBar()
        if recipientId != ""{
            makeAcall(recipientId: recipientId)
        }
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
}
extension OngoingCallViewController {
    private func makeAcall(recipientId: String) {
        let params : [String : Any] = [
            "userId": UserModel.currentUser?.userId as Any,
            "recipientId" : recipientId,
            "callType" : 1
            // call type one is audio and two is video
        ]
        print(params)
        ApiManager.shared.makeRequest(method:.user(.pushaCall), methodType: .post, parameter: params, withErrorAlert: true, withLoader: false, withdebugLog: true) { [self] (result) in
            
            switch result {
            case .success(let apiData):
                print(result)
                switch apiData.apiCode {
                case .success:
                    let response = apiData.response
                    // ATCallManager.shared.outgoingCall(from: "faizul", connectAfter: 2)
                    self.ringStatus.text = "Ringing"
                    communicationManager.shared.joinChannel(name: "faizul", token: AgroraCredintial.AgoraToken.rawValue)
                    print(response)
                default:
                    print(apiData.message)
                    GFunction.shared.showSnackBar(apiData.message)
                }
                
            case .failure(let failedMsg):
                print(failedMsg)
                break
            }
        }
    }
}

extension OngoingCallViewController : AgoraRtcEngineDelegate{
    
}

