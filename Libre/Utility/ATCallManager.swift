//
//  ATCallManager.swift
//
//  Created by Faizul Karim on 5/12/21.
//


import UIKit
import CallKit
import PushKit
import SwiftyJSON

class ATCallManager: NSObject {

    static let shared: ATCallManager = ATCallManager()
    private var provider: CXProvider?
    var callObserver = CXCallObserver()
    var callType = 0
    private override init() {
        super.init()
        self.configureProvider()
    }

    
    private func configureProvider() {
        let config = CXProviderConfiguration(localizedName: "AT Call")
        config.supportsVideo = true
        config.supportedHandleTypes = [.emailAddress]
        config.maximumCallGroups = 1
        provider = CXProvider(configuration: config)
        provider?.setDelegate(self, queue: DispatchQueue.main)
        callObserver.setDelegate(self, queue: nil)
    }
    
    private var voipRegistry : PKPushRegistry?
    public func configurePushKit() {
//        voipRegistry.delegate = self
//        voipRegistry.desiredPushTypes = [.voIP]
        guard voipRegistry == nil else {return}

        voipRegistry = PKPushRegistry(queue: DispatchQueue.main)
        voipRegistry!.desiredPushTypes = Set([PKPushType.voIP])
        voipRegistry!.delegate = self
        useVoipToken(voipRegistry!.pushToken(for: .voIP))
        
      
    }
    private func useVoipToken(_ tokenData: Data?) {
        print("Voip token: \(tokenData)")
           // Do whatever with the token

       }
    
    public func incommingCall(from: String) {
        incommingCall(from: from, delay: 0)
    }
    
    public func incommingCall(from: String, delay: TimeInterval) {
        let update = CXCallUpdate()
        update.remoteHandle = CXHandle(type: .emailAddress, value: from)
        
        let bgTaskID = UIApplication.shared.beginBackgroundTask(expirationHandler: nil)
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + delay) {
            self.provider?.reportNewIncomingCall(with: UUID(), update: update, completion: { (_) in })
            UIApplication.shared.endBackgroundTask(bgTaskID)
        }
    }
    
    public func outgoingCall(from: String, connectAfter: TimeInterval) {
        let controller = CXCallController()
        let fromHandle = CXHandle(type: .emailAddress, value: from)
        let startCallAction = CXStartCallAction(call: UUID(), handle: fromHandle)
        startCallAction.isVideo = true
        let startCallTransaction = CXTransaction(action: startCallAction)
        controller.request(startCallTransaction) { (error) in }
        
        self.provider?.reportOutgoingCall(with: startCallAction.callUUID, startedConnectingAt: nil)
        
        let bgTaskID = UIApplication.shared.beginBackgroundTask(expirationHandler: nil)
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + connectAfter) {
            self.provider?.reportOutgoingCall(with: startCallAction.callUUID, connectedAt: nil)
            UIApplication.shared.endBackgroundTask(bgTaskID)
        }
    }
}

extension ATCallManager: CXProviderDelegate {
    func providerDidReset(_ provider: CXProvider) {
        print("provider did reset")
    }
    
    func provider(_ provider: CXProvider, perform action: CXAnswerCallAction) {
        print("call answered")
        NotificationCenter.default.post(name: Notification.Name("NotificationIdentifier"), object: nil, userInfo: ["Renish":"Dadhaniya"])
        GFunction.shared.setHomeScreen()
        callType = 0
        action.fulfill()
    }
    
    func provider(_ provider: CXProvider, perform action: CXEndCallAction) {
        print("call ended")
        action.fulfill()
    }
    
    func provider(_ provider: CXProvider, perform action: CXStartCallAction) {
        print("call started")
       
        action.fulfill()
    }
}
extension ATCallManager : CXCallObserverDelegate{
    func callObserver(_ callObserver: CXCallObserver, callChanged call: CXCall) {
        if call.isOutgoing == true && call.hasConnected == false && call.hasEnded == false {
            //.. 1. detect a dialing outgoing call
          }
          if call.isOutgoing == true && call.hasConnected == true && call.hasEnded == false {
            //.. 2. outgoing call in process
          }
          if call.isOutgoing == false && call.hasConnected == false && call.hasEnded == false {
            //.. 3. incoming call ringing (not answered)
          }
          if call.isOutgoing == false && call.hasConnected == true && call.hasEnded == false {
            //.. 4. incoming call in process
          }
          if call.isOutgoing == true && call.hasEnded == true {
            //.. 5. outgoing call ended.
          }
          if call.isOutgoing == false && call.hasEnded == true {
            //.. 6. incoming call ended.
          }
          if call.hasConnected == true && call.hasEnded == false && call.isOnHold == false {
            //.. 7. call connected (either outgoing or incoming)
          }
          if call.isOutgoing == true && call.isOnHold == true {
            //.. 8. outgoing call is on hold
          }
          if call.isOutgoing == false && call.isOnHold == true {
            //.. 9. incoming call is on hold
          }
      }
    
}

extension ATCallManager: PKPushRegistryDelegate {
    func pushRegistry(_ registry: PKPushRegistry, didUpdate pushCredentials: PKPushCredentials, for type: PKPushType) {

        let token = pushCredentials.token.map { String(format: "%02.2hhx", $0) }.joined()
        if token != GFunction.shared.getStringValueForKey(UserDefaultsKeys.kVoipToken.rawValue){
            GFunction.shared.setStringValueWithKey(token, key: UserDefaultsKeys.kVoipToken.rawValue)
        }
        
        print("token: \(token)")
    }
    

    func pushRegistry(_ registry: PKPushRegistry, didReceiveIncomingPushWith payload: PKPushPayload, for type: PKPushType, completion: @escaping () -> Void) {
        print(JSON(payload.dictionaryPayload))
        if let callT = payload.dictionaryPayload["callType"] as? Int{
            callType = callT
        }
        if let callerID = payload.dictionaryPayload["username"] as? String {
            self.incommingCall(from: callerID)
        }
    }
    
}

