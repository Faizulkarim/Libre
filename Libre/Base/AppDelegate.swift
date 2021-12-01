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
@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    var isFirstTimeAppSelected = true
    static let shared = UIApplication.shared.delegate as! AppDelegate
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        setup()

        SendBirdCall.configure(appId: "20F9287C-FCC4-4BEB-AC0A-DC2E33ABE40C")
        GMSServices.provideAPIKey(AppCredential.googlePlaceID.rawValue)
        GMSPlacesClient.provideAPIKey(AppCredential.googlePlaceID.rawValue)
       // GFunction.shared.setHomeScreen()
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
            GlobalAPI.shared.APICallUpdateDeviceToken()
        }
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
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

