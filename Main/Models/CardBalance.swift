//
//  CardBalance.swift
//  Loyalty
//
//  Created by striver on 12/13/15.
//  Copyright © 2015 Colectivo Coffee Roasters Inc. All rights reserved.
//

import UIKit

class CardBalance: NSObject, NSCoding{

    var loyalty_points : NSString?
    var gift_balance : NSString?

    override init() {
        
    }
    
    init?(loyalty_points: String?, gift_balance: String? )
    {
        // Initialize stored properties.
        self.loyalty_points = loyalty_points
        self.gift_balance = gift_balance
        // Initialization should fail if there is no name or if the rating is negative.
        //        if (name?.isEmpty || password?.isEmpty || email?.isEmpty) {
        //            return nil
        //        }
    }
    init(_ decoder: Dictionary<String,JSONDecoder>) {
            var aDec = decoder["loyalty"]?.dictionary
            self.loyalty_points = aDec![PropertyKey.loyalty_pointsKey]?.string
        
            aDec = decoder["gift"]?.dictionary
            self.gift_balance = aDec![PropertyKey.gift_balanceKey]?.string
        
    }

    required convenience init(coder decoder: NSCoder) {
        let loyalty_points = decoder.decodeObjectForKey(PropertyKey.loyalty_pointsKey) as? String
        let gift_balance = decoder.decodeObjectForKey(PropertyKey.gift_balanceKey) as? String
        // Must call designated initializer.
        self.init(loyalty_points:loyalty_points, gift_balance:gift_balance)!
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(loyalty_points, forKey: PropertyKey.loyalty_pointsKey)
        aCoder.encodeObject(gift_balance, forKey: PropertyKey.gift_balanceKey)
    }

}
