//
//  premiumViewController.swift
//  Libre
//
//  Created by piash sarker on 2/8/21.
//

import UIKit
import PassKit

class paymentCell : UICollectionViewCell {
    @IBOutlet weak var selectedView: UIView!
    @IBOutlet weak var sPrice: labelSpecing!
    @IBOutlet weak var sMonth: UILabel!
    @IBOutlet weak var sStarter: labelSpecing!
    @IBOutlet weak var stView: UIView!
    

    
}

class premiumViewController: UIViewController {

    
    @IBOutlet weak var purchaseButton: ButtonWordSpecing!
    @IBOutlet weak var payment: UICollectionView!
    
    //------------------------------------------------------
    //MARK:- Class variable
    
    var selectedIndex = 0
    var price = ["5","8", "10"]
    var month = ["1","6","12"]
    var packName = ["STARTER","POPULAR","VALUE"]
    var transactionIdForApple = ""
    private var paymentRequest : PKPaymentRequest = PKPaymentRequest()
    //------------------------------------------------------
    //MARK:- Memory Management Method
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    deinit {
        print("💥💥💥 premiumViewController Deinit💥💥💥")
    }
    
    //------------------------------------------------------
    //MARK:- Custom Method
    @available(iOS 11.0, *)
    func applePaySetup(){
        paymentRequest.merchantIdentifier = "merchant.com.mjnun.customer"
        paymentRequest.supportedNetworks = [.amex, .masterCard, .visa]
        paymentRequest.supportedCountries = ["US", "SA"]
        paymentRequest.merchantCapabilities = .capability3DS
        paymentRequest.countryCode = "US"
        paymentRequest.currencyCode = "USD"
    }
    @objc func tapForPay(){
       
        let totalPayable = String("self.lblTotalPayValue.text!.dropFirst(3)")
        print(totalPayable)
        paymentRequest.paymentSummaryItems = [PKPaymentSummaryItem(label: "test name", amount: NSDecimalNumber(string: "30"))]
             
             let controller = PKPaymentAuthorizationViewController(paymentRequest: paymentRequest)
             if controller != nil {
                 controller!.delegate = self
                 present(controller!, animated: true, completion: nil)
             }
         
     }
    
    func setupView(){
        if #available(iOS 11.0, *) {
            applePaySetup()
        } else {
            // Fallback on earlier versions
        }
        self.payment.delegate = self
        self.purchaseButton.applyGradient(colours: [UIColor.colorFromHex(hex: 0xCF4E4E), UIColor.colorFromHex(hex: 0x6E2A2A)])
        self.navigationController?.navigationBar.setGradientBackground(colors: [UIColor.colorFromHex(hex: 0x4D4347), UIColor.colorFromHex(hex: 0x5D4147)])
        self.purchaseButton.handleTapToAction {
            self.tapForPay()
        }
    }
    
    func pushToBackgroundImageViewController(){
        let vc = UploadBackgroundViewController.instantiate(fromAppStoryboard: .kLoginStoryboard)
      
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    //------------------------------------------------------
    //MARK:- Action method
    
    @IBAction func gotoHome(_ sender: Any) {
        GFunction.shared.setHomeScreen()
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
        self.navigationController?.navigationBar.setGradientBackground(colors: [UIColor.colorFromHex(hex: 0x4D4347), UIColor.colorFromHex(hex: 0x5D4147)])
    }

}

extension premiumViewController : UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? paymentCell
        

        cell?.sPrice.text =  "$\(price[indexPath.row])"
        cell?.sMonth.text = "\(month[indexPath.row]) Month"
        cell?.sStarter.text = packName[indexPath.row]
        
            if selectedIndex == indexPath.row{
                cell?.selectedView.applyGradient(colours: [UIColor.colorFromHex(hex: 0xD04F4F), UIColor.colorFromHex(hex: 0x682828)])
                cell?.stView.applyGradient(colours: [UIColor.colorFromHex(hex: 0x313131), UIColor.colorFromHex(hex: 0x5D4147)])
                cell?.sPrice.textColor = UIColor.white
                cell?.sMonth.textColor = UIColor.white
            
            }else{
                cell?.sPrice.textColor = UIColor.colorFromHex(hex: 0x584147)
                cell?.sMonth.textColor = UIColor.colorFromHex(hex: 0x584147)
                cell?.selectedView.backgroundColor = UIColor.white
                cell?.selectedView.applyGradient(colours: [UIColor.lightGray, UIColor.lightGray])
                if indexPath.row == 1 {
                   cell?.stView.applyGradient(colours: [UIColor.colorFromHex(hex: 0xFEF5F0), UIColor.colorFromHex(hex: 0xE47F71)])
                   
                }else if indexPath.row == 2{
                   cell?.stView.applyGradient(colours: [UIColor.colorFromHex(hex: 0xFEF5F0), UIColor.colorFromHex(hex: 0xE7B685)])
               }
            }
  

        
        return cell!
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {


          var  heigh : Int?
             if selectedIndex == indexPath.row{
                  heigh = 165
              }else{
                  heigh = 160
              }
           let flowLayout = collectionViewLayout as! UICollectionViewFlowLayout

           let numberofItem: CGFloat = 3

           let collectionViewWidth = self.payment.bounds.width

           let extraSpace = (numberofItem - 1) * flowLayout.minimumInteritemSpacing

           let inset = flowLayout.sectionInset.right + flowLayout.sectionInset.left

           let width = Int((collectionViewWidth - extraSpace - inset) / numberofItem)

           print(width)
        print(heigh)

        return CGSize(width: width, height: heigh!)
       }
    

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        self.selectedIndex = indexPath.row
        self.payment.reloadData()
    }
    
    
}
extension premiumViewController : PKPaymentAuthorizationViewControllerDelegate {
    func paymentAuthorizationViewControllerDidFinish(_ controller: PKPaymentAuthorizationViewController) {
        controller.dismiss(animated: true, completion: nil)
//        apiPlaceorderCalling()
    }
    
    @available(iOS 11.0, *)
    func paymentAuthorizationViewController(_ controller: PKPaymentAuthorizationViewController, didAuthorizePayment payment: PKPayment, handler completion: @escaping (PKPaymentAuthorizationResult) -> Void) {
        completion(PKPaymentAuthorizationResult(status: .success, errors: nil))
        print("Payment success")
        transactionIdForApple = payment.token.transactionIdentifier
       
        
    }
}
