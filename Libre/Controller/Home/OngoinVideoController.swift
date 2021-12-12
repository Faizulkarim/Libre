//
//  OngoinVideoController.swift
//  Libre
//
//  Created by Faizul Karim on 5/12/21.
//

import UIKit
import AgoraRtcKit

class OngoinVideoController: UIViewController {

    @IBOutlet weak var muteButton: ThemeButton!
   // @IBOutlet weak var endButton: ThemeButton!
    var agoraKit: AgoraRtcEngineKit?
    var localView: UIView!
    var remoteView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
        initializeAndJoinChannel()
        //self.bottomView.layer.zPosition = 1
        self.muteButton.layer.zPosition = 10
      //  self.endButton.layer.zPosition = 10
        // Do any additional setup after loading the view.
    }
    override func viewDidLayoutSubviews() {
         super.viewDidLayoutSubviews()
         remoteView.frame = self.view.bounds
         localView.frame = CGRect(x: self.view.bounds.width - 90, y: 0, width: 90, height: 160)
     }
    override func viewDidDisappear(_ animated: Bool) {
           super.viewDidDisappear(animated)
  
     }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.clearNavigation()
        self.navigationController?.navigationBar.isHidden = true
        self.hideTabBar()
    }

    func initView() {
        remoteView = UIView()
        self.view.addSubview(remoteView)
        localView = UIView()
        self.view.addSubview(localView)
    }
    func pushToCallHistoryViewController(){
        let vc = CallHistoryViewController.instantiate(fromAppStoryboard: .kTabbarStoryboard)
      
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func initializeAndJoinChannel() {
      // Pass in your App ID here
      agoraKit = AgoraRtcEngineKit.sharedEngine(withAppId: AgroraCredintial.AgoraAppId.rawValue, delegate: self)
      // Video is disabled by default. You need to call enableVideo to start a video stream.
      agoraKit?.enableVideo()
           // Create a videoCanvas to render the local video
           let videoCanvas = AgoraRtcVideoCanvas()
           videoCanvas.uid = 0
           videoCanvas.renderMode = .hidden
           videoCanvas.view = localView
           agoraKit?.setupLocalVideo(videoCanvas)

      // Join the channel with a token. Pass in your token and channel name here
        agoraKit?.setDefaultAudioRouteToSpeakerphone(true)
      agoraKit?.joinChannel(byToken: AgroraCredintial.AgoraToken.rawValue, channelId: "Faizul", info: nil, uid: 0, joinSuccess: { (channel, uid, elapsed) in
          
          print("Channel:\(channel), UID: \(uid)")
           })
       }
    
   
    
    @IBAction func end(_ sender: Any) {
        agoraKit?.leaveChannel(nil)
        AgoraRtcEngineKit.destroy()
        pushToCallHistoryViewController()
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
    
    @IBAction func switchCamera(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        agoraKit?.switchCamera()
    }
    

}
extension OngoinVideoController: AgoraRtcEngineDelegate {
    // This callback is triggered when a remote user joins the channel
    func rtcEngine(_ engine: AgoraRtcEngineKit, didJoinedOfUid uid: UInt, elapsed: Int) {
        print(uid)
        let videoCanvas = AgoraRtcVideoCanvas()
        videoCanvas.uid = uid
        videoCanvas.renderMode = .hidden
        videoCanvas.view = remoteView
        agoraKit?.setupRemoteVideo(videoCanvas)
    }
    internal func rtcEngine(_ engine: AgoraRtcEngineKit, didOfflineOfUid uid:UInt, reason:AgoraUserOfflineReason) {
    self.remoteView.isHidden = true
    }
    func rtcEngine(_ engine: AgoraRtcEngineKit, didVideoMuted muted:Bool, byUid:UInt) {
        remoteView.isHidden = muted
      
    }
    
}

