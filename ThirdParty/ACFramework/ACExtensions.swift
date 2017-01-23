//
//  ACExtensions.swift
//  TestLogin
//
//  Created by Alex on 14/9/15.
//  Copyright (c) 2015 Colectivo Coffee Roasters Inc. All rights reserved.
//

import Foundation

public extension Int {
    func hexString() -> String {
        return String(format:"%02x", self)
    }
}

public extension NSData {
   func hexString() -> String {
        var string = String()
        for i in UnsafeBufferPointer<UInt8>(start: UnsafeMutablePointer<UInt8>(bytes), count: length) {
            string += Int(i).hexString()
        }
        return string
   }
}