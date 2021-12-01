//
//  GFunction.swift
//  Ghaf
//
//  Created by Hyperlink on 01/05/19.
//  Copyright © 2019 Hyperlink. All rights reserved.
//

import UIKit
import AudioToolbox
import AVKit
import MessageUI
@_exported import SDWebImage

class GFunction: NSObject, MFMessageComposeViewControllerDelegate {
    
    static let shared   : GFunction = GFunction()
    let activityIndicator = UIActivityIndicatorView(style: .white)
    let viewBGLoder: UIView = UIView()
    let snackbar: TTGSnackbar = TTGSnackbar()
    let snackBarNetworkReachability : TTGSnackbar = TTGSnackbar()
    
    enum ConvertType {
        case LOCAL,UTC,NOCONVERSION
    }
    
    //MARK:- Custom Alert
    
    func showSnackBar(_ message : String, duration : TTGSnackbarDuration = .short ,isError : Bool = false, animation : TTGSnackbarAnimationType = .slideFromTopBackToTop) {
        snackbar.message = message
        snackbar.duration = duration
        // Change the content padding inset
        snackbar.contentInset = UIEdgeInsets.init(top: UIApplication.safeArea.top + 20, left: 8, bottom: 8, right: 8)
        
        // Change margin
        snackbar.leftMargin = 0
        snackbar.rightMargin = 0
        snackbar.topMargin = -UIApplication.safeArea.top
        
        // Change message text font and color
        snackbar.messageTextColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        snackbar.messageTextFont = UIFont.systemFont(ofSize: 14)
        
        // Change snackbar background color
        snackbar.backgroundColor = kTHEMECOLOR
        
        snackbar.onTapBlock = { snackbar in
            snackbar.dismiss()
        }
        
        snackbar.onSwipeBlock = { (snackbar, direction) in
            
            // Change the animation type to simulate being dismissed in that direction
            if direction == .right {
                snackbar.animationType = .slideFromLeftToRight
            } else if direction == .left {
                snackbar.animationType = .slideFromRightToLeft
            } else if direction == .up {
                snackbar.animationType = .slideFromTopBackToTop
            } else if direction == .down {
                snackbar.animationType = .slideFromTopBackToTop
            }
            
            snackbar.dismiss()
        }
        
        // snackbar.cornerRadius = 0.0
        // Change animation duration
        snackbar.animationDuration = 0.5
        
        // Animation type
        snackbar.animationType = animation
        snackbar.show()
    }
    
    func showNoNetworkSnackBar(_ message : String = "No Internet Connection") {
        
        snackBarNetworkReachability.message = message
        snackBarNetworkReachability.duration = .forever
        // Change the content padding inset
        snackBarNetworkReachability.contentInset = UIEdgeInsets.init(top: 0, left: 8, bottom: 0, right: 8)
        
        // Change margin
        snackBarNetworkReachability.leftMargin = 0
        snackBarNetworkReachability.rightMargin = 0
        snackBarNetworkReachability.topMargin = 20
        
        // Change message text font and color
        snackBarNetworkReachability.messageTextColor = UIColor.white
        snackBarNetworkReachability.messageTextAlign = .center
        snackBarNetworkReachability.messageTextFont = UIFont.systemFont(ofSize: 14)
        
        // Change snackbar background color
        snackBarNetworkReachability.backgroundColor = #colorLiteral(red: 0.6039215686, green: 0.6274509804, blue: 0.6980392157, alpha: 1).withAlphaComponent(0.9)
        
        //        snackBarNetworkReachability.cornerRadius = 0.0
        // Change animation duration
        snackBarNetworkReachability.animationDuration = 0.5
        
        // Animation type
        snackBarNetworkReachability.animationType = .topSlideFromRightToLeft
        snackBarNetworkReachability.show()
    }
    
    func removeNoNetworkSnackBar(){
        
        snackBarNetworkReachability.dismiss()
    }
    
