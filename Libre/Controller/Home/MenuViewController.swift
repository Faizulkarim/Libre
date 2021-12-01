//
//  MenuViewController.swift
//  Libre
//
//  Created by piash sarker on 1/8/21.
//

import UIKit

class menuClass : UITableViewCell {
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var menuImage: UIImageView!
}

class MenuViewController: UIViewController {
  
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var widthMenu: NSLayoutConstraint!
    
    //------------------------------------------------------
    //MARK:- Class variable
    var menuArray = ["Settings","Libre Premium","Privacy Policy","Contact Us","Log Out"]
    
    //MARK:- Memory Management Method
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    deinit {
        print("💥💥💥 MenuViewController Deinit💥💥💥")
    }
    
    //------------------------------------------------------
    //MARK:- Custom Method
    
    
    func setupView(){
        self.widthMenu.constant = 0.672 * kScreenWidth
        self.tableView.tableFooterView = UIView()
    }
    
    func pushToSettingViewController(){
        let vc = SettingViewController.instantiate(fromAppStoryboard: .kMenuStoryboard)
      
        self.navigationController?.pushViewController(vc, animated: true)
    
    }
    
    private var menuLoginContentControllers: [UIViewController] {
        
       // let homeVC = UIStoryboard.kTabbarStoryboard.instantiateViewController(withIdentifier: kNAVHOME)
        let Settings = UIStoryboard.kMenuStoryboard.instantiateViewController(identifier: "settings")
        let payment = UIStoryboard.kMenuStoryboard.instantiateViewController(identifier: "payment")
        let privecy = UIStoryboard.kMenuStoryboard.instantiateViewController(identifier: "contact")
        let contact = UIStoryboard.kMenuStoryboard.instantiateViewController(identifier: "contact")
        

        
        return [Settings,payment,privecy,contact]
    }
    
    
    //------------------------------------------------------
    //MARK:- Action method
    

    

    
    
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
    func PushToLoginView(){
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let login = storyBoard.instantiateViewController(withIdentifier: "LoginAndSignUpViewController") as! LoginAndSignUpViewController
        login.modalPresentationStyle = .fullScreen
        self.present(login, animated: true, completion: nil)
        
    }
    
    func logout(){
        let alert = UIAlertController(title: kAppName, message: "Do you want to Logout?", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: kYes, style: .default, handler: { action in
            self.APICallLogout()
        }))
        
        alert.addAction(UIAlertAction(title: kNo, style: .destructive, handler: { action in
        }))
        
        self.present(alert, animated: true, completion: nil)
    }


}

extension MenuViewController : UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        
        return menuArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? menuClass
        
        cell?.name.text = menuArray[indexPath.row]
        cell?.menuImage.image = UIImage(named: menuArray[indexPath.row])
        
        return cell!
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        switch indexPath.row {
//        case 0:
//            self.pushToSettingViewController()
//        default:
//            break
//        }
        if indexPath.row == 4 {
            self.logout()
        }else {
            if indexPath.row <= menuLoginContentControllers.count {
                self.slideMenuController()?.changeMainViewController(menuLoginContentControllers[indexPath.row], close: true)
            }
        }
        
      
        
    }
    
    
}

extension MenuViewController {
    func APICallLogout() {
        ApiManager.shared.makeRequest(method:.auth(.signout), methodType: .get, parameter: [:], withErrorAlert: true, withLoader: true, withdebugLog: true) { (result) in
           
           switch result {
           case .success(let apiData):
               print(result)
               switch apiData.apiCode {
               case .success:
                GFunction.shared.userLogout()
                self.PushToLoginView()
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



