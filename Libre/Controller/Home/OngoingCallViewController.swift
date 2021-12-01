//
//  OngoingCallViewController.swift
//  Libre
//
//  Created by piash sarker on 30/7/21.
//

import UIKit
import TwilioVideo
class OngoingCallViewController: UIViewController {
    @IBOutlet weak var backgorundView: UIView!
    @IBOutlet weak var muteButton: UIButton!
    @IBOutlet weak var spekerbutton: UIButton!
    @IBOutlet weak var callend: UIButton!
    @IBOutlet weak var fontCameraView: UIView!
    
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
        
        self.callend.handleTapToAction {
            self.pushToCallHistoryViewController()
        }
        self.showFontCameraView()
    }
    var localAudioTrack = TVILocalAudioTrack()

    // Create a Capturer to provide content for the video track
    var localVideoTrack : TVILocalVideoTrack?

    // Create a video track with the capturer.
    if let camera = TVICameraCapturer(source: .frontCamera) {
        localVideoTrack = TVILocalVideoTrack.init(capturer: camera)
    }
    
    func pushToCallHistoryViewController(){
        let vc = CallHistoryViewController.instantiate(fromAppStoryboard: .kTabbarStoryboard)
      
        self.navigationController?.pushViewController(vc, animated: true)
    }
        
        func showFontCameraView(){
            if let camera = TVICameraCapturer(source: .frontCamera),
                let videoTrack = TVILocalVideoTrack(capturer: camera) {

                // TVIVideoView is a TVIVideoRenderer and can be added to any TVIVideoTrack.
                let renderer = TVIVideoView(frame: view.bounds)

                // Add renderer to the video track
                videoTrack.addRenderer(renderer)

                self.localVideoTrack = videoTrack
                self.camera = camera
                self.fontCameraView.addSubview(renderer)
            } else {
                print("Couldn't create TVICameraCapturer or TVILocalVideoTrack")
            }
        }
    
    
    //------------------------------------------------------
    //MARK:- Action method


    
    
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
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    
    @IBAction func callEnd(_ sender: Any) {
        let connectOptions = TVIConnectOptions.init(token: accessToken) { (builder) in
            builder.roomName = "my-room"
            if let audioTrack = localAudioTrack {
                builder.audioTracks = [ audioTrack ]
            }
            if let videoTrack = localVideoTrack {
                builder.videoTracks = [ videoTrack ]
            }
        }
        room = TwilioVideo.connect(with: connectOptions, delegate: self)
    }
    
    // MARK: TVIRoomDelegate

    func didConnectToRoom(room: TVIRoom) {
        print("Did connect to Room")
        if let localParticipant = room.localParticipant {
            print("Local identity \(localParticipant.identity)")
        }

        // Connected participants
        let participants = room.participants;
        print("Number of connected Participants \(participants.count)")
        
        
    }
    func room(_ room: TVIRoom, participantDidConnect participant: TVIRemoteParticipant) {
        participant.delegate = self
        print ("Participant \(participant.identity) has joined Room \(room.name)")
    }

    func room(_ room: TVIRoom, participantDidDisconnect participant: TVIRemoteParticipant) {
        print ("Participant \(participant.identity) has left Room \(room.name)")
    }
    
    // MARK: TVIParticipantDelegate

    /*
     * In the Participant Delegate, we can respond when the Participant adds a Video
     * Track by rendering it on screen.
     */
    func participant(_ participant: TVIParticipant, addedVideoTrack videoTrack: TVIVideoTrack) {
        print("Participant \(participant.identity) added video track")

        self.remoteView = TVIVideoView(frame: self.view.bounds, delegate: self)
        videoTrack.addRenderer(self.remoteView)

        self.view.addSubview(self.remoteView!)
    }

    // MARK: TVIVideoViewDelegate

    // Lastly, we can subscribe to important events on the VideoView
    func videoView(_ view: TVIVideoView, videoDimensionsDidChange dimensions: CMVideoDimensions) {
        print("The dimensions of the video track changed to: \(dimensions.width)x\(dimensions.height)")
        self.view.setNeedsLayout()
    }
    
    


}
