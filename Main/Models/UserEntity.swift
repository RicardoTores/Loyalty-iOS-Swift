//
//  UserEntity.swift
//  Loyalty
//
//  Created by striver on 12/15/15.
//  Copyright © 2015 Colectivo Coffee Roasters Inc. All rights reserved.
//

import UIKit

class UserEntity: NSObject, JSONJoy {

    var user_info : UserInfo?
    var card_balance : CardBalance?
    var store_list : StoreList?
     override init() {
        super.init()
    }
    required init(_ decoder: JSONDecoder) {
        
        if let aDecoder = decoder["user_info"].value {
            user_info = UserInfo(aDecoder as! Dictionary<String, JSONDecoder>)
        }
        if let aDecoder = decoder["card_balance"].value{
            card_balance = CardBalance(aDecoder as! Dictionary<String, JSONDecoder>)
        }
        if let _ = decoder["store_list"].value{
            store_list = StoreList(decoder)
        }
        
        
    }

    
}
