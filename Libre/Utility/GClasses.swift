//
//  Gclasses.swift
//  Ghaf
//
//  Created by Ashish on 03/05/19.
//  Copyright © 2019 Hyperlink. All rights reserved.
//

import Foundation
import UIKit
import MobileCoreServices
import MapKit

// MARK:- Theme button & View

class TopCornersRoundView: UIView {
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)

        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: [.topRight, .topLeft], cornerRadii: CGSize(width: kFontSize20, height: kFontSize20))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        self.layer.mask = mask
    }
}

class ThemeButton: UIButton {
    
    private var shadowLayer: CAShapeLayer!
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.applyStyle(titleFont: .applyFont(fontType: .FontRegular, fontSize: kFontSize18), titleColor: UIColor.white)
        
        if shadowLayer == nil {
            shadowLayer = CAShapeLayer()
            shadowLayer.path = UIBezierPath(roundedRect: bounds, cornerRadius: 5.0).cgPath
            shadowLayer.fillColor = kTHEMECOLOR.cgColor
            
            shadowLayer.shadowColor = UIColor.colorFromHexWithAlpha(hex: 0x000000, opacity: 0.4).cgColor
            shadowLayer.shadowPath = shadowLayer.path
            shadowLayer.shadowOffset = CGSize(width: 0.5, height: 2.0)
            shadowLayer.shadowOpacity = 0.5
            shadowLayer.shadowRadius = 2
            
            layer.insertSublayer(shadowLayer, at: 0)
        }
    }
}

class WhiteButton: UIButton {
    
    private var shadowLayer: CAShapeLayer!
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.applyStyle(titleFont: .applyFont(fontType: .FontRegular, fontSize: kFontSize18), titleColor: kTHEMECOLOR)
        self.applyCornerRadius(cornerRadius: 5.0, borderColor: kTHEMECOLOR, borderWidth: 2.0)
    }
}

class BlackButtonWithShadow: UIButton {
    
    private var shadowLayer: CAShapeLayer!
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.font(name: .FontRegular, size: kFontSize18).textColor(color: .white)
        
        if shadowLayer == nil {
            shadowLayer = CAShapeLayer()
            shadowLayer.path = UIBezierPath(roundedRect: bounds, cornerRadius:  5.0).cgPath
            shadowLayer.fillColor = UIColor.ColorTextColor.cgColor
            
            shadowLayer.shadowColor = UIColor.colorFromHexWithAlpha(hex: 0x000000, opacity: 0.5).cgColor
            shadowLayer.shadowPath = shadowLayer.path
            shadowLayer.shadowOffset = CGSize.zero
            shadowLayer.shadowOpacity = 0.5
            shadowLayer.shadowRadius = 2
            
            layer.insertSublayer(shadowLayer, at: 0)
        }
    }
}

class GreenButtonWithShadow: UIButton {
    
    private var shadowLayer: CAShapeLayer!
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.font(name: .FontRegular, size: kFontSize18).textColor(color: .white)
        
        if shadowLayer == nil {
            shadowLayer = CAShapeLayer()
            shadowLayer.path = UIBezierPath(roundedRect: bounds, cornerRadius:  5.0).cgPath
            shadowLayer.fillColor = UIColor.ColorGreen.cgColor
            
            shadowLayer.shadowColor = UIColor.colorFromHexWithAlpha(hex: 0x000000, opacity: 0.5).cgColor
            shadowLayer.shadowPath = shadowLayer.path
            shadowLayer.shadowOffset = CGSize.zero
            shadowLayer.shadowOpacity = 0.5
            shadowLayer.shadowRadius = 2
            
            layer.insertSublayer(shadowLayer, at: 0)
        }
    }
}

class RedButtonWithShadow: UIButton {
    
    private var shadowLayer: CAShapeLayer!
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.font(name: .FontRegular, size: kFontSize18).textColor(color: .white)
        
