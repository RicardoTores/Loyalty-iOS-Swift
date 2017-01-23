//
//  MessageEntity.swift
//  Loyalty
//
//  Created by striver on 12/17/15.
//  Copyright © 2015 Colectivo Coffee Roasters Inc. All rights reserved.
//

import UIKit

class MessageEntity: NSObject, NSCoding, JSONJoy{
    var title : NSString?
    var date : NSDate?
    var dateString : NSString?
    var message : NSString?
    var id  : NSString?
    var isRead:Bool
    
//    override init() {
//        isRead = false
//        title = ""
//        date = NSDate()
//        message = ""
//        super.init()
//    }
    init(title: String?,
        date: NSDate?,
        dateString : String?,
        message: String?,
        id : String?,
        isRead: Bool?
        )
    {
        // Initialize stored properties.
        self.title = title
        self.date = date
        self.message = message
        self.isRead = isRead!
        self.id = id
        self.dateString = dateString
    }
    init?(notificaton : NSMutableDictionary) {
        //self.title = notificaton.objectForKey(PropertyKey.titleKey) as? NSString
        self.title = "Loyalty Notification"
        self.isRead = false

        self.message = notificaton.objectForKey(PropertyKey.messageKey) as? NSString
        self.id = notificaton.objectForKey(PropertyKey.idKey) as? NSString
        self.date = NSDate()
        
    }
    required init(_ decoder: JSONDecoder) {
        
        self.title = "Loyalty Notification"
        self.isRead = false
        if let aDecoder = decoder[PropertyKey.messageKey].string {
            self.message = aDecoder
        }
        if let aDecoder = decoder[PropertyKey.idKey].string{
            self.id = aDecoder
        }
        if let aDecoder = decoder[PropertyKey.dateKey].string{
            self.dateString = aDecoder
            let dateFormart = NSDateFormatter()
            dateFormart.dateFormat = "yyyy-MM-dd HH-mm-ss"
            self.date = dateFormart.dateFromString(aDecoder)

        }
        if let aDecoder = decoder[PropertyKey.dateServerKey].string{
            let dateFormart = NSDateFormatter()
            dateFormart.dateFormat = "yyyy-MM-dd HH-mm-ss"
            let serverdate = dateFormart.dateFromString(aDecoder)

            let deltatime = NSDate().timeIntervalSinceDate(serverdate!)
            let time1 = (self.date?.timeIntervalSince1970)! + deltatime
            self.date = NSDate(timeIntervalSince1970:time1)
            
        }
        
    }

    
    required convenience init(coder decoder: NSCoder) {
        let title = decoder.decodeObjectForKey(PropertyKey.titleKey) as? String
        let date = decoder.decodeObjectForKey(PropertyKey.dateKey) as? NSDate
        let dateString = decoder.decodeObjectForKey(PropertyKey.dateStringKey) as? String
        let message = decoder.decodeObjectForKey(PropertyKey.messageKey) as? String
        let isRead = decoder.decodeBoolForKey(PropertyKey.isReadKey)
        let id = decoder.decodeObjectForKey(PropertyKey.idKey) as? String

        // Must call designated initializer.!
        self.init(title:title,
            date:date,
            dateString:dateString,
            message:message,
            id : id,
            isRead:isRead
            )
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(title, forKey: PropertyKey.titleKey)
        aCoder.encodeObject(date, forKey: PropertyKey.dateKey)
        aCoder.encodeObject(dateString, forKey: PropertyKey.dateStringKey)
        aCoder.encodeObject(message, forKey: PropertyKey.messageKey)
        aCoder.encodeObject(id, forKey: PropertyKey.idKey)
        aCoder.encodeBool(isRead, forKey: PropertyKey.isReadKey)
    }


}