    func showAlert(_ strTitle: String = kAppName, message: String , buttonType : AlertButtonType = .OnlyOk, completion: ((_ respon: Bool) -> Void)? = nil) {
        
        let alert     : UIAlertController   = UIAlertController(title: strTitle as String, message: message as String, preferredStyle: .alert)
        alert.message                       = message as String
        alert.title                         = strTitle as String
        
        let action_Yes                      = UIAlertAction(title: kYes, style: .default) { (UIAlertAction) in
            if let _ = completion { completion!(true)   }
        }
        let action_No                       = UIAlertAction(title: kNo, style: .default) { (UIAlertAction) in
            if let _ = completion { completion!(false)   }
        }
        let action_OK                       = UIAlertAction(title: kOk, style: .default) { (UIAlertAction) in
            if let _ = completion { completion!(true)   }
        }
        let action_Cancel                   = UIAlertAction(title: kCancel, style: .cancel) { (UIAlertAction) in
            if let _ = completion { completion!(false)   }
        }
        
        switch buttonType {
        case .OnlyOk:
            alert.addAction(action_OK)
            
        case .YesNo:
            alert.addAction(action_Yes)
            alert.addAction(action_No)
            
        case .OkCancel:
            alert.addAction(action_OK)
            alert.addAction(action_Cancel)
        }
        
        UIApplication.topViewController()?.present(alert, animated: true, completion: nil)
    }
    
    // MARK:- add &a remove navigation bottom shadow
    
    func addNavCustomBottomShadow(vc:UIViewController) {
        vc.navigationController?.navigationBar.layer.shadowColor = UIColor.black.cgColor
        vc.navigationController?.navigationBar.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        vc.navigationController?.navigationBar.layer.shadowRadius = 4.0
        vc.navigationController?.navigationBar.layer.shadowOpacity = 0.3
        vc.navigationController?.navigationBar.layer.masksToBounds = false
    }
    
    func RemoveNavCustomBottomShadow(vc:UIViewController) {
        vc.navigationController?.navigationBar.layer.shadowColor = UIColor.clear.cgColor
        vc.navigationController?.navigationBar.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        vc.navigationController?.navigationBar.layer.shadowRadius = 4.0
        vc.navigationController?.navigationBar.layer.shadowOpacity = 0.3
        vc.navigationController?.navigationBar.layer.masksToBounds = false
    }
    
    //MARK:- Get window
    
    func getWindow() -> UIWindow? {
        return UIApplication.shared.windows.first
    }
    
    
    //MARK:- Set Screens
    
    func manageRootController() {
        
        if UserDefaults.standard.value(forKey: UserDefaultsKeys.kIsLogin.rawValue) as? Bool == true {
            setHomeScreen()
            
        }else {
           setLoginScreen()
        }
    }
    
    func setHomeScreen() {

        let navigationController = UIStoryboard.kTabbarStoryboard.instantiateViewController(withIdentifier: "navTabbar") as! UITabBarController
        navigationController.selectedIndex = 0
        //let rootViewController : UITabBarController = UIStoryboard.kTabbarStoryboard.instantiateViewController(withIdentifier: kNAVHOME) as! UITabBarController
        
        
        let SlideMenu  = UIStoryboard.kTabbarStoryboard.instantiateViewController(withIdentifier: kNAVMENU) as! UINavigationController
        let sideMenuViewController = SlideMenuController(mainViewController: navigationController, leftMenuViewController: SlideMenu, rightMenuViewController: UIViewController())
        
        guard let window = GFunction.shared.getWindow() else { return }
        
        window.rootViewController = sideMenuViewController
        window.makeKeyAndVisible()
        
        UIView.transition(with: window,
                          duration: 0.3,
                          options: .transitionCrossDissolve,
                          animations: {
                            () -> Void in
                            
                            window.makeKeyAndVisible()
        },
                          completion: nil)

    }
    
    func setLoginScreen() {
        
        UserDefaults.standard.set(false, forKey: UserDefaultsKeys.kIsLogin.rawValue)
        UserDefaults.standard.synchronize()
        let rootViewController : UINavigationController = UIStoryboard.kLoginStoryboard.instantiateViewController(withIdentifier: kAUTHNAV) as! UINavigationController
        
        guard let window = GFunction.shared.getWindow() else { return }
        
        window.rootViewController = rootViewController
        window.makeKeyAndVisible()
    }
    
    func setLanguageScreen() {
        
        UserDefaults.standard.set(false, forKey: UserDefaultsKeys.kIsLogin.rawValue)
        UserDefaults.standard.synchronize()
        
        let rootViewController : UINavigationController = UIStoryboard.kLoginStoryboard.instantiateViewController(withIdentifier: kLANGNAV) as! UINavigationController
        
        guard let window = GFunction.shared.getWindow() else { return }
        
        window.rootViewController = rootViewController
        window.makeKeyAndVisible()
    }
    
