//
//  SignViewController.swift
//  Loyalty
//
//  Created by striver on 12/13/15.
//  Copyright © 2015 Colectivo Coffee Roasters Inc. All rights reserved.
//

import UIKit

class SignViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var btnSignup: UIButton!
    @IBOutlet weak var btnLogin: UIButton!
    @IBOutlet weak var textfieldPassword: UITextField!
    @IBOutlet weak var textfieldUsername: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.setupUI()
    }
    @IBAction func doLogin(sender: AnyObject) {
        textfieldPassword.resignFirstResponder()
        textfieldUsername.resignFirstResponder()
        if checkupDataForLogin() {
            Util.sharedInstant().showHub(true)
            let dic : [String : AnyObject] = [
                PropertyKey.usernameKey : textfieldUsername.text!,
                PropertyKey.passwordKey : textfieldPassword.text!
            ]
            WEBSERVICE.login(dic,
                             success: {data in
                                dispatch_async(dispatch_get_main_queue()) {
                                    Util.sharedInstant().showHub(false)
                                    let status = ErrorEntity(JSONDecoder(data).dictionary!)
                                    if let _ = status.key {
                                        //                            let alert = UIAlertView.init(title: nil, message:status.msg as? String, delegate: nil, cancelButtonTitle: "OK")
                                        //                            alert.show()
                                        Util.sharedInstant().showMessage(self, messageWith: status.msg as? String)
                                        return
                                    }
                                    let entity = UserEntity(JSONDecoder(data))
                                    USERMANAGER.setCurrentUserEntity(entity)
                                    
                                    let loyaltyuser = USERMANAGER.getCurrentLoyaltyUser()
                                    var isDownAllNotification = false
                                    if self.textfieldUsername.text != loyaltyuser.username{
                                        loyaltyuser.username = self.textfieldUsername.text
                                        isDownAllNotification = true
                                    }
                                    if self.textfieldPassword.text != loyaltyuser.password{
                                        loyaltyuser.password = self.textfieldPassword.text
                                        isDownAllNotification = true
                                    }
                                    if isDownAllNotification == true{
                                        USERMANAGER.downAllNotificationList()
                                    }
                                    loyaltyuser.islogindone = true
                                    USERMANAGER.setCurrentLoyaltyUser(loyaltyuser)
                                    
                                    self.navigationController?.popViewControllerAnimated(true)
                                    NSNotificationCenter.defaultCenter().postNotificationName("refresh", object: nil)
                                    
                                }
                },
                             fail: {
                                dispatch_async(dispatch_get_main_queue()) {
                                    Util.sharedInstant().showHub(false)
                                    //                        let alert = UIAlertView.init(title: nil, message: "Server connection error!", delegate: nil, cancelButtonTitle: "OK")
                                    //                        alert.show()
                                    Util.sharedInstant().showMessage(self, messageWith: "Server connection error!")
                                }
            })
        }

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    @IBAction func onLogin(sender: AnyObject) {
        
        textfieldPassword.resignFirstResponder()
        textfieldUsername.resignFirstResponder()
        if checkupDataForLogin() {
            Util.sharedInstant().showHub(true)
            let dic : [String : AnyObject] = [
                PropertyKey.usernameKey : textfieldUsername.text!,
                PropertyKey.passwordKey : textfieldPassword.text!
                ]
            WEBSERVICE.login(dic,
                success: {data in
                    dispatch_async(dispatch_get_main_queue()) {
                        Util.sharedInstant().showHub(false)
                        let status = ErrorEntity(JSONDecoder(data).dictionary!)
                        if let _ = status.key {
//                            let alert = UIAlertView.init(title: nil, message:status.msg as? String, delegate: nil, cancelButtonTitle: "OK")
//                            alert.show()
                            Util.sharedInstant().showMessage(self, messageWith: status.msg as? String)
                            return
                        }
                        let entity = UserEntity(JSONDecoder(data))
                        USERMANAGER.setCurrentUserEntity(entity)
                        
                        let loyaltyuser = USERMANAGER.getCurrentLoyaltyUser()
                        var isDownAllNotification = false
                        if self.textfieldUsername.text != loyaltyuser.username{
                            loyaltyuser.username = self.textfieldUsername.text
                            isDownAllNotification = true
                        }
                        if self.textfieldPassword.text != loyaltyuser.password{
                            loyaltyuser.password = self.textfieldPassword.text
                            isDownAllNotification = true
                        }
                        if isDownAllNotification == true{
                            USERMANAGER.downAllNotificationList()
                        }
                        loyaltyuser.islogindone = true
                        USERMANAGER.setCurrentLoyaltyUser(loyaltyuser)

                        self.navigationController?.popViewControllerAnimated(true)
                        NSNotificationCenter.defaultCenter().postNotificationName("refresh", object: nil)

                    }
                },
                fail: {
                    dispatch_async(dispatch_get_main_queue()) {
                        Util.sharedInstant().showHub(false)
//                        let alert = UIAlertView.init(title: nil, message: "Server connection error!", delegate: nil, cancelButtonTitle: "OK")
//                        alert.show()
                        Util.sharedInstant().showMessage(self, messageWith: "Server connection error!")
                    }
            })
        }
        
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    // MARK: - textfield delegate
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder();
        return true
    }

    // check up
    func checkupDataForLogin() -> Bool{
        var result = true
        var message : String?
        if result && textfieldUsername.text?.length < 1 {
            result = false
            message = "Please input user name"
        }
        if result &&  textfieldPassword.text?.length < 1 {
            result = false
            message = "Please input password"

        }
        if result == false {
//            let alert = UIAlertView.init(title: nil, message: message, delegate: nil, cancelButtonTitle: "OK") 
//            alert.show()
            Util.sharedInstant().showMessage(self, messageWith: message)
        }
        return result
    }
    
    func setupUI(){
        textfieldUsername.text = USERMANAGER.getCurrentLoyaltyUser().username as? String
        textfieldPassword.text = USERMANAGER.getCurrentLoyaltyUser().password as? String
    }
    
}
