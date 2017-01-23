//
//  UserEntity.swift
//  Loyalty
//
//  Created by striver on 12/13/15.
//  Copyright © 2015 Colectivo Coffee Roasters Inc. All rights reserved.
//

import UIKit

struct PropertyKey {
    static let isloginDone = "loyaltyislogindone"
    static let cardKey = "card"
    static let usernameKey = "username"
    static let nameKey = "name"
    static let surnameKey = "surname"
    static let emailKey = "email"
    static let passwordKey = "password"
    static let confirmpasswordKey = "confirmpassword"
    static let phoneKey = "phone"
    static let zipcodeKey = "zip_code"
    static let addressKey = "address"
    static let birthday_dayKey = "birthday_day"
    static let birthday_monthKey = "birthday_month"
    static let device_tokenKey = "device_token"
    static let accept_pushKey = "accept_push"
    static let accept_emailsKey = "accept_emails"
    
    static let loyalty_pointsKey = "points"
    static let gift_balanceKey = "balance"
    static let store_idKey = "store_id"

    static let idKey = "id"
    static let titleKey = "category"
    static let dateKey = "date"
    static let dateServerKey = "currentDate"
    static let dateStringKey = "dateString"
    static let messageKey = "notification"
    static let isReadKey = "isRead"
    static let dateLastNotificationKey = "datelastnotification"
    
}

struct  PostFieldName {
    static let is_base64 = "is_base64"
    static let f_name = "f_name"
    static let m_id = "m_id"
}
class UserInfo: NSObject, NSCoding {

    var islogindone : Bool = false
    var card : NSString?
    var username : NSString?
    var name : NSString?
    var surname: NSString?
    var email : NSString?
    var password:NSString?
    var phone : NSString?
    var zipcode : NSString?
    var address : NSString?
    var birthday_day : NSString?
    var birthday_month : NSString?
    var device_token   : NSString? = ""
    var accept_push: NSString?
    var accept_emails:NSString?
    var m_id : NSNumber?
    
    
    override init() {
        
    }
    
    init?(islogindone:Bool,
            card: String?,
            username : String?,
            name: String?,
            surname: String?,
            email: String?,
            password: String?,
            phone: String?,
            zipcode: String?,
            address: String?,
            birthday_day: String?,
            birthday_month: String?,
            device_token: String?,
            accept_push: String?,
            accept_emails: String?
        
        )
    {
        // Initialize stored properties.
        self.islogindone = islogindone
        self.card = card
        self.username = username
        self.name = name
        self.surname = surname
        self.email = email
        self.password = password
        self.phone = phone
        self.zipcode = zipcode
        self.address = address
        self.birthday_day = birthday_day
        self.birthday_month = birthday_month
        self.device_token = device_token
        self.accept_push = accept_push
        self.accept_emails = accept_emails

    }
    
    init(_ decoder: Dictionary<String,JSONDecoder>) {
        self.card = decoder[PropertyKey.cardKey]?.string
        self.username = decoder[PropertyKey.usernameKey]?.string
        self.name = decoder[PropertyKey.nameKey]?.string
        self.surname = decoder[PropertyKey.surnameKey]?.string
        self.email = decoder[PropertyKey.emailKey]?.string
        self.password = decoder[PropertyKey.passwordKey]?.string
        self.phone = decoder[PropertyKey.phoneKey]?.string
        self.zipcode = decoder[PropertyKey.zipcodeKey]?.string
        self.address = decoder[PropertyKey.addressKey]?.string
        self.birthday_day = decoder[PropertyKey.birthday_dayKey]?.string
        self.birthday_month = decoder[PropertyKey.birthday_monthKey]?.string
        self.device_token = decoder[PropertyKey.device_tokenKey]?.string
        self.accept_push = decoder[PropertyKey.accept_pushKey]?.string
        self.accept_emails = decoder[PropertyKey.accept_emailsKey]?.string
    }

    
    required convenience init(coder decoder: NSCoder) {
        let islogindone = decoder.decodeBoolForKey(PropertyKey.isloginDone)
        let card = decoder.decodeObjectForKey(PropertyKey.cardKey) as? String
        let username = decoder.decodeObjectForKey(PropertyKey.usernameKey) as? String
        let name = decoder.decodeObjectForKey(PropertyKey.nameKey) as? String
        let surname = decoder.decodeObjectForKey(PropertyKey.surnameKey) as? String
        let email = decoder.decodeObjectForKey(PropertyKey.emailKey) as? String
        let password = decoder.decodeObjectForKey(PropertyKey.passwordKey) as? String
        let phone = decoder.decodeObjectForKey(PropertyKey.phoneKey) as? String
        let zipcode = decoder.decodeObjectForKey(PropertyKey.zipcodeKey) as? String
        let address = decoder.decodeObjectForKey(PropertyKey.addressKey) as? String
        let birthday_day = decoder.decodeObjectForKey(PropertyKey.birthday_dayKey) as? String
        let birthday_month = decoder.decodeObjectForKey(PropertyKey.birthday_monthKey) as? String
        let device_token = decoder.decodeObjectForKey(PropertyKey.device_tokenKey) as? String
        let accept_push = decoder.decodeObjectForKey(PropertyKey.accept_pushKey) as? String
        let accept_emails = decoder.decodeObjectForKey(PropertyKey.accept_emailsKey) as? String
        
        // Must call designated initializer.
        self.init(  islogindone:islogindone,
                    card:card,
                    username:username,
                    name:name,
                    surname:surname,
                    email:email,
                    password:password,
                    phone:phone,
                    zipcode:zipcode,
                    address:address,
                    birthday_day:birthday_day,
                    birthday_month:birthday_month,
                    device_token:device_token,
                    accept_push:accept_push,
                    accept_emails:accept_emails
                )!
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeBool(islogindone, forKey: PropertyKey.isloginDone)
        aCoder.encodeObject(card, forKey: PropertyKey.cardKey)
        aCoder.encodeObject(username, forKey: PropertyKey.usernameKey)
        aCoder.encodeObject(name, forKey: PropertyKey.nameKey)
        aCoder.encodeObject(surname, forKey:PropertyKey.surnameKey)
        aCoder.encodeObject(email, forKey: PropertyKey.emailKey)
        aCoder.encodeObject(password, forKey: PropertyKey.passwordKey)
        aCoder.encodeObject(phone, forKey: PropertyKey.phoneKey)
        aCoder.encodeObject(zipcode, forKey: PropertyKey.zipcodeKey)
        aCoder.encodeObject(address, forKey: PropertyKey.addressKey)
        aCoder.encodeObject(birthday_day, forKey: PropertyKey.birthday_dayKey)
        aCoder.encodeObject(birthday_month, forKey: PropertyKey.birthday_monthKey)
        aCoder.encodeObject(device_token, forKey: PropertyKey.device_tokenKey)
        aCoder.encodeObject(accept_push, forKey: PropertyKey.accept_pushKey)
        aCoder.encodeObject(accept_emails, forKey: PropertyKey.accept_emailsKey)
    }
    
}
