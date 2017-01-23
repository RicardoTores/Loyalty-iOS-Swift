//
//  ACLibNet.swift
//s
//  Created by Alex on 11/9/15.
//  Copyright (c) 2015 Colectivo Coffee Roasters Inc. All rights reserved.
//

import Foundation
import UIKit

public enum ACWebserviceCallError: Int {
    case WSCE_NONE = 0
    case WSCE_WRONG_URL = -100
    case WSCE_NOT_A_NSHTTPURLResponse = -110
    case WSCE_CONNECTION_FAILED = -120
    case WSCE_CONNECTION_FAILURE = -130
}

public class ACWebserviceCallResult {
    var responseData: NSDictionary!
    var errorCode: ACWebserviceCallError = .WSCE_NONE
    var errorMessage: String!
    
    init(responseData: NSDictionary) {
        self.responseData = responseData
    }

    init(errorCode: ACWebserviceCallError, errorMessage: String) {
        self.errorCode = errorCode
        self.errorMessage = errorMessage
    }

    convenience init(errorCode: ACWebserviceCallError) {
        self.init(errorCode: errorCode, errorMessage: "")
    }
   
    func isSuccess() -> Bool {
        return errorCode == ACWebserviceCallError.WSCE_NONE
    }
}

public class ACLibNet {
    
    /*
       Hide the default constructor
    */
    private init() {
    }
    
    /*!
        @method webserviceCallForJSON
        @discussionalls a webservice that must return a valid conformed JSON object
        @param urlstring
        @return
    */
    class func webserviceCallForJSON(urlstring: String, parameters: String?) throws -> ACWebserviceCallResult {
        if let _url: NSURL = NSURL(string: urlstring) {
            return try webserviceCallForJSON(_url, parameters: parameters)
        } else {
            return ACWebserviceCallResult(errorCode: ACWebserviceCallError.WSCE_WRONG_URL)
        }
    }

    class func webserviceCallForJSON(url: NSURL, parameters: String?) throws -> ACWebserviceCallResult {
        let post:NSString = parameters!
        
        let postData:NSData = post.dataUsingEncoding(NSASCIIStringEncoding)!
        let postLength:NSString = String( postData.length )
        
        let request:NSMutableURLRequest = NSMutableURLRequest(URL: url)
        request.HTTPMethod = "POST"
        request.HTTPBody = postData
        request.setValue(postLength as String, forHTTPHeaderField: "Content-Length")
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        
        var response: NSURLResponse?
        
        let urlData: NSData? = try NSURLConnection.sendSynchronousRequest(request, returningResponse:&response)
        
        if ( urlData != nil ) {
            let res = response as! NSHTTPURLResponse;
            
            if !(response is NSHTTPURLResponse) {
                return ACWebserviceCallResult(errorCode: ACWebserviceCallError.WSCE_NOT_A_NSHTTPURLResponse)
            }
            
            NSLog("Response code: %ld", res.statusCode);
            
            if (res.statusCode >= 200 && res.statusCode < 300)
            {
                let responseData:NSString  = NSString(data:urlData!, encoding:NSUTF8StringEncoding)!
                NSLog("Response ==> %@", responseData);

                let jsonData:NSDictionary = try NSJSONSerialization.JSONObjectWithData(urlData!, options:NSJSONReadingOptions.MutableContainers) as! NSDictionary
                
                return ACWebserviceCallResult(responseData: jsonData)
            } else {
                return ACWebserviceCallResult(errorCode: ACWebserviceCallError.WSCE_CONNECTION_FAILED)
            }
        } else {
            return ACWebserviceCallResult(errorCode: ACWebserviceCallError.WSCE_CONNECTION_FAILURE, errorMessage: "General connection failure")
        }
    }

}