    func userLogout(){
        UserModel.removeCurrentUser()
//        AppDelegate.shared.isFirstTimeAppSelected = true
//        self.setLoginScreen()

    }
    
    //MARK:- number formatter
    
    /* https://stackoverflow.com/questions/32364055/formatting-phone-number-in-swift/41668104 */
    
    func formattedNumber(number: String, maskStr: String) -> String {
        let cleanPhoneNumber = number.components(separatedBy: CharacterSet.decimalDigits.inverted).joined()
        let mask = maskStr
        
        var result = ""
        var index = cleanPhoneNumber.startIndex
        for ch in mask where index < cleanPhoneNumber.endIndex {
            if ch == "#" {
                result.append(cleanPhoneNumber[index])
                index = cleanPhoneNumber.index(after: index)
            } else {
                result.append(ch)
            }
        }
        return result
    }
    
    //MARK:- Add/Remove Loader
    
    func addLoader(_ message : String? = "Loading...") {
        removeLoader()
        
        self.viewBGLoder.frame = UIScreen.main.bounds
        self.viewBGLoder.backgroundColor = .clear
        self.viewBGLoder.tag = 1307966
        
        activityIndicator.center = UIApplication.shared.windows.first?.center ?? .zero
        activityIndicator.color = kTHEMECOLOR
        activityIndicator.transform = CGAffineTransform(scaleX: 2.0, y: 2.0)
        activityIndicator.hidesWhenStopped = true
        activityIndicator.startAnimating()
        
        self.viewBGLoder.addSubview(activityIndicator)
        UIApplication.shared.windows.first?.addSubview(viewBGLoder)
    }
    
    func removeLoader() {
        activityIndicator.stopAnimating()
        activityIndicator.removeFromSuperview()
        UIApplication.shared.windows.first?.viewWithTag(1307966)?.removeFromSuperview()
        self.viewBGLoder.removeFromSuperview()
    }
    
    //MARK:-  Create Thumbnail Of Video From Remote Url
    
    func createThumbnailOfVideoFromRemoteUrl(url: String, imgViewWidth: CGFloat, imgViewHeight: CGFloat) -> UIImage? {
        
        GFunction.shared.addLoader()
        let asset = AVAsset(url: URL(string: url)!)
        let assetImgGenerate = AVAssetImageGenerator(asset: asset)
        assetImgGenerate.appliesPreferredTrackTransform = true
        //Can set this to improve performance if target size is known before hand
        assetImgGenerate.maximumSize = CGSize(width: imgViewWidth, height: imgViewHeight)
        let time = CMTimeMakeWithSeconds(1.0, preferredTimescale: 600)
        do {
            let img = try assetImgGenerate.copyCGImage(at: time, actualTime: nil)
            let thumbnail = UIImage(cgImage: img)
            GFunction.shared.removeLoader()
            return thumbnail
        } catch {
            print(error.localizedDescription)
            GFunction.shared.removeLoader()
            return nil
        }
    }
    
    //MARK:- video Player For Remote Url
    func videoPlayerForRemoteUrl(videolink:String, view:UIViewController) {
        
        let videoURL = URL(fileURLWithPath: videolink)
        let player = AVPlayer(url: videoURL)
        let playerViewController = AVPlayerViewController()
        playerViewController.player = player
        playerViewController.showsPlaybackControls = true
        view.present(playerViewController, animated: true) {
            playerViewController.player!.play()
        }
    }
    
    func emtyUserdata(){
        userChosenData.iam = ""
        userChosenData.lookingfor = ""
        userChosenData.name = ""
        userChosenData.userImage = ""
        userChosenData.distance = ""
        userChosenData.professon = ""
        userChosenData.backgroundImage = ""
        userChosenData.selection = ""
        userChosenData.aboutText = ""
        userChosenData.prefarance = ""
        
    }
    

    
    //MARK:- Date Functions
    
    func getTodayDate(dateFormate:String) -> String {
        
        var todayDate = ""
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = dateFormate
        todayDate = formatter.string(from: date)
        return todayDate
    }
    
