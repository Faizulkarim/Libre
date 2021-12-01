//
//  chatViewController.swift
//  Libre
//
//  Created by piash sarker on 30/7/21.
//

import UIKit
import MessageKit

struct sender: SenderType {
    var senderId: String
    var displayName: String
}

struct Message: MessageType {
    var sender: SenderType
    var messageId: String
    var sentDate: Date
    var kind: MessageKind
    
  
}

class chatViewController: MessagesViewController, MessagesDataSource,MessagesLayoutDelegate,MessagesDisplayDelegate {
    @IBOutlet weak var toggleView: UIView!
    @IBOutlet weak var photoRequest: UIView!
    @IBOutlet weak var audioCall: UIView!
    @IBOutlet weak var videoCall: UIView!
    @IBOutlet weak var repostUser: UIView!
    @IBOutlet weak var TextViewholder: UIView!
    @IBOutlet weak var msgText: UITextField!
    @IBOutlet weak var more: UIBarButtonItem!
    
    //------------------------------------------------------
    //MARK:- Class variable
    
    var currentUser = sender(senderId: "self", displayName: "Test test")
    var otherUser = sender(senderId: "othere", displayName: "Hi hi")
    var messages = [Message]()
    var isMoreSelected = false
    //MARK:- Memory Management Method
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    deinit {
        print("💥💥💥 chatViewController Deinit💥💥💥")
    }
    
    //------------------------------------------------------
    //MARK:- Custom Method
    
    
    func setupView(){
        self.toggleView.isHidden = true
        self.view.bringSubviewToFront(toggleView)
        messagesCollectionView.messagesLayoutDelegate = self
        messagesCollectionView.messagesDisplayDelegate = self
        messagesCollectionView.messagesDataSource = self
        self.photoRequest.applyViewShadowWithCornerRadius(shadowOffset: nil, shadowColor: UIColor.gray, shadowOpacity: 0.5, cornerRadius: 5, shadowRadius: 2)
        self.audioCall.applyViewShadowWithCornerRadius(shadowOffset: nil, shadowColor: UIColor.gray, shadowOpacity: 0.5, cornerRadius: 5, shadowRadius: 2)
        self.videoCall.applyViewShadowWithCornerRadius(shadowOffset: nil, shadowColor: UIColor.gray, shadowOpacity: 0.5, cornerRadius: 5, shadowRadius: 2)
        self.repostUser.applyViewShadowWithCornerRadius(shadowOffset: nil, shadowColor: UIColor.gray, shadowOpacity: 0.5, cornerRadius: 5, shadowRadius: 2)
        self.TextViewholder.applyViewShadowWithCornerRadius(shadowOffset: nil, shadowColor: UIColor.gray, shadowOpacity: 0.5, cornerRadius: 0, shadowRadius: 2)
        self.msgText.applyCornerRadius(cornerRadius: 20, borderColor: UIColor.lightGray, borderWidth: 0.5)
        self.audioCall.handleTapToAction {
            GFunction.shared.alertWithAction(view: self, msg: "Request to allow call", title: "Request") {
                self.pushToCallViewController()
            }
        }
        self.videoCall.handleTapToAction {
            self.pushToCallViewController()
        }
        self.photoRequest.handleTapToAction {
            self.toggleView.isHidden = true
        }
        self.repostUser.handleTapToAction {
            self.pushToReportViewController()
        }
        
        
    
    }
    

    
    func pushToCallViewController(){
        let vc = OngoingCallViewController.instantiate(fromAppStoryboard: .kTabbarStoryboard)
      
        self.navigationController?.pushViewController(vc, animated: true)
    }
    func pushToReportViewController(){
        let vc = ReportViewController.instantiate(fromAppStoryboard: .kTabbarStoryboard)
      
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    
    //------------------------------------------------------
    //MARK:- Action method
    
    
    @IBAction func moreOpt(_ sender: UIBarButtonItem) {
        
        isMoreSelected = !isMoreSelected
        if isMoreSelected {
            more.image = UIImage(named: "treeDotButtonR")
            self.toggleView.isHidden = false
        } else {
            more.image = UIImage(named: "treeDotButton")
            self.toggleView.isHidden = true
        }

        
    }
    
    
    //------------------------------------------------------
    //MARK:- Life Cycle Method

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupView()
        messages.append(Message(sender: currentUser, messageId: "1", sentDate: Date().addingTimeInterval(-8600), kind: .text("Hello there")))
        messages.append(Message(sender: otherUser, messageId: "2", sentDate: Date().addingTimeInterval(-8400), kind: .text("Hi there")))
        messages.append(Message(sender: currentUser, messageId: "3", sentDate: Date().addingTimeInterval(-8200), kind: .text("How are You?")))
        messages.append(Message(sender: otherUser, messageId: "4", sentDate: Date().addingTimeInterval(-8000), kind: .text("Fine, Thanks for asking.How about you?")))
        messages.append(Message(sender: currentUser, messageId: "5", sentDate: Date().addingTimeInterval(-7600), kind: .text("Also fine alhamdulillah")))
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.setGradientBackground(colors: [UIColor.colorFromHex(hex: 0x4D4347), UIColor.colorFromHex(hex: 0x5D4147)])

    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }


}
extension chatViewController {
    
    func currentSender() -> SenderType {
        
        return currentUser
    }
    
    func messageForItem(at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageType {
        return messages[indexPath.section]
    }
    
    func numberOfSections(in messagesCollectionView: MessagesCollectionView) -> Int {
        
        return messages.count
    }
    
    
}


