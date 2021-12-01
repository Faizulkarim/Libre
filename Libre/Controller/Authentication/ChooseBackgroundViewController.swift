//
//  ChooseBackgroundViewController.swift
//  Libre
//
//  Created by piash sarker on 29/7/21.
//

import UIKit

class chooseBackgroundCollectionViewCell : UICollectionViewCell {
    @IBOutlet weak var Image: UIImageView!
    @IBOutlet weak var blurView: UIView!
    @IBOutlet weak var selectedLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
       
    }
    
}

class ChooseBackgroundViewController: UIViewController {
    @IBOutlet weak var ImageCollectionView: UICollectionView!
    
    
    //------------------------------------------------------
    //MARK:- Class variable
    
    var SelectedIndexpath : Int?
    var myImages :[JSON] = []
    //------------------------------------------------------
    //MARK:- Memory Management Method
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    deinit {
        print("💥💥💥 ChooseBackgroundViewController Deinit💥💥💥")
    }
    
    //------------------------------------------------------
    //MARK:- Custom Method
    
    
    func setupView(){
    
    }
    
    func pushToBackgroundPreview(){
        let vc = BackgroundPreviewViewController.instantiate(fromAppStoryboard: .kLoginStoryboard)
      
        self.navigationController?.pushViewController(vc, animated: true)
    }

    
    
    //------------------------------------------------------
    //MARK:- Action Method
    @IBAction func Confirm(_ sender: Any) {
        if userChosenData.backgroundImage != ""{
            self.pushToBackgroundPreview()
        }
        
    }
    
    
    
    //------------------------------------------------------
    //MARK:- Life Cycle Method

    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.APICallGetBackgroundImage()
    }


}

extension ChooseBackgroundViewController : UICollectionViewDataSource, UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return myImages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! chooseBackgroundCollectionViewCell
        if SelectedIndexpath == indexPath.row {
            cell.blurView.isHidden = false
            cell.selectedLabel.isHidden = false
        }else{
            cell.blurView.isHidden = true
            cell.selectedLabel.isHidden = true
        }
        if let url = URL(string: myImages[indexPath.row].rawValue as! String){
            cell.Image.setImageWithDownload(url)
        }
        
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        SelectedIndexpath = indexPath.row
        userChosenData.backgroundImage = myImages[indexPath.row].rawValue as! String
        ImageCollectionView.reloadData()
        
    }
    
    
}
extension ChooseBackgroundViewController{
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
                        self.ImageCollectionView.reloadData()
                       
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
