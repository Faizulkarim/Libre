//
//  GExtension+UIImageView.swift
//  
//
//  Created by Hyperlink on 05/07/18.
//  Copyright © 2018 Hyperlink. All rights reserved.
//

import UIKit
import ImageIO
@_exported import SDWebImage
@_exported import SimpleImageViewer

var imageCache = NSCache<NSString,UIImage>()

extension UIImageView {
    func setImageWithDownload(_ url : URL, withIndicator isIndicator: Bool = true) {
        self.sd_imageTransition = .fade
        self.sd_imageIndicator = SDWebImageActivityIndicator.gray
        self.sd_setImage(with: url, completed: nil)
    }
    func downloadImage(_ url : String, withIndicator isIndicator: Bool = true,completion:@escaping (Bool,UIImage)->()) {
        guard let imageUrl = URL(string: url) else{return}
        if let cachedImage = imageCache.object(forKey: url as NSString){
            self.image = cachedImage
            completion(true,cachedImage)
        }else{
            self.image = nil
            DispatchQueue(label: url, qos: .background, attributes: .concurrent, autoreleaseFrequency: .inherit, target: nil).async {
                URLSession.shared.dataTask(with: imageUrl, completionHandler: { (data, response, error) in
                    guard error  == nil else{return}
                    guard let tempData = data else{return}
                    if let image = UIImage(data: tempData){
                        DispatchQueue.main.async {
                            self.image = image
                            completion(false,image)
                        }
                        imageCache.setObject(image, forKey: url as NSString)
                    }
                }).resume()
            }
        }
    }
    
    
    func cancelCurrentImageLoad() {
        self.sd_cancelCurrentImageLoad()
    }
    
    func setGif(_ name : String) {
        let path: String? = Bundle.main.path(forResource: name, ofType: "gif")
        let data = NSData(contentsOfFile: path!)
        self.image = UIImage.sd_image(withGIFData: data! as Data)
    }
    
    func tapToZoom(){
        /*if let image = self.image , UIImage(cgImage: image.cgImage!) != nil{
         return
         }*/
        self.handleTapToAction {
            self.zoomImage()
        }
    }
    
    func zoomImage() {
        if let _ = self.image{
            let configuration = ImageViewerConfiguration { config in
                config.imageView = self
            }
            let imageViewerController = ImageViewerController(configuration: configuration)
            // Present your controller.
            UIApplication.topViewController()?.present(imageViewerController, animated: true, completion: nil)
        }
    }
    
}

class ImgViewDottedHorizontal: UIImageView {
    
    override func awakeFromNib() {
        self.layoutIfNeeded()
        let path: UIBezierPath = UIBezierPath()
        path.move(to: CGPoint(x: 0, y: 0.0))
        path.addLine(to: CGPoint(x: self.frame.width, y: 0))
        
        //Create a CAShape Layer
        let pathLayer: CAShapeLayer = CAShapeLayer()
        pathLayer.frame = self.bounds
        pathLayer.path = path.cgPath
        pathLayer.strokeColor = self.tintColor.cgColor
        pathLayer.fillColor = nil
        pathLayer.lineWidth = 1
        pathLayer.lineDashPattern = [1,3]
        pathLayer.lineJoin = CAShapeLayerLineJoin.miter
        
        if self.layer.sublayers != nil {
            
            if (self.layer.sublayers?.count)! > 0 {
                
                for layer in self.layer.sublayers! {
                    
                    if layer.isKind(of: CAShapeLayer.self) {
                        
                        self.layer.replaceSublayer(layer, with: pathLayer)
                        
                    }
                    
                }
                
            }
            
        }
        
        self.layoutIfNeeded()
        //Add the layer to your view's layer
        self.layer.addSublayer(pathLayer)
        self.layoutIfNeeded()
    }
    
    //--------------------------------------------------------------------------------------
    
    override func layoutSubviews() {
        self.awakeFromNib()
        self.layoutIfNeeded()
    }
}


class ImgViewDottedVerticle: UIImageView {
    
    override func awakeFromNib() {
        self.layoutIfNeeded()
        let path: UIBezierPath = UIBezierPath()
        path.move(to: CGPoint(x: 0, y: 0.0))
        path.addLine(to: CGPoint(x: 0, y: self.frame.height))
        
        //Create a CAShape Layer
        let pathLayer: CAShapeLayer = CAShapeLayer()
        pathLayer.frame = self.bounds
        pathLayer.path = path.cgPath
        pathLayer.strokeColor = self.tintColor.cgColor
        pathLayer.fillColor = nil
        pathLayer.lineWidth = 1
        pathLayer.lineDashPattern = [1,5]
        pathLayer.lineJoin = CAShapeLayerLineJoin.miter
        
        if self.layer.sublayers != nil {
            
            if (self.layer.sublayers?.count)! > 0 {
                
                for layer in self.layer.sublayers! {
                    
                    if layer.isKind(of: CAShapeLayer.self) {
                        
                        self.layer.replaceSublayer(layer, with: pathLayer)
                        
                    }
                }
            }
        }
        
        self.layoutIfNeeded()
        //Add the layer to your view's layer
        self.layer.addSublayer(pathLayer)
        self.layoutIfNeeded()
    }
    
    //--------------------------------------------------------------------------------------
    
    override func layoutSubviews() {
        self.awakeFromNib()
        self.layoutIfNeeded()
    }
}

