//
//  OngoingCallViewController.swift
//  Libre
//
//  Created by piash sarker on 30/7/21.
//

import UIKit
import AgoraRtcKit
class OngoingCallViewController: UIViewController {
    @IBOutlet weak var backgorundView: UIView!
    @IBOutlet weak var muteButton: UIButton!
    @IBOutlet weak var spekerbutton: UIButton!
    @IBOutlet weak var callend: UIButton!
    var agoraKit: AgoraRtcEngineKit?
    
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
    func initializeAgoraEngine() {
           // Initializes AgoraRtcEngineKit
        agoraKit = AgoraRtcEngineKit.sharedEngine(withAppId: AgroraCredintial.AgoraAppId.rawValue, delegate: self)
        }
    func joinChannel() {
         // Replace demoChannel with the channel name that you use to generate the temporary token
        agoraKit?.joinChannel(byToken: AgroraCredintial.AgoraToken.rawValue, channelId: "Faizul", info:nil, uid:0) {[unowned self] (sid, uid, elapsed) -> Void in
             //UIApplication.shared.isIdleTimerDisabled = true
            
            print(sid)
         }
     }
    
    func setupView(){
    
        self.backgorundView.applyGradient(colours: [UIColor.colorFromHex(hex: 0x53494C), UIColor.colorFromHex(hex: 0x110F0F)])
        self.muteButton.roundCorners(corners: .allCorners, radius: 27.5)
        self.spekerbutton.roundCorners(corners: .allCorners, radius: 27.5)
        
        self.callend.handleTapToAction {
            self.agoraKit!.leaveChannel(nil)
            AgoraRtcEngineKit.destroy()
            self.pushToCallHistoryViewController()
        }
   

    }


    
    func pushToCallHistoryViewController(){
        let vc = CallHistoryViewController.instantiate(fromAppStoryboard: .kTabbarStoryboard)
      
        self.navigationController?.pushViewController(vc, animated: true)
    }
        

    
    
    //------------------------------------------------------
    //MARK:- Action method


    
    
    //------------------------------------------------------
    //MARK:- Life Cycle Method

    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
        initializeAgoraEngine()
        joinChannel()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.clearNavigation()
        self.navigationController?.navigationBar.isHidden = true
        self.hideTabBar()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    @IBAction func mute(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        agoraKit!.muteLocalAudioStream(sender.isSelected)
        if sender.isSelected {
            self.muteButton.backgroundColor = UIColor.ColorTheme
        }else{
            self.muteButton.backgroundColor = UIColor.white.withAlphaComponent(0.19)
           
        }
    }
    
    @IBAction func loudSpeaker(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        self.agoraKit?.setEnableSpeakerphone(sender.isSelected)
        if sender.isSelected {
            self.spekerbutton.backgroundColor = UIColor.ColorTheme
        }else{
            self.spekerbutton.backgroundColor = UIColor.white.withAlphaComponent(0.19)
           
        }
    }
    
}
extension OngoingCallViewController: AgoraRtcEngineDelegate {
    // This callback is triggered when a remote user joins the channel
    func rtcEngine(_ engine: AgoraRtcEngineKit, didJoinedOfUid uid: UInt, elapsed: Int) {

        print("This is other UID:\(uid)")
    }
    func rtcEngine(_ engine: AgoraRtcEngineKit, didLeaveChannelWith stats: AgoraChannelStats) {
        
        print(stats)
    }
}

