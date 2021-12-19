//
//  LocalViewController.swift
//  Libre
//
//  Created by piash sarker on 29/7/21.
//

import UIKit
import GoogleMaps

class LocalViewController: UIViewController,GMSMapViewDelegate {
    @IBOutlet weak var myView: GMSMapView!
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var feetView: UIView!
    @IBOutlet weak var searchView: UIView!
    @IBOutlet weak var minus: UIButton!
    @IBOutlet weak var pluse: UIButton!
    @IBOutlet weak var localUserViewOne: UIView!
    @IBOutlet weak var localUserViewTwo: UIView!
    @IBOutlet weak var localUserViewThree: UIView!
    @IBOutlet weak var LocalUserViewFour: UIView!
    @IBOutlet weak var locauserNameOne: UILabel!
    @IBOutlet weak var localuserNameTwo: UILabel!
    @IBOutlet weak var localuserNameThree: UILabel!
    @IBOutlet weak var localuserNameFour: UILabel!
    @IBOutlet weak var profileImageOne: RoundImage!
    @IBOutlet weak var profileImageTwo: RoundImage!
    @IBOutlet weak var profileImageThree: RoundImage!
    @IBOutlet weak var profileImageFour: RoundImage!

    //------------------------------------------------------
    //MARK:- Class variable
    var isZoomFirstTime = true
    var zoomCount = 11
    var nearbyPeople =  [NearbyPeopleModel]()
    let SavedDeviceToken = GFunction.shared.getStringValueForKey(UserDefaultsKeys.kDeviceToken.rawValue)
    
    
    //------------------------------------------------------
    //MARK:- Memory Management Method
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    deinit {
        print("💥💥💥 LocalViewController Deinit💥💥💥")
    }
    
    //------------------------------------------------------
    //MARK:- Custom Method
    
    
    func setupView(){
        self.addActionForNearUser()
        self.initGoogleMap()
        self.backView.roundCorners(corners: [.topLeft, .topRight], radius: 20)
        self.minus.applyViewShadowWithCornerRadius(shadowOffset: nil, shadowColor: UIColor.gray, shadowOpacity: 0.5, cornerRadius: 5, shadowRadius: 5)
        self.pluse.applyViewShadowWithCornerRadius(shadowOffset: nil, shadowColor: UIColor.gray, shadowOpacity: 0.5, cornerRadius: 5, shadowRadius: 5)
        self.searchView.applyViewShadowWithCornerRadius(shadowOffset: nil, shadowColor: UIColor.gray, shadowOpacity: 0.5, cornerRadius: 5, shadowRadius: 5)
        self.feetView.applyViewShadowWithCornerRadius(shadowOffset: nil, shadowColor: UIColor.gray, shadowOpacity: 0.5, cornerRadius: 5, shadowRadius: 5)

    }
    func addActionForNearUser(){
        self.localUserViewOne.handleTapToAction {
            self.pushToOtherUserProfile(userId: self.nearbyPeople[0].userId.description)
        }
        self.localUserViewTwo.handleTapToAction {
            self.pushToOtherUserProfile(userId: self.nearbyPeople[1].userId.description)
        }
        self.localUserViewThree.handleTapToAction {
            self.pushToOtherUserProfile(userId: self.nearbyPeople[2].userId.description)
        }
        self.LocalUserViewFour.handleTapToAction {
            self.pushToOtherUserProfile(userId: self.nearbyPeople[3].userId.description)
        }
    }
    
