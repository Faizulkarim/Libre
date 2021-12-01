//
//  InboxViewController.swift
//  Libre
//
//  Created by piash sarker on 29/7/21.
//

import UIKit


class inboxListCell : UITableViewCell {
    @IBOutlet weak var Userimage: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var msg: UILabel!
    @IBOutlet weak var timeAgo: UILabel!
    @IBOutlet weak var activeView: RoundImage!
    
    override class func awakeFromNib() {
        
    }
}

class InboxViewController: UIViewController {
    @IBOutlet weak var inboxTableView: UITableView!
    @IBOutlet weak var searchView: UIView!
    
    //MARK:- Memory Management Method
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    deinit {
        print("💥💥💥 InboxViewController Deinit💥💥💥")
    }
    
    //------------------------------------------------------
    //MARK:- Custom Method
    
    
    func setupView(){
        searchView.applyViewShadowWithCornerRadius(shadowOffset: nil, shadowColor: UIColor.gray, shadowOpacity: 0.5, cornerRadius: 5, shadowRadius: 5)
    }
    
    func pushToChatVc(){
        let vc = chatViewController.instantiate(fromAppStoryboard: .kTabbarStoryboard)
      
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
        self.navigationController?.navigationBar.setGradientBackground(colors: [UIColor.colorFromHex(hex: 0x4D4347), UIColor.colorFromHex(hex: 0x5D4147)])
        self.showTabBar()

    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }


}

extension InboxViewController : UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        15
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! inboxListCell
        if indexPath.row == 3 || indexPath.row == 6 || indexPath.row == 7 {
            cell.activeView.backgroundColor = UIColor.red
            cell.timeAgo.text = "25 min ago "
            cell.msg.text = "Have a nice day!"
        }
        if indexPath.row == 2 || indexPath.row == 5 {
            cell.msg.text = "Hello"
            cell.activeView.backgroundColor = UIColor.yellow
        }
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.pushToChatVc()
    }
    
    
}
