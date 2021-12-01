//
//  myPhotosViewController.swift
//  Libre
//
//  Created by piash sarker on 31/7/21.
//

import UIKit

class myphotoCollectionViewCell: UICollectionViewCell{
    @IBOutlet weak var photo: UIImageView!
    @IBOutlet weak var deleteButton: UIButton!
    
}


class myPhotosViewController: UIViewController {
    @IBOutlet weak var myPhotoCollectionView: UICollectionView!
    
    
    //------------------------------------------------------
    //MARK:- class variable
    var myImages :[JSON] = []
    var uploadImageUrl = ""
    var photos = ["profilelargeImage","profilelargeImage","profilelargeImage","profilelargeImage","profilelargeImage","profilelargeImage"]
    
    //MARK:- Memory Management Method
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    deinit {
        print("💥💥💥 myPhotosViewController Deinit💥💥💥")
    }
    
    //------------------------------------------------------
    //MARK:- Custom Method
    
    
    func setupView(){
        self.myPhotoCollectionView.delegate = self
        self.APICallGetmyImage()
    }
    func uploadImage(image : UIImage){
        ImageUpload.shared.uploadImage(showLoader: true, image: image, mimeType: "image/jpeg", imageType: S3Bucket.kAWSUserPath) { (full, last, response, idx) in
            debugPrint(full as Any)
            GFunction.shared.removeLoader()
           // self.imageName = last
            self.APICallUploadImage(imageUrl: full!)
          
           
            print("This is image name")
        }
        
     
    }
    func pushToBackgroundImageViewController(){
        let vc = UploadBackgroundViewController.instantiate(fromAppStoryboard: .kLoginStoryboard)
      
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    //------------------------------------------------------
    //MARK:- Action method
    
    @IBAction func UploadBackgroundImageView(_ sender: Any) {
        
        pushToBackgroundImageViewController()
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
        self.navigationController?.navigationBar.isHidden = false
   

    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }


}

extension myPhotosViewController : UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return myImages.count + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? myphotoCollectionViewCell

        if indexPath.row == 0 {
            cell?.deleteButton.isHidden = true
            cell?.photo.contentMode = .center
            cell?.photo.image = UIImage(named: "pluseImage")

        }else{
            cell?.deleteButton.isHidden = false
            cell?.photo.contentMode = .scaleAspectFill
      
            if let url = URL(string: myImages[indexPath.row-1].rawValue as! String){
                cell?.photo.setImageWithDownload(url)
            }
            cell?.deleteButton.handleTapToAction(action: {
                GFunction.shared.alertWithAction(view: self, msg: "Are you sure you want to remove this photo?", title: "Remove") {
                    self.APICalldeleteImage(index: indexPath.row-1)
                    self.myPhotoCollectionView.reloadData()
                }
              
            })
        }
        
        
        return cell!
    }
    

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.row == 0 {
                   ImagePickerManager().pickImage(self){ image in
                       
                    DispatchQueue.main.async { [self] in
                        uploadImage(image: image)
                        self.myPhotoCollectionView.reloadData()
                      }
                }
        }else {
            
         }
       }
  
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {


           let flowLayout = collectionViewLayout as! UICollectionViewFlowLayout

           let numberofItem: CGFloat = 3

           let collectionViewWidth = self.myPhotoCollectionView.bounds.width

           let extraSpace = (numberofItem - 1) * flowLayout.minimumInteritemSpacing

           let inset = flowLayout.sectionInset.right + flowLayout.sectionInset.left

           let width = Int((collectionViewWidth - extraSpace - inset) / numberofItem)

           print(width)

           return CGSize(width: width, height: width)
       }
    
}

extension myPhotosViewController {
    private func APICalldeleteImage(index: Int) {
        
        let params : [String : Any] = [
            "userId": UserModel.currentUser?.userId! as Any,
            "index" : index
        ]
        print(params)
        
        ApiManager.shared.makeRequest(method:.user(.deleteImage), methodType: .post, parameter: params, withErrorAlert: true, withLoader: true, withdebugLog: true) { (result) in
            
            print(result)
            switch result {
            case .success(let apiData):
                print(result)
                switch apiData.apiCode {
                case .success:
                    self.APICallGetmyImage()
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
    private func APICallUploadImage(imageUrl: String) {
        
        let params : [String : Any] = [
            "userId": UserModel.currentUser?.userId! as Any,
            "imagesUrl" : imageUrl

        ]
        print(params)
        
        ApiManager.shared.makeRequest(method:.user(.uploaduserImages), methodType: .post, parameter: params, withErrorAlert: true, withLoader: true, withdebugLog: true) { (result) in
            
            print(result)
            switch result {
            case .success(let apiData):
                print(result)
                switch apiData.apiCode {
                case .success:
                    let response = apiData.response
                   if let data = response["images"].array{
                       self.myImages = data
                    self.myPhotoCollectionView.reloadData()
                    GFunction.shared.showSnackBar(apiData.message)
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
    private func APICallGetmyImage() {
        
        let params : [String : Any] = [
            "userId": UserModel.currentUser?.userId! as Any,
           // "imagesUrl" : imageurl

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
                        self.myImages = data
                        self.myPhotoCollectionView.reloadData()
                       
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
