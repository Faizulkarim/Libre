//
//  OngoinVideoController.swift
//  Libre
//
//  Created by Faizul Karim on 5/12/21.
//

import UIKit
import AgoraRtcKit
import Moya
import CallKit
class OngoinVideoController: UIViewController {
    
    @IBOutlet weak var callStatus: UILabel!
    @IBOutlet weak var callEndButton: UIButton!
    @IBOutlet weak var videoMuteButton: UIButton!
    @IBOutlet weak var remoteView: UIView!
    @IBOutlet weak var muteButton: UIButton!
    @IBOutlet weak var cameraSwitchButton: UIButton!
    
    // @IBOutlet weak var endButton: ThemeButton!
    var localView: UIView!
    var recipientId = ""
    var recipientName = ""
    let videoCanvas = AgoraRtcVideoCanvas()
    var callManager: CallManager?
    fileprivate let callObserver = CXCallObserver()
    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
        callObserver.setDelegate(self, queue: nil)
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        localView.frame = CGRect(x: self.view.bounds.width - 90, y: 0, width: 140, height: 180)
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
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
    
    func initView() {
        localView = UIView()
        self.view.addSubview(localView)
        self.muteButton.roundCorners(corners: .allCorners, radius: 25)
        self.videoMuteButton.roundCorners(corners: .allCorners, radius: 25)
        self.callEndButton.roundCorners(corners: .allCorners, radius: 25)
        self.cameraSwitchButton.roundCorners(corners: .allCorners, radius: 25)
       /// communicationManager.shared.enableVideo(localView: localView)
        communicationManager.shared.enableVideo(localView: localView)
        NotificationCenter.default.addObserver(self, selector: #selector(self.receiveData(_:)), name: NSNotification.Name(rawValue: "uid"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.status(_:)), name: NSNotification.Name(rawValue: "status"), object: nil)
    }
    @objc func receiveData(_ notification: NSNotification) {
        if let uid = notification.userInfo?["uid"] as? UInt {
          //  communicationManager.shared.enableVideo(localView: localView)
            videoCanvas.uid = uid
            videoCanvas.renderMode = .hidden
            videoCanvas.view = remoteView
            communicationManager.shared.agoraKit?.setupRemoteVideo(videoCanvas)
            self.callStatus.text = "Connected"
            
        }
        
    }
    @objc func status(_ notification: NSNotification) {
        if let status = notification.userInfo?["status"] as? Int {
            switch status {
            case 1:
                print("rejecte")
                // rejected
                self.callStatus.text = "Rejected"
                communicationManager.shared.leaveChannel()
                DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
                    self.navigationController?.popViewController(animated: true)
                }
               
            case 2:
                //anserd
                self.callStatus.text = "Connected"
                
            case 3:
                self.callStatus.text = "on mute"
                //muted
                print("mute")
            case 4 :
               //ended
                communicationManager.shared.leaveChannel()
               
                if AppDelegate.shared.uid != nil{
                    endCall(call: AppDelegate.shared.uid!)
                }
                self.pushToCallHistoryViewController()
                print("ended")
            default:
                break
            }
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
    
    
    @IBAction func end(_ sender: Any) {
       // self.APIcallStatucChange(status: callId!)
        communicationManager.shared.leaveChannel()
        if AppDelegate.shared.uid != nil {
          endCall(call: AppDelegate.shared.uid!)
        }

       
    }
    
    @IBAction func mute(_ sender: UIButton) {
        if communicationManager.shared.mute(sender: muteButton) {
            self.muteButton.backgroundColor = UIColor.ColorTheme
        }else{
            self.muteButton.backgroundColor = UIColor.clear
        }
    }
    
    @IBAction func switchCamera(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        communicationManager.shared.switchCamera()
        if sender.isSelected {
            self.cameraSwitchButton.backgroundColor = UIColor.ColorTheme
        }else{
            self.cameraSwitchButton.backgroundColor = UIColor.clear
        }
    }
    
    @IBAction func videoMute(_ sender: Any) {
        if communicationManager.shared.muteVideo(sender: videoMuteButton) {
            self.videoMuteButton.backgroundColor = UIColor.ColorTheme
        }else{
            self.videoMuteButton.backgroundColor = UIColor.clear
        }
    }
    
}


extension OngoinVideoController {

    private func makeAcall(recipientId: String) {
        
        let params : [String : Any] = [
            "userId": UserModel.currentUser?.userId as Any,
            "recipientId" : recipientId,
            "callType" : 2
            
        ]
        print(params)
        
        ApiManager.shared.makeRequest(method:.user(.pushaCall), methodType: .post, parameter: params, withErrorAlert: true, withLoader: false, withdebugLog: true) { (result) in
            
            switch result {
            case .success(let apiData):
                print(result)
                switch apiData.apiCode {
                case .success:
                    let response = apiData.response
                    if let callid = response["callId"].int{
                        myCallId.callId = callid
                        self.callManager?.startCall(handle: "faizul", videoEnabled: true)
                        communicationManager.shared.joinChannel(name: "faizul", token: AgroraCredintial.AgoraToken.rawValue)
                    }
                    print(response)
                
                default:
                    GFunction.shared.showSnackBar(apiData.message)
                }
                
            case .failure(let failedMsg):
                print(failedMsg)
                break
            }
        }
    }
}
extension OngoinVideoController : CXCallObserverDelegate {
    func callObserver(_ callObserver: CXCallObserver, callChanged call: CXCall) {

        if call.hasConnected {
            print("Call Connect -> \(call.uuid)")
            GlobalAPI.shared.APICallStatusChange(status: 2) { success in
                
                if success{
                    print(success)
                    self.callStatus.text = "Connected"
                }
            }
        }

        if call.isOutgoing {
            print("Call outGoing \(call.uuid)")
            self.callStatus.text = "calling"
        }

        if call.hasEnded {
            print("Call hasEnded \(call.uuid)")
            GlobalAPI.shared.APICallStatusChange(status: 4) { success in
                
                if success{
                    print(success)
                    self.navigationController?.popViewController(animated: true)
                }
            }
          
        }

        if call.isOnHold {
            print("Call onHold \(call.uuid)")
            GlobalAPI.shared.APICallStatusChange(status: 3) { success in
                
                if success{
                    print(success)
                    self.callStatus.text = "Mute"
                }
            }
          }
      }
}

