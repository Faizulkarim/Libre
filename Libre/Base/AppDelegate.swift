//
//  AppDelegate.swift
//  Libre
//
//  Created by piash sarker on 23/7/21.
//

import UIKit
import GoogleMaps
import GooglePlaces
import IQKeyboardManagerSwift
import PushKit
import CallKit
import UserNotifications
@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    var isFirstTimeAppSelected = true
    var providerDelegate: ProviderDelegate!
    let callManager = CallManager()
    var callType = 0
    var callId = 0
    var uid : UUID?
    let keyWindow = UIApplication.shared.connectedScenes
            .filter({$0.activationState == .foregroundActive})
            .compactMap({$0 as? UIWindowScene})
            .first?.windows
            .filter({$0.isKeyWindow}).first
    static let shared = UIApplication.shared.delegate as! AppDelegate
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        //ATCallManager.shared.configurePushKit()
        setup()
        configurePushKit()
        registerForPushNotifications()
        providerDelegate = ProviderDelegate(callManager: callManager)
        GMSServices.provideAPIKey(AppCredential.googlePlaceID.rawValue)
        GMSPlacesClient.provideAPIKey(AppCredential.googlePlaceID.rawValue)
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
    func applicationDidBecomeActive(_ application: UIApplication) {
        if UserDefaults.standard.value(forKey: UserDefaultsKeys.kIsLogin.rawValue) as? Bool == true {
          //  GlobalAPI.shared.APICallUpdateDeviceToken()
        }
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {

    }
    
    private var voipRegistry : PKPushRegistry?
    public func configurePushKit() {
//        voipRegistry.delegate = self
//        voipRegistry.desiredPushTypes = [.voIP]
        guard voipRegistry == nil else {return}

        voipRegistry = PKPushRegistry(queue: DispatchQueue.main)
        voipRegistry!.desiredPushTypes = Set([PKPushType.voIP])
        voipRegistry!.delegate = self
     //   useVoipToken(voipRegistry!.pushToken(for: .voIP))
        
      
    }

 


}

extension AppDelegate {
    
    func setup(){
        basicSetUp()
        setKeyBoard()
        LocationManager.shared.getLocation()
        
    }
    func setKeyBoard() {
        IQKeyboardManager.shared.enable                                           = true
        IQKeyboardManager.shared.enableAutoToolbar                                = true
        IQKeyboardManager.shared.keyboardDistanceFromTextField                    = 5
        IQKeyboardManager.shared.shouldResignOnTouchOutside                       = true
        IQKeyboardManager.shared.toolbarTintColor                                 = kTHEMECOLOR
    }
    
    func basicSetUp() {
        GFunction.shared.manageRootController()
        QorumLogs.enabled = true
        QorumLogs.emojisForLogLevels = ["","","","","",""]
    }
    
}
extension AppDelegate {
    
    func registerForPushNotifications() {
        UNUserNotificationCenter.current().delegate = self
        UNUserNotificationCenter.current()
            .requestAuthorization(options: [.alert, .sound, .badge]) {
                granted, error in
                print("Permission granted: \(granted)")
              
                DispatchQueue.main.async {
                    UIApplication.shared.registerForRemoteNotifications()
                }
        }
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        
        let deviceTokenString = deviceToken.reduce("", {$0 + String(format: "%02X", $1)})
        if deviceTokenString != GFunction.shared.getStringValueForKey(UserDefaultsKeys.kDeviceToken.rawValue){
            GFunction.shared.setStringValueWithKey(deviceTokenString, key: UserDefaultsKeys.kDeviceToken.rawValue)
        }
        debugPrint("\(deviceToken):- \(deviceTokenString)")
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("Device Token Not Found \(error)")
    }
}

extension AppDelegate: UNUserNotificationCenterDelegate {
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        print(JSON(userInfo))

     
    }
  func userNotificationCenter( _ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void
  ) {
    print(JSON(notification.request.content.userInfo))
  
    if #available(iOS 14.0, *) {
        completionHandler([[.banner, .sound]])
    } else {
        // Fallback on earlier versions
    }
  }


  func userNotificationCenter(
    _ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
    print(JSON(response.notification.request.content.userInfo))

    completionHandler()
  }
    func displayIncomingCall(uuid: UUID, handle: String, hasVideo: Bool = false, completion: ((NSError?) -> Void)?) {
        providerDelegate.reportIncomingCall(uuid: uuid, handle: handle, hasVideo: hasVideo) { Error in
            self.uid = uuid
        }

    }
   
}

extension AppDelegate: PKPushRegistryDelegate {
    func pushRegistry(_ registry: PKPushRegistry, didUpdate pushCredentials: PKPushCredentials, for type: PKPushType) {

        let token = pushCredentials.token.map { String(format: "%02.2hhx", $0) }.joined()
        if token != GFunction.shared.getStringValueForKey(UserDefaultsKeys.kVoipToken.rawValue){
            GFunction.shared.setStringValueWithKey(token, key: UserDefaultsKeys.kVoipToken.rawValue)
        }
        
        print("token: \(token)")
    }
    

    func pushRegistry(_ registry: PKPushRegistry, didReceiveIncomingPushWith payload: PKPushPayload, for type: PKPushType, completion: @escaping () -> Void) {
        print(JSON(payload.dictionaryPayload))
        
        if let status = payload.dictionaryPayload["status"] as? Int{
            let statusObj: [String: Any] = ["status": status]
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "status"), object: nil, userInfo: statusObj)
        }
        if let callTyp = payload.dictionaryPayload["callType"] as? Int{
            callType = callTyp
        }
        if let calId = payload.dictionaryPayload["callId"] as? Int{
            
            print("this is call id\(calId)")
            myCallId.callId = calId
            self.callId = calId
        }
        if let callerName = payload.dictionaryPayload["username"] as? String {
            if callType == 1{
                displayIncomingCall(uuid: UUID(), handle: callerName, hasVideo: false, completion: nil)
            }else{
                displayIncomingCall(uuid: UUID(), handle: callerName, hasVideo: true, completion: nil)
            }
        
        }
    }
    
}



