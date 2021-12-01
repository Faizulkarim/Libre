//
//  MoyaHelper.swift
//  NewApiManager
//
//  Created by Hyperlink on 17/06/19.
//  Copyright © 2019 Hyperlink. All rights reserved.
//

import UIKit
@_exported import QorumLogs
@_exported import Moya
@_exported import Alamofire
@_exported import QorumLogs

/// Api Environment
enum APIEnvironment {
    case live
    case local
    case localhost
}

/// NetworkManager
struct NetworkManager  {
    let provider = MoyaProvider<ApiManager>(plugins: [NetworkLoggerPlugin(verbose: true)])
    static let environment : APIEnvironment = .localhost

}

/// Moya String Helper Extenstions
extension String: Moya.ParameterEncoding {
    
    public func encode(_ urlRequest: URLRequestConvertible, with parameters: Parameters?) throws -> URLRequest {
        var request = try urlRequest.asURLRequest()
        request.httpBody = data(using: .utf8, allowLossyConversion: false)
        return request
    }
    
//    func encryptData() -> String{
//        return CryptLib().encryptPlainText(with: self, key: ApiKeys.encrypt(.secretKey).value, iv: ApiKeys.encrypt(.iv).value)
//    }
//
//    func decryptData() -> String {
//        return JSON(CryptLib().decryptCipherText(with: self, key: ApiKeys.encrypt(.secretKey).value, iv: ApiKeys.encrypt(.iv).value) as Any).stringValue
//    }
    
//    func createSixteenBitIV() -> String{
//        let strIV = ApiKeys.encrypt(.iv).value.data(using: String.Encoding.utf8)
//
//        //    let strIVBytes:[UInt8] = Array(UnsafeBufferPointer(start: UnsafePointer<UInt8>(strIV!.bytes), count: 16))
//        let strIVBytes:[UInt8] = strIV!.withUnsafeBytes {
//            [UInt8](UnsafeBufferPointer(start: $0, count: 16))
//        }
//        return String(bytes: strIVBytes, encoding: String.Encoding.utf8)!
//    }
    
    func convertToDictionary() -> [String: Any]? {
        if let data = self.data(using: .utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
            } catch {
                print(error.localizedDescription)
            }
        }
        return nil
    }
    
    
    var urlEscaped: String {
        return addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
    }
    
    var utf8Encoded: Data {
        return data(using: .utf8)!
    }
}

/// Response
extension Response {
    
    public func filterApiStatusCodes<R: RangeExpression>(statusCodes: R) throws -> Response where R.Bound == Int {
        guard statusCodes.contains(statusCode) else {
            throw MoyaError.statusCode(self)
        }
        return self
    }
}

/// WebService
class WebService {
    // session manager
    static func manager() -> Alamofire.SessionManager {
        let configuration = URLSessionConfiguration.default
        configuration.httpAdditionalHeaders = Alamofire.SessionManager.defaultHTTPHeaders
        configuration.timeoutIntervalForRequest = 60 // as seconds, you can set your request timeout
        configuration.timeoutIntervalForResource = 60 // as seconds, you can set your resource timeout
        let manager = Alamofire.SessionManager(configuration: configuration)
        //        manager.adapter = CustomRequestAdapter()
        
        return manager
    }
        
    // request adpater to add default http header parameter
    private class CustomRequestAdapter: RequestAdapter {
        public func adapt(_ urlRequest: URLRequest) throws -> URLRequest {
            return urlRequest
        }
    }
}

/// ResponseModelType

enum ResponseModelType {
    case dictonary, array
}

/// Helping Methods
extension ApiManager {
    
    func manageDebugRequest(parameters: [String:Any]?) {
        let jsonData = try? JSONSerialization.data(withJSONObject: self.parameters!, options: JSONSerialization.WritingOptions.prettyPrinted)
        let jsonString = String(data: jsonData!, encoding: .utf8)!
        let encryptedData  : String = jsonString
        QLPlusLine()
        QL1("Parameters")
        QL1(JSON(parameters as Any).dictionaryValue)
        print(JSON(parameters as Any).dictionaryValue)
        QL1("")
        print("URL 🔗: ",baseURL.appendingPathComponent(self.path).absoluteString)
        QL1("")
        print("\n  Parameters 📚: ", encryptedData)
        QL1(encryptedData)
        QLPlusLine()
    }
    
    func manageDebugResponse(encryptedString: String, responseDic: JSON) {
        QLPlusLine()
        QL1("")
        print(" Response 🔐",encryptedString)
        QL1("Decrypted Response")
        QL1(responseDic)
        QLPlusLine()
    }
    
    func manageErrors(apiName: String, error: Error, isShowAlert: Bool = false) {
        QL4("Error \(error.localizedDescription) in method \(apiName)")
        if isShowAlert {
            GFunction.shared.showSnackBar(error.localizedDescription)
        }
    }
    
    func addLoader()  {
        GFunction.shared.addLoader()
    }
    
    func removeLoader()  {
        GFunction.shared.removeLoader()
    }
    
    func logout() {
        GFunction.shared.userLogout()
    }
    
    /// Cancel any request
    func cancelRequest(endpoint : ApiEndPoints)  {
        if let task = (self.requests.filter{ $0.endPoint.methodName == endpoint.methodName }).first{
            task.cancellable.cancel()
        }
    }
}