        if shadowLayer == nil {
            shadowLayer = CAShapeLayer()
            shadowLayer.path = UIBezierPath(roundedRect: bounds, cornerRadius: 5.0).cgPath
            shadowLayer.fillColor = UIColor.ColorRed.cgColor
            
            shadowLayer.shadowColor = UIColor.colorFromHexWithAlpha(hex: 0x000000, opacity: 0.5).cgColor
            shadowLayer.shadowPath = shadowLayer.path
            shadowLayer.shadowOffset = CGSize.zero
            shadowLayer.shadowOpacity = 0.5
            shadowLayer.shadowRadius = 2
            
            layer.insertSublayer(shadowLayer, at: 0)
        }
    }
}

class BtnWithBlackBorder : UIButton {
    override func awakeFromNib() {
        
        self.textColor(color: .ColorGrey)
            .borderColor(color: .ColorGrey, borderWidth: 1.0)
            .cornerRadius(cornerRadius: 5.0)
            .shadow(color: UIColor.ColorTextColor, shadowOffset: CGSize(width: 0, height: 3), shadowOpacity: 0.29, radius: 3.0)
            
        let backgroundCGColor = backgroundColor?.cgColor
        backgroundColor = nil
        layer.backgroundColor =  backgroundCGColor
    }
}

class BtnWithThemecolorBorder : UIButton {
    override func awakeFromNib() {
        
        self.textColor(color: kTHEMECOLOR)
            .borderColor(color: kTHEMECOLOR, borderWidth: 1.0)
            .cornerRadius(cornerRadius: 5.0)
            .shadow(color: UIColor.ColorTextColor, shadowOffset: CGSize(width: 0, height: 3), shadowOpacity: 0.29, radius: 3.0)
            
        let backgroundCGColor = backgroundColor?.cgColor
        backgroundColor = nil
        layer.backgroundColor =  backgroundCGColor
    }
}

class WhiteBaseView: UIView {
    
    private var shadowLayer: CAShapeLayer!
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if shadowLayer == nil {
            shadowLayer = CAShapeLayer()
            shadowLayer.path = UIBezierPath(roundedRect: bounds, cornerRadius: 5).cgPath
            shadowLayer.fillColor = UIColor.clear.cgColor
            
            shadowLayer.shadowColor = UIColor.colorFromHexWithAlpha(hex: 0x000000, opacity: 0.16).cgColor
            shadowLayer.shadowPath = shadowLayer.path
            shadowLayer.shadowOffset = CGSize.zero
            shadowLayer.shadowOpacity = 0.5
            shadowLayer.shadowRadius = 2
            
            layer.insertSublayer(shadowLayer, at: 0)
        }
    }
}

class ThemeButtonBaseView: UIView {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.applyViewShadow(shadowOffset: CGSize.zero, shadowColor: .ColorTextColor, shadowOpacity: 0.5)
    }
}

class TitleGreyLable: UILabel {
    
    override func awakeFromNib() {
        super.awakeFromNib()        
        self.applyStyle(titleFont: .applyFont(fontType: .FontRegular, fontSize: kFontSize12), titleColor: .ColorTextColor)
    }
}

class labelSpecing: UILabel {
    override func awakeFromNib() {
          if let labelText = text, labelText.count > 0 {
            let attributedString = NSMutableAttributedString(string: labelText)
            attributedString.addAttribute(NSAttributedString.Key.kern, value: 2.0, range: NSRange(location: 0, length: attributedString.length - 1))
            attributedText = attributedString
          }
    }
}
class ButtonWordSpecing: UIButton {
    override func awakeFromNib() {
        self.clipsToBounds = true
        if let labelText = self.titleLabel?.text {
            let attributedString = NSMutableAttributedString(string: labelText)
            attributedString.addAttribute(NSAttributedString.Key.kern, value: 2.0, range: NSRange(location: 0, length: attributedString.length - 1))
            self.setAttributedTitle(attributedString, for: .normal)
            
          }
    }
}
class DRAW: UIView {

    override func draw(_ rect: CGRect) {

        var path = UIBezierPath()
        path = UIBezierPath(ovalIn: CGRect(x: 2, y: 0, width: 292, height: 292))
        UIColor.red.setStroke()
        UIColor.clear.setFill()
        path.lineWidth = 2
        path.stroke()
        path.fill()


    }

}
class CustomSlide: UISlider {

     @IBInspectable var trackHeight: CGFloat = 10

