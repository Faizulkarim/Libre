//
//  prefaranceModel.swift
//  Libre
//
//  Created by Faizul Karim on 30/8/21.
//

import Foundation
import UIKit
import SwiftyJSON

class list: mappable {
    var prefarModel : [prefaranceModel]!
   required  init(fromJson json: JSON){
        if json.isEmpty{
            return
        }
        prefarModel = [prefaranceModel]()
        let prefarArray = json["list"].arrayValue
        for listJson in prefarArray{
            let value = prefaranceModel(fromJson: listJson)
            prefarModel.append(value)
        }
        
    }
    func toDictionary() -> [String:Any]
    {
        var dictionary = [String:Any]()
       if prefarModel != nil{
        var dictionaryElements = [[String:Any]]()
        for listElament in prefarModel {
            dictionaryElements.append(listElament.dictonary())
        }
        dictionary["list"] = dictionaryElements
         }
        
        return dictionary
    }
}

class prefaranceModel: mappable {

    
    var userId : Int!
    var title : String!
    
    required init(fromJson json: JSON) {
        if json.isEmpty {
            return 
        }
        userId = json["userId"].intValue
        title = json["name"].stringValue
    }
    
    func dictonary() -> [String: Any]{
        var dictionary = [String:Any]()
        if userId != nil {
            dictionary["userId"] = userId
        }
        
        if title != nil{
            dictionary["name"] = title
        }
        return dictionary
    }
    
}
