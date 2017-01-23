//
//  ACStringExtension.swift
//  Extends the Swift String class
//  Version 1.1 adapted to Swift 2
//
//  Created by Alex on 13/9/15.
//  Copyright (c) 2015 Colectivo Coffee Roasters Inc. All rights reserved.
//

import Foundation

extension String {
    
    var length: Int {
        return self.characters.count
    }
    
    /*! 
      Para ser usado como s[0...5] o s[0..<5]
    */
    subscript (r: Range<Int>) -> String {
        get {
            let startIndex = self.startIndex.advancedBy(r.startIndex)
            let endIndex = startIndex.advancedBy(r.endIndex - r.startIndex)
            return self[startIndex..<endIndex]
        }
    }
    
    func substring(from: Int) -> String {
        let end = self.length
        return self[from..<end]
    }
    
    func substring(from: Int, length: Int) -> String {
        let end = from + length
        return self[from..<end]
    }
    
    func contains(s: String) -> Bool {
        return (self.rangeOfString(s) != nil)
    }
    
    func slice(start: Int, _end: Int) -> String {
        var end = _end
        if end < 0 {
            end = self.length + end
        }
        let len = end-start
        return substring(start, length: len)
    }
    
    func pos(substring: String) -> Int {
        return self.pos(substring, start: 0, end: -1)
    }
    
    func pos(substring: String, start: Int, end: Int) -> Int {
        let len = end-start
        if end < 0 {
            return self.indexOf(substring, startIndex: start)
        } else if len == 0 {
            return self.lastIndexOf(substring)
        }
        return self.indexOf(substring, startIndex: start)
    }
    
    func indexOf(target: String) -> Int {
        let range = self.rangeOfString(target)
        if let range = range {
            return self.startIndex.distanceTo(range.startIndex)
        } else {
            return -1
        }
    }
    
    func indexOf(target: String, startIndex: Int) -> Int {
        let startRange = self.startIndex.advancedBy(startIndex)
        let range = self.rangeOfString(target, options: NSStringCompareOptions.LiteralSearch, range: (startRange..<self.endIndex))
        if let range = range {
            return self.startIndex.distanceTo(range.startIndex)
        } else {
            return -1
        }
    }
    
    func lastIndexOf(target: String) -> Int {
        var index = -1
        var stepIndex = self.indexOf(target)
        
        while stepIndex > -1 {
            index = stepIndex
            if stepIndex + target.length < self.length {
                stepIndex = indexOf(target, startIndex: stepIndex + target.length)
            } else {
                stepIndex = -1
            }
        }
        return index
    }
    
    //added by bongbong
    func toBase64String() -> String {
        print("toBase64String: \(self)")
        
        let utf8str = self.dataUsingEncoding(NSUTF8StringEncoding)
        let base64Encoded = utf8str?.base64EncodedStringWithOptions(NSDataBase64EncodingOptions(rawValue: 0))
        
        print("Result-Base64: \(base64Encoded)")
        return base64Encoded!
    }
    
    func base64ToString() -> String {
        print("base64ToString: \(self)")
        
        let base64Decoded = NSData(base64EncodedString: self, options:   NSDataBase64DecodingOptions(rawValue: 0))
            .map({ NSString(data: $0, encoding: NSUTF8StringEncoding) })
        
        return base64Decoded as! String!
    }
 }