    override func trackRect(forBounds bounds: CGRect) -> CGRect {
         //set your bounds here
        return CGRect(origin: bounds.origin, size: CGSize(width: bounds.width, height: trackHeight))



       }
}


class pointAnnotation: MKPointAnnotation {   
    var pinCustomImageName:String!
}

//MARK:- Clouser for All events and actions

var AssociatedObjectHandle: UInt8 = 0

class ClosureSleeve {
    let closure: () -> ()
    
    init(attachTo: AnyObject, closure: @escaping () -> ()) {
        self.closure = closure
        objc_setAssociatedObject(attachTo, &AssociatedObjectHandle, self, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
    }
    
    @objc func invoke() {
        closure()
    }
}


// MARK:- attributted lable
//class LabelSignUp : UILabel{
//
//    override func awakeFromNib() {
//        self.isUserInteractionEnabled = true
//
//        let tap = UITapGestureRecognizer(target: self, action: #selector(labelTapped(sender:)))
//        self.addGestureRecognizer(tap)
//    }
//
//    @objc  func labelTapped(sender : UITapGestureRecognizer){
//        let text = (self.text)!
//        let signupRange : NSRange = (text as NSString).range(of: "SIGN UP")
//        let termsRange = (text as NSString).range(of: "Terms of Services")
//        let privacyRange = (text as NSString).range(of: "Privacy Policy")
//
//        if sender.didTapAttributedTextInLabel(label: self, inRange: signupRange) {
//
//            //            if let vcTop = UIApplication.topViewController() {
//            //
//            //                let signupVC = SignUpVC.instantiate(fromAppStoryboard: UIStoryboard.Convenient.kLoginStoryboard)
//            //                vcTop.navigationController?.pushViewController(signupVC, animated: true)
//            //            }
//        }
//        else if sender.didTapAttributedTextInLabel(label: self, inRange: termsRange) {
//
//            //            if let vcTop = UIApplication.topViewController() {
//
//            //                let termsView = TermsVC.instantiate(fromAppStoryboard: UIStoryboard.Convenient.kLoginStoryboard)
//            //                termsView.isURL = URLlist.terms.rawValue
//            //                termsView.isFrom = "Terms & Conditions"
//            //                vcTop.navigationController?.pushViewController(termsView, animated: true)
//            //            }
//        }
//        else if sender.didTapAttributedTextInLabel(label: self, inRange: privacyRange) {
//
//            //            if let vcTop = UIApplication.topViewController() {
//
//            //                let termsView = TermsVC.instantiate(fromAppStoryboard: UIStoryboard.Convenient.kLoginStoryboard)
//            //                termsView.isURL = URLlist.terms.rawValue
//            //                termsView.isFrom = "Privacy Policy"
//            //                vcTop.navigationController?.pushViewController(termsView, animated: true)
//            //            }
//        }
//    }
//}
class IntrinsicTableView: UITableView {
    override var contentSize:CGSize {
        didSet {
            self.invalidateIntrinsicContentSize()
        }
    }
    
    override var intrinsicContentSize: CGSize{
        self.layoutIfNeeded()
        return CGSize(width: UIView.noIntrinsicMetric, height: contentSize.height)
    }
}

class IntrinsicCollectionView: UICollectionView {
    override var contentSize:CGSize {
        didSet {
            self.invalidateIntrinsicContentSize()
        }
    }
    
    override var intrinsicContentSize: CGSize{
        self.layoutIfNeeded()
        return CGSize(width: UIView.noIntrinsicMetric, height: contentSize.height)
    }
}

//MARK:- iCloud Class

class iCloudManager : NSObject , UIDocumentPickerDelegate{
    
    static let shared : iCloudManager = iCloudManager()
    let containerUrl = FileManager.default.url(forUbiquityContainerIdentifier: nil)?.appendingPathComponent("Documents", isDirectory: true)
    var documentPicker = UIDocumentPickerViewController(documentTypes: [(kUTTypePDF as String),(kUTTypePresentation as String)], in: UIDocumentPickerMode.import)
    var completion :((JSON?) -> Void)?
    
    override init(){
        super.init()
        // check for container existence
    }
    