    func converDateInspecificformat(format:String,toFormat:String,date:Date) -> Date{
        
        let formater = DateFormatter()
        formater.dateFormat = format
        
        let dt = formater.string(from: date)
        formater.dateFormat = toFormat
        return formater.date(from: dt)!
        
    }
    
    func GetStringDateInAPIFormat(sourceDate : Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = DateTimeFormaterEnum.UTCFormat.rawValue
        let dateString = dateFormatter.string(from: sourceDate)
        return dateString
    }
    
    func GetStringTimeInAPIFormat(sourceDate : Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = DateTimeFormaterEnum.HHmmss.rawValue
        let dateString = dateFormatter.string(from: sourceDate)
        return dateString
    }
    
    func getDatefromString(_ date : String , dateFormate : String = "yyyy-MM-dd" , changeDateFormate : String = "MMM dd, YYYY" , _ timeZone : TimeZone = TimeZone(abbreviation: "UTC")!)-> String{
        
        if date != "" {
            
            let dateforamter = DateFormatter()
            if let data = Locale.preferredLanguages.first{
                dateforamter.locale = Locale.init(identifier: data)
            }
            dateforamter.timeZone = timeZone
            dateforamter.dateFormat = dateFormate
            if let data = Locale.preferredLanguages.first{
                dateforamter.locale = Locale.init(identifier: data)
            }
            
            guard let rideDate = dateforamter.date(from: date) else {
                return date
            }
            
            dateforamter.timeZone = TimeZone.current
            dateforamter.dateFormat = changeDateFormate
            
            let strDate = dateforamter.string(from: rideDate)
            
            return strDate
        }
        return date
    }
    
    func getUTCDatefromString(_ date : String , dateFormate : String = "yyyy-MM-dd" , changeDateFormate : String = "MMM dd, YYYY" , _ timeZone : TimeZone = TimeZone.current)-> String{
        
        if date != "" {
            
            let dateforamter = DateFormatter()
            dateforamter.timeZone = timeZone
            dateforamter.dateFormat = dateFormate
            
            if let data = Locale.preferredLanguages.first{
                dateforamter.locale = Locale.init(identifier: data)
            }
            
            guard let rideDate = dateforamter.date(from: date) else {
                return date
            }
            
            dateforamter.timeZone = TimeZone(abbreviation: "UTC")
            dateforamter.dateFormat = changeDateFormate
            
            let strDate = dateforamter.string(from: rideDate)
            
            return strDate
        }
        return date
    }
    
    func convertToLocal(sourceDate : NSDate)-> NSDate{
        
        let sourceTimeZone                                      = NSTimeZone(abbreviation: "UTC")
        let destinationTimeZone                                 = NSTimeZone.system
        
        //calc time difference
        let sourceGMTOffset         : NSInteger                 = (sourceTimeZone?.secondsFromGMT(for: sourceDate as Date))!
        let destinationGMTOffset    : NSInteger                 = destinationTimeZone.secondsFromGMT(for:sourceDate as Date)
        let interval                : TimeInterval              = TimeInterval(destinationGMTOffset-sourceGMTOffset)
        
        //set currunt date
        let date: NSDate                                        = NSDate(timeInterval: interval, since: sourceDate as Date)
        return date
    }
    
    func convertToUTC(sourceDate : NSDate)-> NSDate{
        
        let sourceTimeZone                                      = NSTimeZone.system
        let destinationTimeZone                                 = NSTimeZone(abbreviation: "UTC")
        
        //calc time difference
        let sourceGMTOffset         : NSInteger                 = (sourceTimeZone.secondsFromGMT(for:sourceDate as Date))
        let destinationGMTOffset    : NSInteger                 = destinationTimeZone!.secondsFromGMT(for: sourceDate as Date)
        let interval                : TimeInterval              = TimeInterval(destinationGMTOffset-sourceGMTOffset)
        
        //set currunt date
        let date: NSDate                                        = NSDate(timeInterval: interval, since: sourceDate as Date)
        return date
    }
    
    func convertDateFormat(dt: String, inputFormat: String, outputFormat: String, status: ConvertType) -> String {
        if dt != "" {
            let dateFormatter: DateFormatter = DateFormatter()
            dateFormatter.dateFormat = inputFormat
            dateFormatter.locale = Locale(identifier:"en_US_POSIX")
            
            var date : NSDate!
            
            if status == .LOCAL {
                date = self.convertToLocal(sourceDate: dateFormatter.date(from: dt)! as NSDate)
            } else if status == .UTC {
                date = self.convertToUTC(sourceDate: dateFormatter.date(from: dt)! as NSDate)
            } else {
                date = dateFormatter.date(from: dt)! as NSDate
            }
            
            dateFormatter.dateFormat = outputFormat
            return dateFormatter.string(from: date as Date)
        } else {
            return ""
        }
    }
    
