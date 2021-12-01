//
//  DistanceViewController.swift
//  Libre
//
//  Created by piash sarker on 28/7/21.
//

import UIKit
import GoogleMaps

class DistanceViewController: UIViewController, GMSMapViewDelegate {
    @IBOutlet weak var myView: GMSMapView!
    @IBOutlet weak var distanceView: UIView!
    @IBOutlet weak var minus: UIButton!
    @IBOutlet weak var pluse: UIButton!
    @IBOutlet weak var distance: labelSpecing!
    
    //------------------------------------------------------
    //MARK:- Class variable
    
    
    var zoomCount = 11
    var isZoomFirstTime = true
    var currentDistance = 30
    
    
    
    //------------------------------------------------------
    //MARK:- Memory Management Method
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    deinit {
        print("💥💥💥 DistanceViewController Deinit💥💥💥")
    }
    
    //------------------------------------------------------
    //MARK:- Custom Method
    
    
    func setupView(){
        initGoogleMap()
        minus.applyViewShadowWithCornerRadius(shadowOffset: nil, shadowColor: UIColor.gray, shadowOpacity: 0.5, cornerRadius: 5, shadowRadius: 5)
        pluse.applyViewShadowWithCornerRadius(shadowOffset: nil, shadowColor: UIColor.gray, shadowOpacity: 0.5, cornerRadius: 5, shadowRadius: 5)
        distanceView.applyViewShadowWithCornerRadius(shadowOffset: nil, shadowColor: UIColor.gray, shadowOpacity: 0.5, cornerRadius: 5, shadowRadius: 5)
    }
    
    func initGoogleMap(){
        self.myView.isMyLocationEnabled = true
        self.myView.delegate = self
        NotificationCenter.default.addObserver(self, selector: #selector(DistanceViewController.updateLocation), name: NSNotification.Name(rawValue:"LocationChange"), object: nil)
  
        
    }
    
    @objc func updateLocation(){
        print("location change")
        
        if isZoomFirstTime == true {
            let location = GMSCameraPosition.camera(withLatitude: LocationManager.shared.getUserLocation().latitude, longitude: LocationManager.shared.getUserLocation().longitude, zoom: Float(zoomCount))
          myView.animate(to: location)
            isZoomFirstTime = false
        
        }
    }
    
    func pushToproffesionViewController(){
        let vc = ProfessonViewController.instantiate(fromAppStoryboard: .kLoginStoryboard)
      
        self.navigationController?.pushViewController(vc, animated: true)
    }
    

    

    
    //------------------------------------------------------
    //MARK:- Action
    @IBAction func zoomout(_ sender: Any) {
        if zoomCount < 13{
        zoomCount += 1
        myView.animate(toZoom: Float(zoomCount))
            self.currentDistance -= 10
        self.distance.text = "Within \(currentDistance)mi"
        }
    }
    
    @IBAction func zoomIn(_ sender: Any) {
        if zoomCount > 10{
        zoomCount -= 1
        myView.animate(toZoom: Float(zoomCount))
        self.currentDistance += 10
        self.distance.text = "Within \(currentDistance)mi"
        }
    }
    
    @IBAction func goToprofessionView(_ sender: Any) {
        userChosenData.distance = String(currentDistance)
        pushToproffesionViewController()
    }
    
    
    
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

    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }


}