    func initGoogleMap(){
        self.myView.isMyLocationEnabled = true
        self.myView.delegate = self
        NotificationCenter.default.addObserver(self, selector: #selector(DistanceViewController.updateLocation), name: NSNotification.Name(rawValue:"LocationChange"), object: nil)
        
        
    }
    
    @objc func updateLocation(){
        
        if isZoomFirstTime == true {
            let location = GMSCameraPosition.camera(withLatitude: LocationManager.shared.getUserLocation().latitude, longitude: LocationManager.shared.getUserLocation().longitude, zoom: Float(17))
            myView.animate(to: location)
            
            GlobalAPI.shared.APICallUpdateDeviceToken()
            isZoomFirstTime = false
            
        }
    }
    
    func pushToOtherUserProfile(userId : String){
        let vc = OtheruserProfileViewController.instantiate(fromAppStoryboard: .kTabbarStoryboard)
        vc.userId = userId
        self.navigationController?.pushViewController(vc, animated: true)
    }
    func pushToAudioController(){
        let vc = OngoingCallViewController.instantiate(fromAppStoryboard: .kTabbarStoryboard)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    func pushToVideoController(){
        let vc = OngoinVideoController.instantiate(fromAppStoryboard: .kTabbarStoryboard)
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
    func ChooseCalltypeViewController(){
        switch AppDelegate.shared.callType {
        case 0:
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                self.APICallGetNearbyUserList(distance: String(UserModel.currentUser!.distance))
            }

        case 1:
            AppDelegate.shared.callType = 0
            pushToAudioController()
        case 2:
            AppDelegate.shared.callType = 0
            pushToVideoController()
        default:
            break
        }
    }
    
    
    
    
    
    //------------------------------------------------------
    //MARK:- Action method
    @IBAction func zoomout(_ sender: Any) {
        if zoomCount < 16{
            zoomCount += 1
            myView.animate(toZoom: Float(zoomCount))
            
        }
    }
    
    @IBAction func zoomIn(_ sender: Any) {
        if zoomCount > 10{
            zoomCount -= 1
            myView.animate(toZoom: Float(zoomCount))
        }
    }
    
    
    func shwoNearbyPeople(){
        guard !nearbyPeople.isEmpty else {return}
        for i in 0...nearbyPeople.count-1 {
            
            let imageView = UIImageView(image: UIImage(named: "Logo"))
            imageView.frame.size = CGSize(width: 50, height: 50)
            imageView.setRound()
            imageView.sd_setImage(with: URL(string: nearbyPeople[i].profileImage), placeholderImage: UIImage(named: "Logo"))
            let location = CLLocationCoordinate2D(latitude:Double(nearbyPeople[i].latitude) ?? 0.0, longitude:Double(nearbyPeople[i].longitude) ?? 0.0)
            print("location1: \(location)")
            let marker = GMSMarker()
            marker.position = location
            //  marker.snippet = data.name
            marker.map = myView
            marker.iconView = imageView
            
            switch i {
            case 0:
                self.locauserNameOne.text = nearbyPeople[0].name
                self.profileImageOne.sd_setImage(with: URL(string: nearbyPeople[0].profileImage), placeholderImage: UIImage(named: "Logo"))
            case 1:
                self.localuserNameTwo.text = nearbyPeople[1].name
                self.profileImageTwo.sd_setImage(with: URL(string: nearbyPeople[1].profileImage), placeholderImage: UIImage(named: "Logo"))
            case 2:
                self.localuserNameThree.text = nearbyPeople[2].name
                self.profileImageThree.sd_setImage(with: URL(string: nearbyPeople[2].profileImage), placeholderImage: UIImage(named: "Logo"))
            case 3:
                self.localuserNameFour.text = nearbyPeople[3].name
                self.profileImageFour.sd_setImage(with: URL(string: nearbyPeople[3].profileImage), placeholderImage: UIImage(named: "Logo"))
            default: break
                
            }
            
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
        
        self.navigationController?.navigationBar.isHidden = false
        self.navigationController?.navigationBar.setGradientBackground(colors: [UIColor.colorFromHex(hex: 0x4D4347), UIColor.colorFromHex(hex: 0x5D4147)])
        self.showTabBar()
        //  shwoNearbyPeople()
        ChooseCalltypeViewController()
        
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    
    
    
}

extension LocalViewController {
    private func APICallGetNearbyUserList(distance : String) {
        
        let params : [String : Any] = [
            "userId": UserModel.currentUser?.userId! as Any,
            "lat" : LocationManager.shared.location.latitude,
            "lng" : LocationManager.shared.location.longitude,
            "distance" : distance
            
        ]
        print(params)
        
        ApiManager.shared.makeRequestWithModel(method: .user(.peopleNerarby), modelType: ModelList<NearbyPeopleModel>.self, methodType: .post, responseModelType: .array, parameter: params)  { (result) in
            switch result {
            case .success(let apiData):
                print(result)
                
                switch apiData.apiCode {
                case .success:
                    print(apiData)
                    
                    self.nearbyPeople = apiData.data.result
                    DispatchQueue.main.async {
                        self.shwoNearbyPeople()
                    }
                    
                    print("This is count\(self.nearbyPeople.count)")
                    
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
