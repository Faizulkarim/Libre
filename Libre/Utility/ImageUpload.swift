//
//  ImageUpload.swift
//  Libre
//
//  Created by Faizul Karim on 26/8/21.
//



import UIKit


 
import AWSS3
import Alamofire

enum S3Bucket : String {
    case kAWSBucket                            = "minnercirclestorage"
    case kAWSAccessKeyId                       = "AKIAVVEWDU7JYRU4EMKQ"
    case kAWSSecretKey                         = "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"
    case kAWSPath                              = "https://minnercirclestorage.s3.us-east-2.amazonaws.com/"
    case kAWSBasePath                          = "reelvolution/"
    case kAWSUserPath
    case kAWSProductPath
    case kAWSMediaPath
    case kAWSMediaThumbPath
    
    static func getPath(key : S3Bucket) -> String? {
        if key == S3Bucket.kAWSUserPath {
            return "user/"
        }
        else if key == S3Bucket.kAWSProductPath {
            return "reelvolution/product/"
        }
        else if key == S3Bucket.kAWSMediaPath {
            return "reelvolution/media/"
        }
        else if key == S3Bucket.kAWSMediaThumbPath {
            return "reelvolution/media/thumb/"
        }
        else {
            return nil
        }
    }
}

class ImageUpload: NSObject {
    
    static let shared                   : ImageUpload = ImageUpload()
    var completionHandler               : AWSS3TransferUtilityUploadCompletionHandlerBlock?
    var progressBlock                   : AWSS3TransferUtilityProgressBlock?
    
    func uploadImage(showLoader : Bool = true,
                     image : UIImage,
                     mimeType : String,
                     imageType : S3Bucket,
                     strVideoThumb : String? = "",
                     index: Int? = nil,
                     withBlock completion : ((_ fullPath : String? , _ lastPathComponent : String?, _ requestAllHeaderFields : JSON?, _ index: Int?) -> Void)?) {
        
        if showLoader {
            GFunction.shared.addLoader()
        }
        
        DispatchQueue.main.async {
            UIApplication.shared.isNetworkActivityIndicatorVisible = true
        }
        //S3 bucket setup
        
        let credentialsProvider : AWSStaticCredentialsProvider = AWSStaticCredentialsProvider(accessKey: S3Bucket.kAWSAccessKeyId.rawValue, secretKey: S3Bucket.kAWSSecretKey.rawValue)
        
        let configuration : AWSServiceConfiguration = AWSServiceConfiguration(region: AWSRegionType.USEast2, credentialsProvider: credentialsProvider)
        AWSServiceManager.default().defaultServiceConfiguration = configuration
        
        var bodyURL : URL?
        if let url : URL = self.storeDataInDirectory(image, strImageName: strVideoThumb) {
            bodyURL = url
        }
        else {
            return
        }
        
        guard let key = S3Bucket.getPath(key: imageType) else { return }
        let remotePath = key + bodyURL!.lastPathComponent
        
        print(remotePath)
        let transferUtility = AWSS3TransferUtility.default()
        
        
        self.progressBlock = {(task, progress) in
            print(progress)
        }
        
        self.completionHandler = { (task, error) -> Void in
            
            
            DispatchQueue.main.async(execute: {
                if showLoader {
                    GFunction.shared.removeLoader()
                }
                if let error = error {
                    print("Failed with error: \(error)")
                    
                    
                    DispatchQueue.main.async {
                        UIApplication.shared.isNetworkActivityIndicatorVisible = true
                    }
                    
                    if let completion = completion {
                        completion(nil, nil, nil, nil)
                    }
                }
                else{
                    if let completion = completion {
                        completion(S3Bucket.kAWSPath.rawValue + remotePath, bodyURL!.lastPathComponent, JSON(task.request?.allHTTPHeaderFields), index)
                    }
                }
            })
        }
        
        func uploadImage(with data: Data) {
            let expression = AWSS3TransferUtilityUploadExpression()
            expression.setValue("public-read", forRequestHeader: "x-amz-acl")
            expression.setValue("\(image.size.height)", forRequestHeader: "x-amz-meta-height")
            expression.setValue("\(image.size.width)", forRequestHeader: "x-amz-meta-width")
            
            expression.progressBlock = progressBlock
            
            
            print("This is expression \(expression)")
            transferUtility.uploadData(
                data,
                bucket : S3Bucket.kAWSBucket.rawValue,
                key: remotePath,
                contentType: mimeType,
                expression: expression,
                completionHandler: completionHandler).continueWith { (task) -> AnyObject? in
                    if let error = task.error {
                        print("Error: \(error.localizedDescription)")
                    }
                    
                    if let result = task.result {
                        print(result)
                    }
                    
                    return nil;
            }
        }
        
        if let data = image.pngData() {
            uploadImage(with: data)
        }
        
    }
    
