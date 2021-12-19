//
//  CallHistoryViewController.swift
//  Libre
//
//  Created by piash sarker on 30/7/21.
//

import UIKit

class  Callhistorycell: UITableViewCell {
    @IBOutlet weak var callType: UIImageView!
    @IBOutlet weak var day: UILabel!
    @IBOutlet weak var timeAgo: UILabel!
    @IBOutlet weak var Userimage: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var activeView: RoundImage!
    override class func awakeFromNib() {
        
    }
}

class CallHistoryViewController: UIViewController {

    //MARK:- Memory Management Method
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    deinit {
        print("💥💥💥 CallHistoryViewController Deinit💥💥💥")
    }
    
    //------------------------------------------------------
    //MARK:- Custom Method
    
    
    func setupView(){
    
    }
    
    func pushToCallViewController(){
        let vc = OngoingCallViewController.instantiate(fromAppStoryboard: .kTabbarStoryboard)
      
        self.navigationController?.pushViewController(vc, animated: true)
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
        self.navigationController?.navigationBar.isHidden = false

    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }


}

extension CallHistoryViewController : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 15
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? Callhistorycell
        if indexPath.row == 2 || indexPath.row == 3 {
            
            cell?.callType.image = UIImage(named: "videoNormal")
        }
        if indexPath.row == 4 {
            cell?.callType.image = UIImage(named: "video")
            cell?.timeAgo.textColor = UIColor.red
            cell?.name.textColor = UIColor.red
        }
        if indexPath.row == 6 || indexPath.row == 7 {
            cell?.day.isHidden = false
            cell?.timeAgo.text = "9:45 PM"
            cell?.name.textColor = UIColor.red
            cell?.callType.image = UIImage(named: "telephoneRed")
            cell?.activeView.backgroundColor = UIColor.red
        }
        
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        self.pushToCallViewController()
       
    }
    
    
}
