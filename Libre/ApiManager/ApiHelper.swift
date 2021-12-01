//
//  ApiHelper.swift
//  NewApiManager
//
//  Created by Hyperlink on 15/06/19.
//  Copyright © 2019 Hyperlink. All rights reserved.
//

import UIKit

typealias responseData = (JSON,Int,ApiKeys.ApiStatusCode)

protocol mappable {
    init(fromJson json : JSON)
}

struct DataResult {
    var data : JSON = JSON.null
    var httpCode : Int = NSNotFound
    var apiCode : ApiKeys.ApiStatusCode = .invalidOrFail
    var message : String = ""
    var success : Bool = false
    var response : JSON = JSON.null
}

struct DataResultModel<T : mappable> {
    var data : T = T.init(fromJson: JSON.null)
    var httpCode : Int = NSNotFound
    var apiCode : ApiKeys.ApiStatusCode = .invalidOrFail
    var message : String = ""
    var success : Bool = false
    var response : JSON = JSON.null
}

class ModelList<T : mappable> : mappable{
    
    var result : [T] = []
    
    required init(fromJson json: JSON) {
        result = ModelList.createModelArray(model: T.self, json: json.arrayValue)
    }
    
    class func createModelArray<T : mappable>(model : T.Type , json : [JSON]) -> [T] {
        return json.map{ model.init(fromJson : $0)  }
    }
}

struct ApiCustomError : Error {
    static var sessionExpire = NSError(domain:"", code:401, userInfo:[ NSLocalizedDescriptionKey: "User Session Expire"]) as Error
    static var invalidData = NSError(domain:"", code:401, userInfo:[ NSLocalizedDescriptionKey: "Invalid Data"]) as Error
    
}
