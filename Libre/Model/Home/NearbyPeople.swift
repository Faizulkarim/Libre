//
//  UserModel.swift
//  Libre
//
//  Created by Faizul Karim on 22/8/21.
//
import UIKit

class NearbyPeopleModel: mappable {
    

    var countryCode : String!
    var deviceToken : String!
    var userId : Int!
    var isLogin : Int!
    var isOtpVerified : Int!
    var latitude : String!
    var longitude : String!
    var mobileNumber : String!
    var name : String!
    var otp : Int!
    var profileImage : String!
    var profileStatus : Int!
    var professon : String!
    var prefarance :String!
    var backgrounImage : String!
    var aboutYou : String!
    var distance : Int!



    /**
     * Instantiate the instance using the passed json values to set the properties values
     */
    required init(fromJson json: JSON) {
        
        if json.isEmpty{
            return
        }
        distance = json["distance"].intValue
        aboutYou = json["aboutYou"].stringValue
        backgrounImage = json["backgroundImageUrl"].stringValue
        prefarance = json["whatYouLove"].stringValue
        countryCode = json["country_code"].stringValue
        deviceToken = json["device_token"].stringValue
        userId = json["userId"].intValue
        isLogin = json["is_login"].intValue
        isOtpVerified = json["is_otp_verified"].intValue
        latitude = json["latitude"].stringValue

        longitude = json["longitude"].stringValue
        mobileNumber = json["phoneNumber"].stringValue
        name = json["name"].stringValue
        profileImage = json["profileImageUrl"].stringValue
        profileStatus = json["profile_status"].int
        professon  = json["profession"].stringValue

    }

    /**
     * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
     */
    func toDictionary() -> [String:Any]
    {
        var dictionary = [String:Any]()
        if distance != nil {
            dictionary["distance"] = distance
        }
        if aboutYou != nil {
            dictionary["aboutYou"] = aboutYou
        }
        if prefarance != nil {
            dictionary["whatYouLove"] = prefarance
        }
        if backgrounImage != nil {
            dictionary["backgroundImageUrl"] = backgrounImage
        }
        if professon != nil{
            dictionary["profession"] = professon
        }
        if userId != nil {
            dictionary["userId"] = userId
        }

        if countryCode != nil{
            dictionary["country_code"] = countryCode
        }
        if deviceToken != nil{
            dictionary["device_token"] = deviceToken
        }

        if isLogin != nil{
            dictionary["is_login"] = isLogin
        }
        if isOtpVerified != nil{
            dictionary["is_otp_verified"] = isOtpVerified
        }

        if latitude != nil{
            dictionary["latitude"] = latitude
        }

        if longitude != nil{
            dictionary["longitude"] = longitude
        }
        
        if mobileNumber != nil{
            dictionary["phoneNumber"] = mobileNumber
        }
        if name != nil{
            dictionary["name"] = name
        }

        if otp != nil{
            dictionary["otp"] = otp
        }
        if profileImage != nil{
            dictionary["profileImageUrl"] = profileImage
        }
        if profileStatus != nil {
            dictionary["profile_status"] = profileStatus
        }
    
        return dictionary
    }
 }