    func save(url:String){
        let localDocumentsURL = URL(string: url)
        do{
            let data = try Data(contentsOf: localDocumentsURL!)
            if let iCloudDocumentsURL = containerUrl{
                let _:NSError?
                var isDir:ObjCBool = false
                
                if !(FileManager.default.fileExists(atPath: iCloudDocumentsURL.path, isDirectory: &isDir)) {
                    try  FileManager.default.createDirectory(at: iCloudDocumentsURL, withIntermediateDirectories: true, attributes: nil)
                }
                let docURL = iCloudDocumentsURL.appendingPathComponent(localDocumentsURL!.lastPathComponent)
                try data.write(to: docURL)
               // GFunction.shared.showSnackBar("Document saved to your iCloud")
            }
            else {
               // GFunction.shared.showSnackBar("Open the Settings app and enter your Apple ID into iCloud settings")
            }
        }
        catch let Error{
            print(Error)
        }
    }
    
    func fileCopy(sourceUrl:URL,fileName:String){
        do{
            if let iCloudDocumentsURL = containerUrl{
                let _:NSError?
                var isDir:ObjCBool = false
                let toURL = iCloudDocumentsURL.appendingPathComponent(fileName)
                if !(FileManager.default.fileExists(atPath: iCloudDocumentsURL.path, isDirectory: &isDir)) {
                    try  FileManager.default.createDirectory(at: iCloudDocumentsURL, withIntermediateDirectories: true, attributes: nil)
                }
                try FileManager.default.copyItem(at: sourceUrl, to: toURL)
            }
        }
        catch let Error{
            print(Error.localizedDescription)
        }
    }
    
    func fileRemove(url:URL){
        do{
            try FileManager.default.removeItem(at: url)
        }
        catch let Error{
            print(Error.localizedDescription)
        }
    }
    
    func fileExits(url:String) -> Bool{
        let container = containerUrl!
        let docURL = container.appendingPathComponent((URL(string: url)?.lastPathComponent)!)
        return FileManager.default.fileExists(atPath:docURL.path)
    }
    
    func openDocumentPicker(this:UIViewController , type : [String] = [(kUTTypePDF as String),(kUTTypePresentation as String)],completion :((JSON?) -> Void)?){
        self.documentPicker = UIDocumentPickerViewController(documentTypes: type, in: UIDocumentPickerMode.import)
        self.completion = completion
        self.documentPicker.delegate = self
        this.present(documentPicker, animated: true, completion: nil)
    }
    
    
    //MARK:- UIDocumentPicker Delegate Method
    
    func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController){
        documentPicker.dismiss(animated: true, completion: nil)
    }
    
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentAt url: URL){
        if completion != nil{
            completion!(JSON(["url":url.absoluteString]))
        }
    }
    
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]){
        if completion != nil{
            completion!(JSON(["url":urls.first?.absoluteString]))
        }
    }
    
    //------------------------------------------------------
    
    func getFileType(type:String) -> UIImage?{
        switch type{
        case "pdf":
            return #imageLiteral(resourceName: "Docpdficon")
            
        case "doc":
            return #imageLiteral(resourceName: "DocwordIcon")
            
        case "docx":
            return #imageLiteral(resourceName: "DocwordIcon")
            
        case "ppt":
            return #imageLiteral(resourceName: "DocPPTIcon")
            
        case "pptx":
            return #imageLiteral(resourceName: "DocPPTIcon")
            
        case "xls":
            return #imageLiteral(resourceName: "DocXLSIcon")
            
        case "xlsx":
            return #imageLiteral(resourceName: "DocXLSIcon")
            
        case "txt":
            return #imageLiteral(resourceName: "DoctxtIcon")
            
        default :
            return nil
        }
    }
}

class ViewShadowBlack: UIView {
    override func layoutSubviews() {
        self.layer.cornerRadius     = 5.0
        self.layer.shadowColor      = UIColor.ColorTextColor.cgColor
        self.layer.shadowOffset     = CGSize(width: 0.0, height: 0.0)
        self.layer.shadowOpacity    = 0.2
        self.layer.shadowRadius     = 3.0
    }
}

class RoundedThemeButtons: UIButton {
    
    private var shadowLayer: CAShapeLayer!
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.applyStyle(titleFont: .applyFont(fontType: .FontRegular, fontSize: kFontSize16), titleColor: .ColorTextColor)
        
