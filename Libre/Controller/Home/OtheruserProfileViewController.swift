//
//  OtheruserProfileViewController.swift
//  Libre
//
//  Created by piash sarker on 31/7/21.
//

import UIKit

class otherImageCell : UICollectionViewCell {
    @IBOutlet weak var otheUserImage: UIImageView!
    
    override class func awakeFromNib() {
        
    }
}

class OtheruserProfileViewController: UIViewController,UIScrollViewDelegate {
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var aboutTextBack: UIView!
    @IBOutlet weak var otherPhotosCollection: UICollectionView!
    @IBOutlet weak var moreView: UIView!
    
    @IBOutlet weak var moreViewHeightconstraint: NSLayoutConstraint!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var Name: UILabel!
    @IBOutlet weak var profession: UILabel!
    @IBOutlet weak var prefarence: UILabel!
    @IBOutlet weak var about: labelSpecing!
    @IBOutlet weak var otherBackground: UIImageView!
    @IBOutlet weak var backgroundImage: UIImageView!
    //------------------------------------------------------
    //MARK:- Class variable
    
    var isMoreViewOpen = false
    var userId = ""
    var otheruser: OtherUserModel?
    var Images : [JSON] = []
    //MARK:- Memory Management Method
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    deinit {
        print("💥💥💥 OtheruserProfileViewController Deinit💥💥💥")
    }
    
    //------------------------------------------------------
    //MARK:- Custom Method
    
    func setupView(){
        self.aboutTextBack.addBlurEffect()
        self.scrollView.contentInset = UIEdgeInsets(top: 270, left: 0, bottom: 0, right: 0)
        self.scrollView.delegate = self
        self.otherPhotosCollection.delegate = self
        self.moreViewHeightconstraint.constant = 0
        self.moreView.isHidden = true

         
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

    
    func pushToChatVc(){
        let vc = chatViewController.instantiate(fromAppStoryboard: .kTabbarStoryboard)
      
        self.navigationController?.pushViewController(vc, animated: true)
    }
    func pushToAutdioCallViewController(){
        let vc = OngoingCallViewController.instantiate(fromAppStoryboard: .kTabbarStoryboard)
            vc.recipientId = self.userId
        vc.recipientName = otheruser?.name ?? ""
        self.navigationController?.pushViewController(vc, animated: true)
    }
    func pushToVideoCallViewController(){
        let vc = OngoinVideoController.instantiate(fromAppStoryboard: .kTabbarStoryboard)
            vc.recipientId = self.userId
        vc.recipientName = otheruser?.name ?? ""
        self.navigationController?.pushViewController(vc, animated: true)
    }
    func pushToReportViewController(){
        let vc = ReportViewController.instantiate(fromAppStoryboard: .kTabbarStoryboard)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func setupData(){
        if otheruser != nil{

            self.profession.text = otheruser!.professon.capitalized
            self.about.text = otheruser!.aboutYou
            self.prefarence.text = otheruser!.prefarance
            self.Name.text = otheruser!.name.capitalized
            if let url = URL(string: (otheruser!.profileImage)!){
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
    

    
    
    //------------------------------------------------------
    //MARK:- Action method

    @IBAction func moreOption(_ sender: Any) {
        if isMoreViewOpen == false {
            self.moreViewHeightconstraint.constant = 74
            self.moreView.isHidden = false
            self.navigationController?.navigationItem.rightBarButtonItem?.image = UIImage(named: "CrossButton")
            self.isMoreViewOpen = true
        
        }else {
            self.moreViewHeightconstraint.constant = 0
            self.moreView.isHidden = true
            self.navigationController?.navigationItem.rightBarButtonItem?.image = UIImage(named: "More")
            self.isMoreViewOpen = false
        }
        
    }
    
    @IBAction func message(_ sender: Any) {
        self.pushToChatVc()
    }
    
    @IBAction func audioCa(_ sender: Any) {
        self.pushToAutdioCallViewController()
    }
    @IBAction func videoCall(_ sender: Any) {
        self.pushToVideoCallViewController()
    }
    
    @IBAction func reportUser(_ sender: Any) {
        self.pushToReportViewController()
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
        self.navigationController?.navigationBar.isHidden = false
        self.hideTabBar()
        if otheruser != nil {
            if otheruser?.userId != Int(self.userId) {
                self.APICallGetProfile(userId: self.userId)
                self.APICallGetmyImage(userId: self.userId)
            }else{
                self.setupData()
            }
        }else{
            self.APICallGetProfile(userId: self.userId)
            self.APICallGetmyImage(userId: self.userId)
        }
        
        //
        
       

    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }


}

extension OtheruserProfileViewController : UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return Images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? otherImageCell
        if let url = URL(string: Images[indexPath.row].rawValue as! String){
            cell?.otheUserImage.setImageWithDownload(url)
            cell?.otheUserImage.tapToZoom()
        }
        
        return cell!
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {


           let flowLayout = collectionViewLayout as! UICollectionViewFlowLayout

           let numberofItem: CGFloat = 3

           let collectionViewWidth = self.otherPhotosCollection.bounds.width

           let extraSpace = (numberofItem - 1) * flowLayout.minimumInteritemSpacing

           let inset = flowLayout.sectionInset.right + flowLayout.sectionInset.left

           let width = Int((collectionViewWidth - extraSpace - inset) / numberofItem)

           print(width)

           return CGSize(width: width, height: width)
       }
    
}

extension OtheruserProfileViewController {
    private func APICallGetProfile(userId: String) {
            
            let params : [String : Any] = [
                "userId": userId

            ]
            print(params)
            
            ApiManager.shared.makeRequestWithModel(method: .user(.userProfile), modelType: OtherUserModel.self, parameter: params)  { (result) in
                switch result {
                case .success(let apiData):
                    print(result)
                    switch apiData.apiCode {
                    case .success:
                        print(apiData)
                        self.otheruser = apiData.data
                        self.setupData()
                    default:
                        GFunction.shared.showSnackBar(apiData.message)
                    }
                    
                case .failure(let failedMsg):
                    print(failedMsg)
                    break
                }
            }
        }
        private func APICallGetmyImage(userId: String) {
            
            let params : [String : Any] = [
                "userId": userId

            ]
            print(params)
            
            ApiManager.shared.makeRequest(method:.user(.getuserImages), methodType: .post, parameter: params, withErrorAlert: true, withLoader: true, withdebugLog: true) { (result) in
                
                switch result {
                case .success(let apiData):
                    print(result)
                    switch apiData.apiCode {
                    case .success:
                         let response = apiData.response
                        if let data = response["images"].array{
                            self.Images = data
                            self.otherPhotosCollection.reloadData()
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
