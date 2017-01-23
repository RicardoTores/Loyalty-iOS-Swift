//
//  Store.swift
//  Loyalty
//
//  Created by striver on 12/13/15.
//  Copyright © 2015 Colectivo Coffee Roasters Inc. All rights reserved.
//

import UIKit

class StoreEntity: NSObject {

    var store_id: NSString?
    var name    :NSString?
    var addr: NSString?
    var phn: NSString?
    var clr: NSString?
    var lat: NSString?
    var lng : NSString?
    var city: NSString?
    var tt1: NSString?
    var tt1lb: NSString?
    var tt2: NSString?
    var tt2lb: NSString?
    var tt3: NSString?
    var tt3lb: NSString?
    var tt4: NSString?
    var tt4lb: NSString?
    
     init(_ decoder: Dictionary<String,JSONDecoder>) {
        name = decoder["name"]?.string
        addr = decoder["addr"]?.string
        phn = decoder["phn"]?.string
        clr = decoder["clr"]?.string
        lat = decoder["lat"]?.string
        lng = decoder["lng"]?.string
        city = decoder["city"]?.string
        tt1 = decoder["tt1"]?.string
        tt1lb = decoder["tt1lb"]?.string
        tt2 = decoder["tt2"]?.string
        tt2lb = decoder["tt2lb"]?.string
        tt3 = decoder["tt3"]?.string
        tt3lb = decoder["tt3lb"]?.string
        tt4 = decoder["tt4"]?.string
        tt4lb = decoder["tt4lb"]?.string
        
    }
}

struct StoreList : JSONJoy {
    var storelist: NSMutableArray?
    init() {
    }
    init(_ decoder: JSONDecoder) {
        if let stores = decoder["store_list"].dictionary {
            storelist = NSMutableArray()
            for i in 0  ..< stores.count   {
                let key = Array(stores.keys)[i]
                let storeDecoder = stores[key]!.dictionary
                let store = StoreEntity(storeDecoder!)
                store.store_id = key
                if store.name != nil {
                    storelist!.addObject(store)
                }
            }
        }
    }
}