    func storeDataInDirectory(_ data : UIImage, strImageName : String? = "") -> URL? {
        
        
        let imgData : Data = data.jpegData(compressionQuality: 0.7)!
        
        
        // *** Get documents directory path *** //
        let paths1 = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let documentsDirectory1 = paths1[0] as String
        
        // *** Append video file name *** //
        
        var name = ""
        
        if let strImageName = strImageName, !strImageName.isEmpty {
            name = strImageName
        } else {
            name = self.getRandomString()
        }
        
        let datapathT = documentsDirectory1.appending("/\(name).jpeg")
        
        let tempURl : URL = URL(fileURLWithPath: datapathT)
        
        //        let urlT = tempURl.absoluteURL
        
        let urlT = tempURl
        // *** Remove video file data to path *** //
        let fileManager = FileManager.default
        
        do {
            try fileManager.removeItem(at: urlT)
        }
        catch {
            
            print("No Duplicate video")
        }
        
        // *** Write image file data to path *** //
        //        var strPathForFile = ""
        do {
            try imgData.write(to: urlT)
            return urlT
            
        } catch  {
            print("some error in preview image: ")
            return nil
        }
    }
    
    func getSizeOfData(data : Data) -> String {
        let byteCount = data.count//512_000 // replace with data.count
        let bcf = ByteCountFormatter()
        bcf.allowedUnits = [.useMB] // optional: restricts the units to MB only
        bcf.countStyle = .file
        let string = bcf.string(fromByteCount: Int64(byteCount))
        print(string)
        if byteCount == 0 {
            return "0"
        }
        return string
    }
    
    func getTimeStampFromDate() -> (double : Double,string : String) {
        
        let timeStamp = Date().timeIntervalSince1970
        return (timeStamp,String(format: "%f", timeStamp))
    }
    
    func getRandomString(length: Int = 10) -> String {
        
        let letters : NSString = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        let len = UInt32(letters.length)
        
        var randomString = ""
        
        for _ in 0 ..< length {
            let rand = arc4random_uniform(len)
            var nextChar = letters.character(at: Int(rand))
            randomString += NSString(characters: &nextChar, length: 1) as String
        }
        
        let timeStamp = self.getTimeStampFromDate()
        return randomString + "\(String(format: "%0.0f", timeStamp.double))"
    }
    
    //MARK:- VIDEO UPLOADING
    
//    func uploadVideo(_ showLoader : Bool = true, _ video : URL , _ mimeType : String, _ imageType : S3Bucket, withBlock completion :((String? , String?) -> Void)?) {
//        if showLoader {
//            GFunction.shared.addLoader()
//        }
//
//        DispatchQueue.main.async {
//            UIApplication.shared.isNetworkActivityIndicatorVisible = true
//        }
//        //S3 bucket setup
//
//        let credentialsProvider : AWSStaticCredentialsProvider = AWSStaticCredentialsProvider(accessKey: S3Bucket.kAWSAccessKeyId.rawValue, secretKey: S3Bucket.kAWSSecretKey.rawValue)
//        let configuration : AWSServiceConfiguration = AWSServiceConfiguration(region: AWSRegionType.USEast2, credentialsProvider: credentialsProvider)
//        AWSServiceManager.default().defaultServiceConfiguration = configuration
//
//        var bodyURL : URL?
////        if let url : URL = video {
////            bodyURL = url
////        }
////        else {
////            return
////        }
//
//        let transferManager : AWSS3TransferManager = AWSS3TransferManager.default()
//        let uploadRequest : AWSS3TransferManagerUploadRequest = AWSS3TransferManagerUploadRequest()
//        uploadRequest.bucket = S3Bucket.kAWSBucket.rawValue
//        let videoname = "\(self.getRandomString()).mp4"
//        guard let key = S3Bucket.getPath(key: imageType) else { return }
//        let remotePath = key + videoname
//        uploadRequest.key = remotePath
//        uploadRequest.body = bodyURL!
//        uploadRequest.contentType = mimeType
//        uploadRequest.acl = .publicRead
//
//        transferManager.upload(uploadRequest).continueWith { (task : AWSTask) -> Any? in
//
//            DispatchQueue.main.async {
//                GFunction.shared.addLoader()
//            }
//
//            if task.error == nil {
//                GFunction.shared.removeLoader()
//                debugPrint("Complete task")
//                debugPrint(task.result!)
//                completion!(S3Bucket.kAWSPath.rawValue + remotePath, videoname)
//            }
//            else {
//                GFunction.shared.removeLoader()
//                debugPrint(task.result!)
//                debugPrint(task.error?.localizedDescription)
//                completion!(nil,nil)
//            }
//            return nil
//        }
//
//    }
    
}
extension UIImage {

func resized(withPercentage percentage: CGFloat) -> UIImage? {
    let canvasSize = CGSize(width: size.width * percentage, height: size.height * percentage)
    UIGraphicsBeginImageContextWithOptions(canvasSize, false, scale)
    defer { UIGraphicsEndImageContext() }
    draw(in: CGRect(origin: .zero, size: canvasSize))
    return UIGraphicsGetImageFromCurrentImageContext()
}

func resizedTo1MB() -> UIImage? {
    guard let imageData = self.pngData() else { return nil }

    var resizingImage = self
    var imageSizeKB = Double(imageData.count) / 1000.0 // ! Or devide for 1024 if you need KB but not kB

    while imageSizeKB > 1000 { // ! Or use 1024 if you need KB but not kB
        guard let resizedImage = resizingImage.resized(withPercentage: 0.9),
              let imageData = resizedImage.pngData()
            else { return nil }

        resizingImage = resizedImage
        imageSizeKB = Double(imageData.count) / 1000.0 // ! Or devide for 1024 if you need KB but not kB
    }

    return resizingImage
}
}

