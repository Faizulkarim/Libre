//
//  BackgroundImageViewController.swift
//  Libre
//
//  Created by piash sarker on 31/7/21.
//

import UIKit

class backgroundImageCell : UICollectionViewCell{
    @IBOutlet weak var selectedView: UIView!
    
    @IBOutlet weak var backgroundImage: UIImageView!
    override class func awakeFromNib() {
        
    }
}

class headerClass : UICollectionReusableView {
    @IBOutlet weak var headerName: UILabel!
 
}

class BackgroundImageViewController: UIViewController {
    @IBOutlet weak var backgroundImageCollectionview: UICollectionView!
    
    
    //------------------------------------------------------
    //MARK:- Calass variable
    var indexpathCount: Int?
    var SectionCount : Int?
    var myImages :[JSON] = []
    
    //MARK:- Memory Management Method
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    deinit {
        print("💥💥💥 BackgroundImageViewController Deinit💥💥💥")
    }
    
    //------------------------------------------------------
    //MARK:- Custom Method
    
    
    func setupView(){
        self.backgroundImageCollectionview.delegate = self
    
    }
    
    func pushToBackgroundImageViewController(){
        let vc = UploadBackgroundViewController.instantiate(fromAppStoryboard: .kLoginStoryboard)
      
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    //------------------------------------------------------
    //MARK:- Action method
    
    @IBAction func save(_ sender: Any) {
        self.popViewController(sender: self)
    }
    
    

    
    
    //------------------------------------------------------
    //MARK:- Life Cycle Method

    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }


}

extension BackgroundImageViewController : UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
//     func collectionView(_ collectionView: UICollectionView,
//     viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) ->
//      UICollectionReusableView {
//
//        var header: headerClass?
//
//        if kind == UICollectionView.elementKindSectionHeader {
//            header =
//                collectionView.dequeueReusableSupplementaryView(ofKind: kind,
//                  withReuseIdentifier: "headerCell", for: indexPath)
//                     as? headerClass
//
//            header?.headerName.text = "Fitness Enthusiest"
//        }
//        return header!
//    }
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        
        return 1
    }




    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return myImages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? backgroundImageCell
        if self.indexpathCount == indexPath.row && SectionCount == indexPath.section {
                    cell?.selectedView.isHidden = false
                }else{
                    cell?.selectedView.isHidden = true
                }
        if let url = URL(string: myImages[indexPath.row].rawValue as! String){
            cell?.backgroundImage.setImageWithDownload(url)
        }
        
        return cell!
    }
    

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.indexpathCount = indexPath.row
        self.SectionCount = indexPath.section
        self.backgroundImageCollectionview.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 40)
    }
  
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {


           let flowLayout = collectionViewLayout as! UICollectionViewFlowLayout

           let numberofItem: CGFloat = 2

           let collectionViewWidth = self.backgroundImageCollectionview.bounds.width

           let extraSpace = (numberofItem - 1) * flowLayout.minimumInteritemSpacing

           let inset = flowLayout.sectionInset.right + flowLayout.sectionInset.left

           let width = Int((collectionViewWidth - extraSpace - inset) / numberofItem)

           print(width)

           return CGSize(width: width, height: width)
       }
    
}
extension BackgroundImageViewController {
    private func APICallGetBackgroundImage() {
        
        let params : [String : Any] = [
            "userId": UserModel.currentUser?.userId! as Any,
            "category": "fitness_enthusiast"

        ]
        print(params)
        
        ApiManager.shared.makeRequest(method:.auth(.backgroundImage), methodType: .post, parameter: params, withErrorAlert: true, withLoader: true,withToken: false, withdebugLog: true) { (result) in
            
            switch result {
            case .success(let apiData):
                print(result)
                switch apiData.apiCode {
                case .success:
                     let response = apiData.response
                    if let data = response["images"].array{
                        self.myImages = data
                        self.backgroundImageCollectionview.reloadData()
                       
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
