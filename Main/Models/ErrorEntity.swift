//
//  ErrorEntity.swift
//  Loyalty
//
//  Created by striver on 12/17/15.
//  Copyright © 2015 Colectivo Coffee Roasters Inc. All rights reserved.
//

import UIKit

class ErrorEntity: NSObject {
    var key: NSString?
    var msg:NSString?
    
    init(_ decoder: Dictionary<String,JSONDecoder>) {
        key = decoder["key"]?.string
        msg = decoder["msg"]?.string
    }

}
