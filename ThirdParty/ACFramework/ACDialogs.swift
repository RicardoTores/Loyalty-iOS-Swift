//
//  ACDialogs.swift
//
//  Created by Alex on 11/9/15
//  Copyright (c) 2015 Colectivo Coffee Roasters Inc. All rights reserved.
//

import Foundation
import UIKit

class ACDialogs {
   
    /*
       Hide the default constructor
    */
    private init() {
    }

    
    class func showMessageOkCancel(title: String, message: String, sender:AnyObject, buttonTitleOk: String, buttonTitleCancel: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .Alert)
    
        let cancelAction = UIAlertAction(title: buttonTitleCancel, style: .Cancel) { (action:UIAlertAction!) in
            //
        }
        alertController.addAction(cancelAction)
    
        let OKAction = UIAlertAction(title: buttonTitleOk, style: .Default) { (action:UIAlertAction!) in
            //
        }
        alertController.addAction(OKAction)
    
        sender.presentViewController(alertController, animated: true, completion:nil)
    }
    
    class func showMessage(title: String, message: String, sender:AnyObject, buttonTitle: String) {
        let alertView:UIAlertController = UIAlertController()
        alertView.title = title
        alertView.message = message
        
        let cancelAction: UIAlertAction = UIAlertAction(title: buttonTitle, style: .Default) { action -> Void in
            //Do some stuff
        }
        alertView.addAction(cancelAction)
        
        alertView.popoverPresentationController?.sourceView = sender as? UIView
        sender.presentViewController(alertView, animated: true, completion: nil)
    }
}