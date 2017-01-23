//
//  UserManager.swift
//  Loyalty
//
//  Created by striver on 12/13/15.
//  Copyright © 2015 Colectivo Coffee Roasters Inc. All rights reserved.
//

import UIKit

let   KEY_LOYALTY_USERINFO = "Loyalty UserInfo"
let   KEY_LOYALTY_APP_USERINFO = "Loyalty App UserInfo"
let   KEY_LOYALTY_CARDBALANCE = "Loyalty CardBalance"
let   KEY_LOYALTY_NOTIFICATION = "Loyalty Notification list"
let   PATH_LOYALTY_NOTIFICATION = "/LoyaltyNotificationlist"


var USERMANAGER: UserManager = UserManager()

class UserManager: NSObject {

    var userentity : UserEntity?
    var loyaltyuser: LoyaltyUser?
    var notificationlist : NSMutableArray?
    
    override init() {
        super.init()
    }
    
    // current  information for Loyalty App user
    func setCurrentLoyaltyUser(entity:LoyaltyUser){
        loyaltyuser = entity
        if loyaltyuser != nil {
            self.saveLoyaltyUser(loyaltyuser!)
        }
    }
    
    func getCurrentLoyaltyUser() -> LoyaltyUser{
        if loyaltyuser == nil {
            loyaltyuser = self.loadLoyaltyUser()
        }
        return loyaltyuser!
    }
    
    func saveLoyaltyUser(userinfo : LoyaltyUser){
        let data = NSKeyedArchiver.archivedDataWithRootObject(userinfo);
        NSUserDefaults.standardUserDefaults().setObject(data, forKey: KEY_LOYALTY_APP_USERINFO)
    }
    
    func loadLoyaltyUser() -> LoyaltyUser?{
        let data : NSData? = NSUserDefaults.standardUserDefaults().objectForKey(KEY_LOYALTY_APP_USERINFO) as? NSData
        
        var userinfo: LoyaltyUser?
        if(data != nil){
            userinfo = NSKeyedUnarchiver.unarchiveObjectWithData(data!) as? LoyaltyUser
        }else{
            userinfo = LoyaltyUser()
        }
        return userinfo;
    }


    func setCurrentUserEntity(entity:UserEntity){
        userentity = entity
        if entity.user_info != nil {
            self.saveUserInfo(entity.user_info!)
        }
        if entity.card_balance != nil {
            self.saveCardBalance(entity.card_balance!)
        }
    }
    
    func getCurrentUserEntity() -> UserEntity{
        if userentity == nil {
            userentity = UserEntity()
        }
        if userentity?.user_info == nil {
           userentity?.user_info = self.loadUserInfo()
        }
        if userentity?.card_balance == nil {
            userentity?.card_balance = self.loadCardBalance()
        }
        return userentity!
    }
    
    func saveUserInfo(userinfo : UserInfo){
        let data = NSKeyedArchiver.archivedDataWithRootObject(userinfo);
        NSUserDefaults.standardUserDefaults().setObject(data, forKey: KEY_LOYALTY_USERINFO)
    }
    
    func loadUserInfo() -> UserInfo?{
        let data : NSData? = NSUserDefaults.standardUserDefaults().objectForKey(KEY_LOYALTY_USERINFO) as? NSData
        
        var userinfo: UserInfo?
        if(data != nil){
            userinfo = NSKeyedUnarchiver.unarchiveObjectWithData(data!) as? UserInfo
        }else{
            userinfo = UserInfo()
        }
        return userinfo;
    }
    
    func saveCardBalance(cardbalance : CardBalance){
        let data = NSKeyedArchiver.archivedDataWithRootObject(cardbalance);
        NSUserDefaults.standardUserDefaults().setObject(data, forKey: KEY_LOYALTY_CARDBALANCE)
    }
    
    func loadCardBalance() -> CardBalance{
        let data = NSUserDefaults.standardUserDefaults().objectForKey(KEY_LOYALTY_CARDBALANCE) as? NSData
        var cardbalance: CardBalance?
        if data != nil {
            cardbalance = NSKeyedUnarchiver.unarchiveObjectWithData(data!) as? CardBalance
        }else {
            cardbalance = CardBalance()
        }
        return cardbalance!;
    }

    func isLoginDone() -> Bool{
        return self.getCurrentLoyaltyUser().islogindone
    }

    func saveArrayToFile(dataCollection:NSMutableArray, filename: NSString)
    {
        
        let docDirectoryPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true).first! as String
        let savedDestPath = docDirectoryPath.stringByAppendingString(filename as String);
    
        let data = NSMutableData();
        let archiver = NSKeyedArchiver(forWritingWithMutableData: data);
    
        archiver.encodeObject(dataCollection, forKey:KEY_LOYALTY_NOTIFICATION);
        archiver.finishEncoding();
    
