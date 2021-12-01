//
//  GExtension+UIView.swift
//
//
//  Created by Hyperlink on 30/06/18.
//  Copyright © 2018 Hyperlink. All rights reserved.
//

import UIKit
let padding : CGFloat = 15

extension UIView {
    func shake() {
        self.transform = CGAffineTransform(translationX: 20, y: 0)
        UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 0.2, initialSpringVelocity: 1, options: .curveEaseInOut, animations: {
            self.transform = CGAffineTransform.identity
        }, completion: nil)
    }
    func rotate() {
        let rotation : CABasicAnimation = CABasicAnimation(keyPath: "transform.rotation.z")
        rotation.toValue = CGFloat.pi * 2
        rotation.duration = 30
        rotation.isCumulative = true
        rotation.repeatCount = 0
        rotation.isRemovedOnCompletion = false
        self.layer.add(rotation, forKey: "rotationAnimation")
    }
    
    func bounce(completion: @escaping (Bool) -> Void) {
        self.isUserInteractionEnabled = false
        self.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
        
        UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.4, initialSpringVelocity: 0.6, options: .allowUserInteraction, animations: { [weak self] in
            
            self?.transform = .identity
            
        }) { (complete : Bool) in
            self.isUserInteractionEnabled = true
            completion(complete)
        }
    }
    func pulseAnimation(){
        let pulseAnimation = CABasicAnimation(keyPath: "transform.scale")
        pulseAnimation.duration = 1
        pulseAnimation.fromValue = 0.7
        pulseAnimation.toValue = 1
        pulseAnimation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        pulseAnimation.autoreverses = true
        pulseAnimation.repeatCount = .greatestFiniteMagnitude
        layer.add(pulseAnimation, forKey: "scale")
    }
    fileprivate typealias ReturnGestureAction = (() -> Void)?
    func applyViewShadow(shadowOffset : CGSize? , shadowColor : UIColor?, shadowOpacity : Float?) {
        
        if shadowOffset != nil {
            self.layer.shadowOffset = shadowOffset!
        }
        else {
            self.layer.shadowOffset = CGSize(width: 0, height: 0)
        }
        
        if shadowColor != nil {
            self.layer.shadowColor = shadowColor?.cgColor
        } else {
            self.layer.shadowColor = UIColor.clear.cgColor
        }
        
        //For button border width
        if shadowOpacity != nil {
            self.layer.shadowOpacity = shadowOpacity!
        }
        else {
            self.layer.shadowOpacity = 0
        }
        
        self.layer.masksToBounds = false
    }
    fileprivate struct AssociatedObjectKeys {
        static var tapGestureRecognizer = "MediaViewerAssociatedObjectKey_mediaViewer1"
    }
    fileprivate var tapGestureRecognizerAction: ReturnGestureAction? {
        set {
            if let newValue = newValue {
                // Computed properties get stored as associated objects
                objc_setAssociatedObject(self, &AssociatedObjectKeys.tapGestureRecognizer, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
            }
        }
        get {
            let tapGestureRecognizerActionInstance = objc_getAssociatedObject(self, &AssociatedObjectKeys.tapGestureRecognizer) as? ReturnGestureAction
            return tapGestureRecognizerActionInstance
        }
    }
    
    func handleTapToAction(action: (() -> Void)?) {
        let gesture = UITapGestureRecognizer(target: self, action: #selector(self.tapGestureHanldeAction))
        self.tapGestureRecognizerAction = action
        self.isUserInteractionEnabled = true
        self.addGestureRecognizer(gesture)
    }

    @objc func tapGestureHanldeAction() {
        if let action = self.tapGestureRecognizerAction {
            action?()
        } else {
//            print("no action")
        }
    }
    
//    var isRoundImage : Bool? {
//        get {
//            return objc_getAssociatedObject(self, &kRatio) as? Bool
//        }
//        set {
//            objc_setAssociatedObject(self, &kRatio, newValue, .OBJC_ASSOCIATION_RETAIN)
//        }
//    }
    
//    public func draw(_ layer: CALayer, in ctx: CGContext) {
//        if let _ = self.isRoundImage {
//            self.layer.cornerRadius = self.frame.size.width / 2;
//            self.clipsToBounds = true;
//            self.setNeedsDisplay()
//            self.layoutIfNeeded()
//        }
//    }
    
    func roundCornersWithShdow(corners: UIRectCorner, radius: CGFloat, shdowColor: UIColor) {
        
        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let shadowLayer = CAShapeLayer()
        shadowLayer.path = path.cgPath
        
        shadowLayer.path = path.cgPath
        shadowLayer.fillColor = UIColor.white.cgColor
        shadowLayer.shadowColor = shdowColor.cgColor
        shadowLayer.shadowPath = shadowLayer.path
        shadowLayer.shadowOffset = CGSize(width: 0.0, height: 1.0)
        shadowLayer.shadowOpacity = 0.3
        shadowLayer.shadowRadius = 3
        
        layer.insertSublayer(shadowLayer, at: 0)
        
        //        layer.mask = mask
    }
    
    func addBlurEffect(){
        
        let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.regular)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = self.bounds
        
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight] // for supporting device rotation
        self.addSubview(blurEffectView)
        
    }
    
    func addDashedBorder(_ color : UIColor = UIColor.ColorRed) {
        
        let color = color.cgColor
        
        let shapeLayer:CAShapeLayer = CAShapeLayer()
        let frameSize = self.frame.size
        let shapeRect = CGRect(x: 0, y: 0, width: frameSize.width, height: frameSize.height)
        let cornerRadius = self.layer.cornerRadius
        
        
        let path: CGMutablePath = CGMutablePath()
        //drawing a border around a view
        path.move(to: CGPoint(x: 0, y: frameSize.height - cornerRadius), transform: .identity)
        path.addLine(to: CGPoint(x: 0, y: cornerRadius), transform: .identity)
        path.addArc(center: CGPoint(x: cornerRadius, y: cornerRadius), radius: cornerRadius, startAngle: .pi, endAngle: -(.pi / 2), clockwise: false, transform: .identity)
        path.addLine(to: CGPoint(x: frameSize.width - cornerRadius, y: 0), transform: .identity)
        path.addArc(center: CGPoint(x: frameSize.width - cornerRadius, y: cornerRadius), radius: cornerRadius, startAngle: -(.pi / 2), endAngle: 0, clockwise: false, transform: .identity)
        path.addLine(to: CGPoint(x: frameSize.width, y: frameSize.height - cornerRadius), transform: .identity)
        path.addArc(center: CGPoint(x: frameSize.width - cornerRadius, y: frame.size.height - cornerRadius), radius: cornerRadius, startAngle: 0, endAngle: (.pi / 2), clockwise: false, transform: .identity)
        path.addLine(to: CGPoint(x: cornerRadius, y: frameSize.height), transform: .identity)
        path.addArc(center: CGPoint(x: cornerRadius, y: frameSize.height - cornerRadius), radius: cornerRadius, startAngle:(.pi / 2), endAngle: .pi, clockwise: false, transform: .identity)
        //path is set as the _shapeLayer object's path
        shapeLayer.path = path
        
        
        shapeLayer.bounds = shapeRect
        shapeLayer.position = CGPoint(x: frameSize.width/2, y: frameSize.height/2)
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.strokeColor = color
        shapeLayer.lineWidth = 2
        shapeLayer.masksToBounds = false
        shapeLayer.setValue(Int(false), forKey: "isCircle")
        //        shapeLayer.cornerRadius = frameSize.width / 2
        shapeLayer.lineJoin = CAShapeLayerLineJoin.round
        shapeLayer.lineDashPattern = [2,3]
        shapeLayer.lineCap = CAShapeLayerLineCap.round
        //        shapeLayer.path = UIBezierPath(roundedRect: shapeRect, cornerRadius: 5).cgPath
        
        self.layer.addSublayer(shapeLayer)
        
    }
    
    var parentViewController: UIViewController? {
        var parentResponder: UIResponder? = self
        while parentResponder != nil {
            // swiftlint:disable:next force_unwrapping
            parentResponder = parentResponder!.next
            if let viewController = parentResponder as? UIViewController {
                return viewController
            }
        }
        return nil
    }
    
    //Bottom Line
    func addBottomBorderWithColor(color: UIColor,origin : CGPoint, width : CGFloat , height : CGFloat) -> CALayer {
        
        let border = CALayer()
        border.backgroundColor = color.cgColor
        border.frame = CGRect(x:origin.x, y: self.frame.size.height - height, width:width, height:height)
        self.layer.addSublayer(border)
        return border
    }
    func roundCorners(corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        layer.mask = mask
    }
    
    func curruntFirstResponder() -> UIResponder? {
        
        if self.isFirstResponder {
            return self
        }
        
        for view in self.subviews {
            if let responder  = view.curruntFirstResponder() {
                return responder
            }
        }
        return nil;
    }
    func curveToPertiCorners(cornerRedius: CGSize , roundCorners: UIRectCorner) {
        let path = UIBezierPath(roundedRect: self.bounds,
                                byRoundingCorners: roundCorners,
                                cornerRadii: cornerRedius)
        let maskLayer = CAShapeLayer()
        maskLayer.frame = self.bounds
        maskLayer.path = path.cgPath
        self.layer.mask = maskLayer
        
    }

    func applyCornerRadius(cornerRadius : CGFloat? = nil, borderColor : UIColor? = nil , borderWidth : CGFloat? = nil) {
        
        //For button corner radius
        if cornerRadius != nil {
            self.layer.cornerRadius = cornerRadius!
        }
        /*else {
         self.layer.cornerRadius = 0
         }*/
        
        //For Border color
        if borderColor != nil {
            self.layer.borderColor = borderColor?.cgColor
        } else {
            self.layer.borderColor = UIColor.clear.cgColor
        }
        
        //For button border width
        if borderWidth != nil {
            self.layer.borderWidth = borderWidth!
        }
        else {
            self.layer.borderWidth = 0
        }
    }
    func applyViewShadowWithCornerRadius(shadowOffset : CGSize? = nil, shadowColor : UIColor?, shadowOpacity : Float?, cornerRadius : CGFloat = 0.0, shadowRadius : CGFloat = 5.0) {
        
        self.layer.cornerRadius = cornerRadius
        self.layer.shadowRadius = shadowRadius
        
        
        if shadowOffset != nil {
            self.layer.shadowOffset = shadowOffset!
        }
        else {
            self.layer.shadowOffset = CGSize(width: 1.0, height: 1.0)
        }
        
        if shadowColor != nil {
            self.layer.shadowColor = shadowColor?.cgColor
        } else {
            self.layer.shadowColor = UIColor.clear.cgColor
        }
        
        //For button border width
        if shadowOpacity != nil {
            self.layer.shadowOpacity = shadowOpacity!
        }
        else {
            self.layer.shadowOpacity = 0
        }
        
        self.layer.masksToBounds = false
    }
    class func fromNib<T : UIView>() -> T {
        return Bundle.main.loadNibNamed(String(describing: T.self), owner: nil, options: nil)![0] as! T
    }
    
        func applyGradient(colours: [UIColor]) -> CAGradientLayer {
            self.clipsToBounds = true
            self.applyCornerRadius(cornerRadius: 5, borderColor: nil, borderWidth: nil)
            return self.applyGradient(colours: colours, locations: nil)
        }
        func applyGradient(colours: [UIColor], locations: [NSNumber]?) -> CAGradientLayer {
            let gradient: CAGradientLayer = CAGradientLayer()
            gradient.frame = self.bounds
            gradient.colors = colours.map { $0.cgColor }
            gradient.locations = locations
            self.layer.insertSublayer(gradient, at: 0)
            return gradient
        }
    

    
    func applyGradientBackground(colors: [UIColor],
                               startPoint: UINavigationBarGradientView.Point = .topLeft,
                               endPoint: UINavigationBarGradientView.Point = .bottomLeft,
                               locations: [NSNumber] = [0, 1]) {
        guard let backgroundView = value(forKey: "backgroundView") as? UIView else { return }
        guard let gradientView = backgroundView.subviews.first(where: { $0 is UINavigationBarGradientView }) as? UINavigationBarGradientView else {
            let gradientView = UINavigationBarGradientView(colors: colors, startPoint: startPoint,
                                                           endPoint: endPoint, locations: locations)
            backgroundView.addSubview(gradientView)
            gradientView.setupConstraints()
            return
        }
        gradientView.set(colors: colors, startPoint: startPoint, endPoint: endPoint, locations: locations)
    }

    
    
}