    //MARK:- Components
    
    func setBtnRoundCorner(btn: UIButton, radius: CGFloat) {
        btn.layoutIfNeeded()
        btn.layer.cornerRadius = radius
        btn.layer.masksToBounds = true        
    }
    
    func setLabelRoundCorner(lbl: UILabel, radius: CGFloat) {
        
        lbl.layer.cornerRadius = radius
        lbl.layer.masksToBounds = true
    }
    
    func setRoundAndShadow(roundView: UIView, shadowView: UIView,corners: UIRectCorner, radius: CGFloat, shadow: UIColor) {
        
        shadowView.applyViewShadow(shadowOffset: CGSize(width: 0.0, height: 3.0), shadowColor: shadow, shadowOpacity: 0.5)
        shadowView.frame = roundView.frame
        roundView.roundCorners(corners: corners, radius: radius)
    }
    
    func isBackspace(_ inputString : String) -> Bool {
        let  char = inputString.cString(using: String.Encoding.utf8)!
        let isBackSpace = strcmp(char, "\\b")
        if (isBackSpace == -92) {
            return true
        } else {
            return false
        }
    }
    
    
    //MARK: - Time converter
    func timeConversion24(time12: String) -> String {
        let dateAsString = time12
        let df = DateFormatter()
        df.dateFormat = DateTimeFormaterEnum.hhMMA.rawValue
        
        let date = df.date(from: dateAsString)
        df.dateFormat = DateTimeFormaterEnum.HHmmss.rawValue
        
        let time24 = df.string(from: date!)
        print(time24)
        return time24
    }
    
    func timeConversion12(time24: String) -> String {
        let dateAsString = time24
        let df = DateFormatter()
        df.dateFormat = DateTimeFormaterEnum.HHmmss.rawValue
        
        let date = df.date(from: dateAsString)
        df.dateFormat = DateTimeFormaterEnum.hhMMA.rawValue
        
        let time12 = df.string(from: date!)
        print(time12)
        return time12
    }
    
    //MARK: -  Call
    
    func makeCall(_ strNumber : String = "1234567890") {
        
        var phoneNumber : String = "telprompt://\(strNumber)"
        phoneNumber = self.makeValidNumber(phoneNumber)
        
        if UIApplication.shared.canOpenURL(URL(string: phoneNumber)!) {
            UIApplication.shared.open(URL(string: phoneNumber)!, options: [:]) { (sucess) in
                
            }
        } else {
            
            GFunction.shared.showSnackBar("Carrier service not available")
        }
    }
    
    func makeValidNumber(_ phoneNumber : String) -> String {
        
        var number : String = phoneNumber
        number = number.replacingOccurrences(of: "+", with: "")
        number = number.replacingOccurrences(of: " ", with: "")
        number = number.trimmingCharacters(in: .whitespacesAndNewlines)
        
        return number
    }
    
    func sendMessage(_ strNumber : String = "1234567890") {
        
        var phoneNumber : String = "\(strNumber)"
        phoneNumber = self.makeValidNumber(phoneNumber)
        
        if (MFMessageComposeViewController.canSendText()) {
            let controller = MFMessageComposeViewController()
            controller.body = ""
            controller.recipients = [phoneNumber]
            controller.messageComposeDelegate = self
            AppDelegate.shared.window?.rootViewController?.present(controller, animated: true, completion: nil)
        }
        else {
            GFunction.shared.showSnackBar("Carrier service not available")
        }
    }
    
    //MARK:- Image load from URL
    
       func ImageLoadFromURL(_ imageView : UIImageView!, _ strUrl : String, withPlaceHolder image : UIImage? = #imageLiteral(resourceName: "default_store")) {
        
        if let url = URL(string: strUrl) {
            
            imageView.sd_imageIndicator = SDWebImageActivityIndicator.gray
            
            imageView.sd_setImage(with: url) { (image, error, cache, urls) in
                if (error != nil) {
                    // Failed
                    imageView.image = #imageLiteral(resourceName: "default_store")
                    debugPrint(url)
                } else {
                    // Successfull
                    imageView.image = image
                    imageView.contentMode = .scaleAspectFill
                }
            }
        }
    }
    