        if shadowLayer == nil {
            shadowLayer = CAShapeLayer()
            shadowLayer.path = UIBezierPath(roundedRect: bounds, cornerRadius: self.frame.height / 2).cgPath
            shadowLayer.fillColor = kTHEMECOLOR.cgColor
            
            shadowLayer.shadowColor = UIColor.colorFromHexWithAlpha(hex: 0x000000, opacity: 0.5).cgColor
            shadowLayer.shadowPath = shadowLayer.path
            shadowLayer.shadowOffset = CGSize.zero
            shadowLayer.shadowOpacity = 0.5
            shadowLayer.shadowRadius = 2
            
            layer.insertSublayer(shadowLayer, at: 0)
        }
    }
    
    //    override func awakeFromNib() {
    //        self.applyStyle(titleFont: UIFont.applyFont(fontType: .FontSemiBold, fontSize: kFontSize12))
    //        self.layoutIfNeeded()
    //        self.clipsToBounds = true
    //        if (self.constraints.filter{$0.firstAttribute == .height}).first != nil{
    //            //            cons.constant = 50 * kHeightMultiplier
    //        }
    //        if let label = self.titleLabel {
    //            label.textAlignment = .center
    //            self.titleLabel?.lineBreakMode = .byWordWrapping
    //        }
    //    }
    //
    //    override func layoutSubviews() {
    //        super.layoutSubviews()
    //        self.layer.cornerRadius     = (self.frame.height / 2)
    //    }
}

class sepratorView: UIView {
    override func layoutSubviews() {
        super.layoutSubviews()
        self.backgroundColor = UIColor.colorFromHexWithAlpha(hex: 0x707070, opacity: 0.15)
    }
}

class RoundImage : UIImageView{
    override func layoutSubviews() {
        super.layoutSubviews()
        self.layer.cornerRadius     = (self.frame.height / 2)
        self.clipsToBounds = true
    }
}

class RoundedEdgeButtons: UIButton {
    override func awakeFromNib() {
        self.layoutIfNeeded()
        self.clipsToBounds = true
        if let label = self.titleLabel {
            label.textAlignment = .center
            self.titleLabel?.lineBreakMode = .byWordWrapping
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.layer.cornerRadius     = (self.frame.height / 2)
    }
}

class nextPreviousView : UIScrollView {
    override func awakeFromNib() {
        
    }
}
class UINavigationBarGradientView: UIView {

    enum Point {
        case topRight, topLeft
        case bottomRight, bottomLeft
        case custom(point: CGPoint)

        var point: CGPoint {
            switch self {
                case .topRight: return CGPoint(x: 1, y: 0)
                case .topLeft: return CGPoint(x: 0, y: 0)
                case .bottomRight: return CGPoint(x: 1, y: 1)
                case .bottomLeft: return CGPoint(x: 0, y: 1)
                case .custom(let point): return point
            }
        }
    }

    private weak var gradientLayer: CAGradientLayer!

    convenience init(colors: [UIColor], startPoint: Point = .topLeft,
                     endPoint: Point = .bottomLeft, locations: [NSNumber] = [0, 1]) {
        self.init(frame: .zero)
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = frame
        layer.addSublayer(gradientLayer)
        self.gradientLayer = gradientLayer
        set(colors: colors, startPoint: startPoint, endPoint: endPoint, locations: locations)
        backgroundColor = .clear
    }

    func set(colors: [UIColor], startPoint: Point = .topLeft,
             endPoint: Point = .bottomLeft, locations: [NSNumber] = [0, 1]) {
        gradientLayer.colors = colors.map { $0.cgColor }
        gradientLayer.startPoint = startPoint.point
        gradientLayer.endPoint = endPoint.point
        gradientLayer.locations = locations
    }

    func setupConstraints() {
        guard let parentView = superview else { return }
        translatesAutoresizingMaskIntoConstraints = false
        topAnchor.constraint(equalTo: parentView.topAnchor).isActive = true
        leftAnchor.constraint(equalTo: parentView.leftAnchor).isActive = true
        parentView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        parentView.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        guard let gradientLayer = gradientLayer else { return }
        gradientLayer.frame = frame
        superview?.addSubview(self)
    }
}