        data.writeToFile(savedDestPath as String, atomically:true);
    }
    
    
    func loadDataFromFile(filePath : NSString) -> NSMutableArray
    {
        let docDirectoryPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true).first! as String
        let savedDestPath = docDirectoryPath.stringByAppendingString(filePath as String);
        
        let data = NSMutableData(contentsOfFile: savedDestPath as String)
        if data == nil {
            return NSMutableArray()
        }
        let unarchiver = NSKeyedUnarchiver(forReadingWithData: data!)
        let dataCollection = unarchiver.decodeObjectForKey(KEY_LOYALTY_NOTIFICATION) as! NSMutableArray
        unarchiver.finishDecoding()
        
        return dataCollection
    }
    
    func setNotificationList(list:NSMutableArray)
    {
        notificationlist = list
        self.saveArrayToFile(notificationlist!, filename: PATH_LOYALTY_NOTIFICATION)
    }
    
    
    func getNotificationList() -> NSMutableArray{
        if notificationlist == nil{
            notificationlist = self.loadDataFromFile(PATH_LOYALTY_NOTIFICATION)
        }
        return notificationlist!
    }
    
    func addNotification(notificaton : NSMutableDictionary )
    {
        let item = MessageEntity(notificaton: notificaton);
        getNotificationList().insertObject(item!, atIndex: 0);
        USERMANAGER.setNotificationList(USERMANAGER.getNotificationList())

        NSNotificationCenter.defaultCenter().postNotificationName("refreshNotificationVC", object: nil);
        NSNotificationCenter.defaultCenter().postNotificationName("refreshBadgeNum", object: nil);
    }
    
    func getCountNotReadNotification() -> NSInteger{
        var count = 0
        for i in 0 ..< getNotificationList().count {
            if let item = getNotificationList().objectAtIndex(i) as? MessageEntity {
                if item.isRead == false {
                    count += 1
               }
            }
        }
        return count
    }
    
    func downMyNotificationList(){
        let param: [String:String]?
        if let lastdate = getCurrentLoyaltyUser().dateLastNotification{
            param = ["from":lastdate as String]
        }else{
            WEBSERVICE.getCurrentServerDate({
                    servertime in
                    dispatch_async(dispatch_get_main_queue()) {
                        USERMANAGER.getCurrentLoyaltyUser().dateLastNotification = servertime
                        USERMANAGER.setCurrentLoyaltyUser(USERMANAGER.getCurrentLoyaltyUser())
                        USERMANAGER.downMyNotificationList()
                    }
                })
            return
        }
//        Util.sharedInstant().showHub(true)
        WEBSERVICE.getPushList(param!,
            success: {data in
                dispatch_async(dispatch_get_main_queue()) {
//                    Util.sharedInstant().showHub(false)

                    let json = JSONDecoder(data)
                    if let success = json["succeeded"].string {
                        if success == "OK" {
                            if let pushlist = json["data"].array {
                                for i in 0 ..< pushlist.count {
                                    let message = MessageEntity(pushlist[i])
                                    var exist = false
                                    for j in 0  ..< self.getNotificationList().count  {
                                        if (self.getNotificationList().objectAtIndex(j) as! MessageEntity).id == message.id {
                                            exist = true
                                            break
                                        }
                                    }
                                    if exist == false {
                                        self.getNotificationList().insertObject(message, atIndex: 0)
                                        USERMANAGER.getCurrentLoyaltyUser().dateLastNotification = message.dateString
                                    }
                                }
                                USERMANAGER.setNotificationList(USERMANAGER.getNotificationList())
                                USERMANAGER.setCurrentLoyaltyUser(USERMANAGER.getCurrentLoyaltyUser())
                                NSNotificationCenter.defaultCenter().postNotificationName("refreshNotificationVC", object: nil);
                                NSNotificationCenter.defaultCenter().postNotificationName("refreshBadgeNum", object: nil);
                            }
                        }
                    }
                }
            },
            fail: {
                dispatch_async(dispatch_get_main_queue()) {
//                    Util.sharedInstant().showHub(false)
//                    let alert = UIAlertView.init(title: nil, message: "Server connection error!", delegate: nil, cancelButtonTitle: "OK")
//                    alert.show()
                    let alertController = UIAlertController(title: nil, message: "Server connection error!", preferredStyle: .Alert)
                    alertController.show()
                }
        })
    }
    
    func downAllNotificationList(){
        USERMANAGER.getCurrentLoyaltyUser().dateLastNotification = nil
        USERMANAGER.getNotificationList().removeAllObjects()
        USERMANAGER.setNotificationList(USERMANAGER.getNotificationList())
        USERMANAGER.downMyNotificationList()
    }
    
}