    //MARK:- MFMessageComposeViewController Delegate
    
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        controller.dismiss(animated: true, completion: nil)
    }
    
    //MARK: - Share
    
    func openShareSheet(this:UIViewController,msg:String)
    {
        
        let textToShare = [ msg ] as [Any]
        
        let activityViewController = UIActivityViewController(activityItems: textToShare, applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = this.view // so that iPads won't crash
        
        // exclude some activity types from the list (optional)
        activityViewController.excludedActivityTypes = [UIActivity.ActivityType.airDrop , UIActivity.ActivityType.addToReadingList , UIActivity.ActivityType.assignToContact,UIActivity.ActivityType.copyToPasteboard,UIActivity.ActivityType.print,UIActivity.ActivityType.saveToCameraRoll]
        
        // present the view controller
        DispatchQueue.main.async {
            this.present(activityViewController, animated: true, completion: nil)
        }
    }
    
    //------------------------------------------------------
    
//    func getCurrentCountryCode() -> (String, JSON){
//
//        var countryCode : String = ""
//        if let countryCode1 = (Locale.current as NSLocale).object(forKey: .countryCode) as? String {
//            print(countryCode1)
//            countryCode = countryCode1
//        }
//
//        let bundle = Bundle(for: LocalePickerViewController.self)
//        let path = "Countries.bundle/Data/CountryCodes"
//
//        guard let jsonPath = bundle.path(forResource: path, ofType: "json"),
//            let jsonData = try? Data(contentsOf: URL(fileURLWithPath: jsonPath)) else {
//                let _: (title: String?, message: String?) = (title: "ContryCodes Error", message: "No ContryCodes Bundle Access")
//                return ("" , JSON())
//        }
//        var result: [JSON] = []
//        if let jsonObjects = (try? JSONSerialization.jsonObject(with: jsonData, options: JSONSerialization.ReadingOptions.allowFragments)) as? Array<Any> {
//
//            for jsonObject in jsonObjects {
//                guard let countryObj = jsonObject as? Dictionary<String, Any> else { continue }
//                result.append(JSON(countryObj))
//            }
//        }
//
//        let filtered = result.filter{$0["code"].stringValue.contains(countryCode.uppercased())}
//        if let firstData = filtered.first{
//            return (firstData["dial_code"].stringValue , firstData)
//        }
//        return ("", JSON())
//    }
    
    //MARK:- Basic Setup Table
    
    func basicTableSetUp(tbl:UITableView, vc:UIViewController, height:CGFloat) {
        
        tbl.estimatedRowHeight = height
        tbl.rowHeight = UITableView.automaticDimension
        tbl.delegate = vc as? UITableViewDelegate
        tbl.dataSource = vc as? UITableViewDataSource
        tbl.reloadData()
    }
    
    //MARK:- Update Cart
    
//    func setCartCount(cartCount: Int){
//        UserModel.currentUser!.totalCartItem = cartCount
//        UserDefaults.standard.set(cartCount, forKey: UserDefaultsKeys.kCartCount.rawValue)
//    }
    
    //MARK:- Basic Animations
    
    func springAnimation(_ sender: UIButton, scale: CGFloat, duraion: CGFloat) {
        
        sender.transform = CGAffineTransform(scaleX: scale, y: scale)
        
        UIView.animate(withDuration: 1.5,
                       delay: 0,
                       usingSpringWithDamping: CGFloat(0.20),
                       initialSpringVelocity: CGFloat(6.0),
                       options: UIView.AnimationOptions.allowUserInteraction,
                       animations: {
                        sender.transform = CGAffineTransform.identity
        },
                       completion: { Void in() })
    }
    
    //MARK: - User Defaults (Set/Get)
     func setStringValueWithKey(_ data: String, key: String) {
        
        let appData = UserDefaults.standard
        appData.set(data, forKey: key)
        appData.synchronize()
    }
    
     func setBoolValueWithKey(_ data: Bool, key: String) {
        
        let appData = UserDefaults.standard
        appData.set(data, forKey: key)
        appData.synchronize()
    }
    
     func setIntValueWithKey(_ data: Int, key: String) {
        
        let appData = UserDefaults.standard
        appData.set(data, forKey: key)
        appData.synchronize()
    }
    
     func getStringValueForKey(_ key: String) -> String {
        
        let appData = UserDefaults.standard
        if let value = appData.object(forKey: key) as? String {
            return value
        }
        return ""
    }
    
     func getBoolValueForKey(_ key: String) -> Bool {
        
        let appData = UserDefaults.standard
        if let value = appData.object(forKey: key) as? Bool {
            return value
        }
        return false
    }
    
     func getIntValueForKey(_ key: String) -> Int {
        
        let appData = UserDefaults.standard
        if let value = appData.object(forKey: key) as? Int {
            return value
        }
        return -1
    }
    
     func removeValue(_ key: String) {
        
        let appData = UserDefaults.standard
        appData.removeObject(forKey: key)
        appData.synchronize()
    }
    
    //Save data into userdefaults
    func saveDataIntoUserDefault (object : AnyObject, key : String) {
        let userDefaults = UserDefaults.standard
        userDefaults.set(object, forKey:key)
        UserDefaults.standard.synchronize()
    }
    
    //remove data from userdefaults
    func removeUserDefaults (key : String) {
        let userDefaults = UserDefaults.standard
        userDefaults.removeObject(forKey: key)
        UserDefaults.standard.synchronize()
    }
    
    func addVibrate() {
        AudioServicesPlayAlertSound(kSystemSoundID_Vibrate)
        self.addSystemSound()
    }
    
    func addSystemSound() {
        //1008 , 1013 , 1022 , 1054 , 1150 , 1300 , 1303 , 1309 , 1313 , 1322
        //photoShutter :- 1108
        //Default push:- 1002
        let systemSoundID: SystemSoundID = 1309//1054//1000//1016
        // to play sound
        AudioServicesPlaySystemSound (systemSoundID)
    }
    
    //------------------------------------------------------
    //MARK:- Login alert
    
//    func askForLogin(msg : String, view:UIViewController) {
//
//        let alert = UIAlertController(title: kAppName.localized, message: msg.localized, preferredStyle: .alert)
//
//        alert.addAction(UIAlertAction(title: "LOGIN".localized, style: .default, handler: { action in
//            GFunction.shared.userLogout()
//        }))
//
//        alert.addAction(UIAlertAction(title: "NO".localized, style: .default, handler: { action in
//
//        }))
//
//        view.present(alert, animated: true, completion: nil)
//    }
    
    //------------------------------------------------------
    
    //MARK:- Int to two decomal float
    
    func IntToTwoDecimalFloat(intValue:Int) -> String {
        return String(format: "%.2f", CGFloat(intValue))
    }
    
    //MARK:- Attributed Text
    
    func changeAttributedStringLabel(sender : UILabel, string : String, wholeString : String , color : UIColor , wcolor : UIColor,font : CustomFont = .FontRegular,size : CGFloat = kFontSize10,sizeOfWString : CGFloat = kFontSize9, FontOfWString : CustomFont, setUnderLine:Bool) {
        
        sender.text = wholeString
        sender.textColor = wcolor
        sender.font = UIFont.applyFont(fontType: FontOfWString, fontSize: sizeOfWString, true)
        let strNumber: NSString = wholeString as NSString
        let range = (strNumber).range(of: string)
        let attribute = NSMutableAttributedString.init(string: strNumber as String)
        attribute.addAttribute(NSAttributedString.Key.foregroundColor, value: color , range: range)
        attribute.addAttribute(NSAttributedString.Key.font, value: UIFont.applyFont(fontType: font, fontSize: size, true), range: range)
        
        if setUnderLine {
            attribute.addAttribute(NSAttributedString.Key.underlineColor, value: color, range: range)
            attribute.addAttribute(NSAttributedString.Key.underlineStyle, value:NSUnderlineStyle.single.rawValue, range: range)
        }
        
        sender.attributedText = attribute
    }
    
    func changeAttributedStringLabel(sender : UILabel, string : String, string2 : String = "", wholeString : String , color : UIColor, wcolor : UIColor, font : CustomFont = .FontRegular,size : CGFloat = kFontSize10, sizeOfWString : CGFloat = kFontSize10 , FontOfWString : CustomFont, isUnderline : Bool = false){
        sender.text = wholeString
        sender.textColor = wcolor
        sender.font = UIFont.applyFont(fontType: FontOfWString, fontSize: sizeOfWString)
        let strNumber: NSString = wholeString as NSString
        let range2 = (strNumber).range(of: string2)
        let range = (strNumber).range(of: string)
        let paragraphStyle = NSMutableParagraphStyle()
        let attributedString = NSMutableAttributedString(string: wholeString)
        // *** set LineSpacing property in points ***
        paragraphStyle.lineSpacing = 6.0 // Whatever line spacing you want in points
        paragraphStyle.alignment = NSTextAlignment.center
        let attribute = NSMutableAttributedString.init(string: strNumber as String)
        
        attribute.addAttribute(NSAttributedString.Key.foregroundColor, value: color , range: range)
        if isUnderline {
            attribute.addAttributes([NSAttributedString.Key.underlineStyle : NSUnderlineStyle.single.rawValue], range: range2)
            attribute.addAttributes([NSAttributedString.Key.underlineStyle : NSUnderlineStyle.single.rawValue], range: range)
        }
        attribute.addAttribute(NSAttributedString.Key.font, value: UIFont.applyFont(fontType: font, fontSize: size), range: range)
        attribute.addAttribute(NSAttributedString.Key.foregroundColor, value: color , range: range2)
        attribute.addAttribute(NSAttributedString.Key.font, value: UIFont.applyFont(fontType: font, fontSize: size), range: range)
        
        attributedString.addAttribute(NSAttributedString.Key.paragraphStyle, value:paragraphStyle, range:NSMakeRange(0, attributedString.length))
        attribute.addAttribute(NSAttributedString.Key.underlineStyle, value:NSUnderlineStyle.single.rawValue, range: range)
        
        sender.attributedText = attribute
    }
    
    //For getting attributed text from string
    func getAttributedText (_ text : String,  _ defaultDic : [NSAttributedString.Key : Any] = [:] , attributeDic : [NSAttributedString.Key : Any], range : NSRange) -> NSMutableAttributedString {
        
        let attributeText : NSMutableAttributedString = NSMutableAttributedString(string: text)
        
        if defaultDic.count > 0 {
            attributeText.addAttributes(defaultDic, range: (text as NSString).range(of: text))
        }
        attributeText.addAttributes(attributeDic, range: range)
        
        return attributeText
    }
    
    func getAttributedTextWithMultiRange(_ text : String,  _ defaultDic : [NSAttributedString.Key : Any] = [:] , attributeDic : [NSAttributedString.Key : Any], range : [NSRange]) -> NSMutableAttributedString {
        
        let attributeText : NSMutableAttributedString = NSMutableAttributedString(string: text)
        if defaultDic.count > 0 {
            attributeText.addAttributes(defaultDic, range: (text as NSString).range(of: text))
        }
        for item in range {
            attributeText.addAttributes(attributeDic, range: item)
        }
        return attributeText
    }
    
    //Find the range of string from string
    func findRange(_ text : String , searchText : String) -> [NSRange]  {
        let attrStr = NSMutableAttributedString(string: text)
        let inputLength = attrStr.string.count
        let searchString = searchText
        let searchLength = searchString.count
        var range = NSRange(location: 0, length: attrStr.length)
        
        var arrRange : [NSRange] = []
        
        while (range.location != NSNotFound) {
            range = (attrStr.string as NSString).range(of: searchString, options: [], range: range)
            if (range.location != NSNotFound) {
                range = NSRange(location: range.location  , length: searchLength)
                arrRange.append(range)
                range = NSRange(location: range.location + range.length  , length: inputLength - (range.location + range.length))
            }
        }
        
        return arrRange
    }
    
    
    func alertWithAction(view: UIViewController, msg: String,title: String, actionButtonClosure: @escaping () -> Void){
        let alertController = UIAlertController(title: "", message: msg, preferredStyle: .actionSheet)
        alertController.view.tintColor = UIColor.ColorTheme
            let action1 = UIAlertAction(title: title, style: .default) { (action) in
                actionButtonClosure()
            }
        
            let action2 = UIAlertAction(title: "Cancel", style: .cancel) { (action) in
                print("Cancel is pressed......")
            }

            alertController.addAction(action1)
            alertController.addAction(action2)
            view.present(alertController, animated: true, completion: nil)

        }

}
