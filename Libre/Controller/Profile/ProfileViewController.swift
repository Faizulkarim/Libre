//
//  OtheruserProfileViewController.swift
//  Libre
//
//  Created by piash sarker on 31/7/21.
//

import UIKit
import SwiftyJSON

class userprofilePhotosCell : UICollectionViewCell {
    @IBOutlet weak var otheUserImage: UIImageView!
    
    override class func awakeFromNib() {
        
    }
}

class ProfileViewController: UIViewController,UIScrollViewDelegate {
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var aboutTextBack: UIView!
    @IBOutlet weak var userPhotosCollectionView: UICollectionView!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var Name: UILabel!
    @IBOutlet weak var profession: UILabel!
    @IBOutlet weak var prefarence: UILabel!
    @IBOutlet weak var about: labelSpecing!
    @IBOutlet weak var otherBackground: UIImageView!
    @IBOutlet weak var backgroundImage: UIImageView!
    
    //------------------------------------------------------
    //MARK:- Class variable
    var Images : [JSON] = []
    
    
    //MARK:- Memory Management Method
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    deinit {
        print("💥💥💥 ProfileViewController Deinit💥💥💥")
    }
    
    //------------------------------------------------------
    //MARK:- Custom Method
    
    
    func setupView(){
        self.aboutTextBack.addBlurEffect()
        self.scrollView.contentInset = UIEdgeInsets(top: 270, left: 0, bottom: 0, right: 0)
        self.scrollView.delegate = self
        self.userPhotosCollectionView.delegate = self

         
    }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        let y = 270 - (scrollView.contentOffset.y + 270)
        let h = max(50, y)
        let react = CGRect(x: 0, y: 0, width: view.bounds.width, height: h)
        topView.frame = react

        
        if y < 80 {
            print("les thay \(y)")

        }else {

          
            
            print(y)
          
        }
    }
    
    func pushToEditVc(){
        let vc = EditProfileViewController.instantiate(fromAppStoryboard: .kTabbarStoryboard)
      
        self.navigationController?.pushViewController(vc, animated: true)
    }
    

    
    
    //------------------------------------------------------
    //MARK:- Action method
    @IBAction func Edit(_ sender: Any) {
        self.pushToEditVc()
        
    }
    
    
    
    //------------------------------------------------------
    //MARK:- Life Cycle Method

    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.setGradientBackground(colors: [UIColor.colorFromHex(hex: 0x2F8DBF), UIColor.colorFromHex(hex: 0x2968B1)])
        self.showTabBar()
        setupData()
        self.APICallGetProfile()
    }
    
    func setupData(){
        if UserModel.currentUser != nil{

            self.profession.text = UserModel.currentUser?.professon.capitalized
            self.about.text = UserModel.currentUser?.aboutYou
            self.prefarence.text = UserModel.currentUser?.prefarance
            self.Name.text = UserModel.currentUser?.name.capitalized
            if let url = URL(string: (UserModel.currentUser?.profileImage)!){
                print(url)
                self.profileImage.setImageWithDownload(url)
               
                
            }
            if let urlBack = URL(string: (UserModel.currentUser?.backgrounImage)!){
   
                self.otherBackground.setImageWithDownload(urlBack)
                
                self.backgroundImage.setImageWithDownload(urlBack)
            }
//            self.prefarence.text = UserModel.currentUser?.
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }


}

extension ProfileViewController : UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return Images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? userprofilePhotosCell
        if let url = URL(string: Images[indexPath.row].rawValue as! String){
            cell?.otheUserImage.setImageWithDownload(url)
            cell?.otheUserImage.tapToZoom()
        }
        
        return cell!
    }
    

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        
    }
  
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {


           let flowLayout = collectionViewLayout as! UICollectionViewFlowLayout

           let numberofItem: CGFloat = 3

           let collectionViewWidth = self.userPhotosCollectionView.bounds.width

           let extraSpace = (numberofItem - 1) * flowLayout.minimumInteritemSpacing

           let inset = flowLayout.sectionInset.right + flowLayout.sectionInset.left

           let width = Int((collectionViewWidth - extraSpace - inset) / numberofItem)

           print(width)

           return CGSize(width: width, height: width)
       }
    
}

extension ProfileViewController {
    private func APICallGetProfile() {
        
        let params : [String : Any] = [
            "userId": UserModel.currentUser?.userId! as Any,

        ]
        print(params)
        
        ApiManager.shared.makeRequestWithModel(method: .user(.userProfile), modelType: UserModel.self, parameter: params, withLoader: false)  { (result) in
            switch result {
            case .success(let apiData):
                print(result)
                switch apiData.apiCode {
                case .success:
                    print(apiData)
                    self.APICallGetmyImage()
                    UserModel.currentUser = apiData.data
                default:
                    GFunction.shared.showSnackBar(apiData.message)
                }
                
            case .failure(let failedMsg):
                print(failedMsg)
                break
            }
        }
    }
    private func APICallGetmyImage() {
        
        let params : [String : Any] = [
            "userId": UserModel.currentUser?.userId! as Any,

        ]
        print(params)
        
        ApiManager.shared.makeRequest(method:.user(.getuserImages), methodType: .post, parameter: params, withErrorAlert: true, withLoader: false, withdebugLog: true) { (result) in
            
            switch result {
            case .success(let apiData):
                print(result)
                switch apiData.apiCode {
                case .success:
                     let response = apiData.response
                    if let data = response["images"].array{
                        self.Images = data
                        self.userPhotosCollectionView.reloadData()
                    }
                    print(apiData)
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
