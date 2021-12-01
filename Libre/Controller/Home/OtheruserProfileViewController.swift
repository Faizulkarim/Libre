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
        self.scrollView.contentInset = UIEdgeInsets(top: 240, left: 0, bottom: 0, right: 0)
        self.scrollView.delegate = self
        self.otherPhotosCollection.delegate = self
        self.moreViewHeightconstraint.constant = 0
        self.moreView.isHidden = true
    }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        let y = 200 - (scrollView.contentOffset.y + 240)
        let h = max(100, y)
        let react = CGRect(x: 0, y: 0, width: view.bounds.width, height: h)
        topView.frame = react

        
        if y < 80 {

        }else {
            print(y)
          
        }
    }
    
    func pushToChatVc(){
        let vc = chatViewController.instantiate(fromAppStoryboard: .kTabbarStoryboard)
      
        self.navigationController?.pushViewController(vc, animated: true)
    }
    func pushToCallViewController(){
        let vc = OngoingCallViewController.instantiate(fromAppStoryboard: .kTabbarStoryboard)
      
        self.navigationController?.pushViewController(vc, animated: true)
    }
    func pushToReportViewController(){
        let vc = ReportViewController.instantiate(fromAppStoryboard: .kTabbarStoryboard)
      
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func setupData(){
        
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
        self.pushToCallViewController()
    }
    @IBAction func videoCall(_ sender: Any) {
        self.pushToCallViewController()
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

    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }


}

extension OtheruserProfileViewController : UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return 30
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? otherImageCell
        
        
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
    private func APICallGetProfile(userId : String) {
        
        let params : [String : Any] = [
            "userId": userId
   
        ]
        print(params)
        
        ApiManager.shared.makeRequest(method: .user(.userProfile), methodType: .post, parameter: params, withErrorAlert: true, withLoader: true) { (result) in
            switch result {
            case .success(let apiData):
                print(result)
                switch apiData.apiCode {
                    
                
              
                case .success:
                    print(apiData)
                    self.otheruser = OtherUserModel.init(fromJson: apiData.data)

                    
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
