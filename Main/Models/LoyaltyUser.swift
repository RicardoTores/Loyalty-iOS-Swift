//
//  LoyaltyUser.swift
//  Loyalty
//
//  Created by striver on 12/27/15.
//  Copyright © 2015 Colectivo Coffee Roasters Inc. All rights reserved.
//

import UIKit

class LoyaltyUser: NSObject, NSCoding{

    var islogindone : Bool = false
    var username : NSString?
    var surname: NSString?
    var password:NSString?
    var dateLastNotification : NSString?
    
    
    override init() {
        
    }
    
    init?(islogindone:Bool,
        username : String?,
        surname: String?,
        password: String?,
        dateLastNotification: String?
        )
    {
        // Initialize stored properties.
        self.islogindone = islogindone
        self.username = username
        self.surname = surname
        self.password = password
        self.dateLastNotification = dateLastNotification
    }
    
    init(_ decoder: Dictionary<String,JSONDecoder>) {
        self.username = decoder[PropertyKey.usernameKey]?.string
        self.surname = decoder[PropertyKey.surnameKey]?.string
        self.password = decoder[PropertyKey.passwordKey]?.string
        self.dateLastNotification = decoder[PropertyKey.dateLastNotificationKey]?.string
    }
    
    
    required convenience init(coder decoder: NSCoder) {
        let islogindone = decoder.decodeBoolForKey(PropertyKey.isloginDone)
        let username = decoder.decodeObjectForKey(PropertyKey.usernameKey) as? String
        let surname = decoder.decodeObjectForKey(PropertyKey.surnameKey) as? String
        let password = decoder.decodeObjectForKey(PropertyKey.passwordKey) as? String
        let dateLastNotification = decoder.decodeObjectForKey(PropertyKey.dateLastNotificationKey) as? String
        // Must call designated initializer.
        self.init(  islogindone:islogindone,
            username:username,
            surname:surname,
            password:password,
            dateLastNotification:dateLastNotification
            )!
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeBool(islogindone, forKey: PropertyKey.isloginDone)
        aCoder.encodeObject(username, forKey: PropertyKey.usernameKey)
        aCoder.encodeObject(surname, forKey:PropertyKey.surnameKey)
        aCoder.encodeObject(password, forKey: PropertyKey.passwordKey)
        aCoder.encodeObject(dateLastNotification, forKey: PropertyKey.dateLastNotificationKey)
    }

}
