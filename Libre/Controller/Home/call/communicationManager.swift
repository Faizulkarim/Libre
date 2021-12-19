//
//  Audio.swift
//  Libre
//
//  Created by Faizul Karim on 15/12/21.
//

import Foundation
import AgoraRtcKit

class communicationManager : NSObject {
    
    static let shared: communicationManager = communicationManager()
    var agoraKit: AgoraRtcEngineKit?
    private override init() {
        super.init()
        configureAudioSession()
    }
    func configureAudioSession() {
        agoraKit = AgoraRtcEngineKit.sharedEngine(withAppId: AgroraCredintial.AgoraAppId.rawValue, delegate: self)
    }
    
    public func joinChannel(name: String, token: String) {
        // Replace demoChannel with the channel name that you use to generate the temporary token
        //agoraKit.setaudio
        agoraKit?.joinChannel(byToken: token, channelId: name, info:nil, uid:0) {[unowned self] (sid, uid, elapsed) -> Void in
            UIApplication.shared.isIdleTimerDisabled = true
            
            print(sid)
        }
    }
    
    public func enableVideo(localView: UIView){
        agoraKit?.enableVideo()
        agoraKit?.setDefaultAudioRouteToSpeakerphone(true)
        let videoCanvas = AgoraRtcVideoCanvas()
        videoCanvas.uid = 0
        videoCanvas.renderMode = .hidden
        videoCanvas.view = localView
        agoraKit?.setupLocalVideo(videoCanvas)
    }
    public func switchCamera(){
        agoraKit?.switchCamera()
    }
    public func leaveChannel() {
        self.agoraKit!.leaveChannel(nil)
        AgoraRtcEngineKit.destroy()
    }
    
    public func loudSpeaker(sender: UIButton)-> Bool{
        sender.isSelected = !sender.isSelected
        self.agoraKit?.setEnableSpeakerphone(sender.isSelected)
        return sender.isSelected
    }
    public func mute(sender: UIButton) -> Bool{
        sender.isSelected = !sender.isSelected
        agoraKit!.muteLocalAudioStream(sender.isSelected)
        return sender.isSelected
    }
    public func muteVideo(sender: UIButton) -> Bool {
        sender.isSelected = !sender.isSelected
        agoraKit?.muteLocalVideoStream(sender.isSelected)
        return sender.isSelected
    }
    
    
    
}

extension communicationManager: AgoraRtcEngineDelegate {
    // This callback is triggered when a remote user joins the channel
    func rtcEngine(_ engine: AgoraRtcEngineKit, didJoinedOfUid uid: UInt, elapsed: Int) {
        print(uid)
        let uid: [String: Any] = ["uid": uid]
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "uid"), object: nil, userInfo: uid)
        print("This is other UID:\(uid)")
    }
    func rtcEngine(_ engine: AgoraRtcEngineKit, didLeaveChannelWith stats: AgoraChannelStats) {
        print(stats)
    }
    
    internal func rtcEngine(_ engine: AgoraRtcEngineKit, didOfflineOfUid uid:UInt, reason:AgoraUserOfflineReason) {
   // self.remoteView.isHidden = true
    }
    func rtcEngine(_ engine: AgoraRtcEngineKit, didVideoMuted muted:Bool, byUid:UInt) {
      //  remoteView.isHidden = muted
        
        print("mute")
      
    }
    func rtcEngine(_ engine: AgoraRtcEngineKit, didUpdatedUserInfo userInfo: AgoraUserInfo, withUid uid: UInt) {
        print(userInfo)
    }
}
