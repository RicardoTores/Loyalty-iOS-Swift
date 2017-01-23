//
//  SignupViewController.swift
//  Loyalty
//
//  Created by striver on 12/13/15.
//  Copyright © 2015 Colectivo Coffee Roasters Inc. All rights reserved.
//

import UIKit


class SignupViewController: UIViewController, UITextFieldDelegate, UIPickerViewDataSource, UIPickerViewDelegate{
    
    @IBOutlet weak var btnSignup: UIButton!
    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var textfieldConfirmPassword: UITextField!
    @IBOutlet weak var textfieldPassword: UITextField!
    @IBOutlet weak var textfieldEmail: UITextField!
    @IBOutlet weak var textfieldUsername: UITextField!
    @IBOutlet weak var textfieldName: UITextField!
    @IBOutlet weak var textfieldPhone: UITextField!
    @IBOutlet weak var textfieldZipcode: UITextField!
    
    @IBOutlet weak var birthdayPickerSheet: UIView!
    @IBOutlet weak var textfieldBirthday: UITextField!
    
    @IBOutlet weak var dayPicker: UIPickerView!
    @IBOutlet weak var monthPicker: UIPickerView!
    var birthday_day: String = ""
    var birthday_month: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        birthdayPickerSheet.hidden = true
        textfieldBirthday.enabled = false
        birthday_day = Settings.DAY_DATA_SOURCE[0]
        birthday_month = Settings.MONTH_DATA_SOURCE[0]
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onBack(sender: AnyObject) {
        textfieldConfirmPassword.resignFirstResponder()
        textfieldPassword.resignFirstResponder()
        textfieldEmail.resignFirstResponder()
        textfieldUsername.resignFirstResponder()
        textfieldName.resignFirstResponder()
        textfieldPhone.resignFirstResponder()
        textfieldZipcode.resignFirstResponder()
        self.navigationController?.popViewControllerAnimated(true)
        
    }
    
    @IBAction func onSignup(sender: AnyObject) {
        textfieldConfirmPassword.resignFirstResponder()
        textfieldPassword.resignFirstResponder()
        textfieldEmail.resignFirstResponder()
        textfieldUsername.resignFirstResponder()
        textfieldName.resignFirstResponder()
        textfieldPhone.resignFirstResponder()
        textfieldZipcode.resignFirstResponder()
        
            if checkupDataForSignup(){
                Util.sharedInstant().showHub(true)
                let dic : [String : AnyObject] = [
                    PropertyKey.usernameKey : textfieldUsername.text!,
                    PropertyKey.nameKey: textfieldName.text!,
                    PropertyKey.emailKey : textfieldEmail.text!,
                    PropertyKey.phoneKey : textfieldPhone.text!,
                    PropertyKey.zipcodeKey : textfieldZipcode.text!,
                    PropertyKey.passwordKey : textfieldPassword.text!,
                    PropertyKey.birthday_monthKey : birthday_month,
                    PropertyKey.birthday_dayKey : birthday_day
                ]
                WEBSERVICE.signup(dic,
                    success: { data in
                        dispatch_async(dispatch_get_main_queue()) {
                            Util.sharedInstant().showHub(false)
                            let status = ErrorEntity(JSONDecoder(data).dictionary!)
                            if let _ = status.key {
//                                let alert = UIAlertView.init(title: nil, message:status.msg as? String, delegate: nil, cancelButtonTitle: "OK")
//                                alert.show()
                                Util.sharedInstant().showMessage(self, messageWith: status.msg as? String)
                                return
                            }
                            let entity = UserEntity(JSONDecoder(data))
                            USERMANAGER.setCurrentUserEntity(entity)

                            let loyaltyuser = USERMANAGER.getCurrentLoyaltyUser()
                            loyaltyuser.password = self.textfieldPassword.text
                            loyaltyuser.username = self.textfieldUsername.text
                            loyaltyuser.islogindone = true
                            USERMANAGER.setCurrentLoyaltyUser(loyaltyuser)
                            USERMANAGER.downAllNotificationList()
                            self.navigationController?.popToRootViewControllerAnimated(true)
                            NSNotificationCenter.defaultCenter().postNotificationName("refresh", object: nil)
                            
                        }
                    },
                    fail: {
                        dispatch_async(dispatch_get_main_queue()) {
                            Util.sharedInstant().showHub(false)
//                            let alert = UIAlertView.init(title: nil, message: "Server connection error!", delegate: nil, cancelButtonTitle: "OK")
//                            alert.show()
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
    func checkupDataForSignup() -> Bool{
        var result = true
        var message : String?
        
        if result && textfieldUsername.text?.length < 1 {
            result = false
            message = "Username required."
        }
        
        if result && textfieldName.text?.length < 1 {
            result = false
            message = "Name required."
        }
        
        if result && textfieldEmail.text?.length < 1 {
            result = false
            message = "Email required."
            
        }
        
        if result && isValidEmail(textfieldEmail.text!) == false {
            result = false;
            message = "Invalid email address."
        }
        
        //if result &&  textfieldPhone.text?.length < 1 {
        //    result = false
        //    message = "Phone number required."
        //}
        
        //if result && textfieldZipcode.text?.length < 1 {
        //    result = false
        //    message = "Zip code required."
        //}

        if result &&  textfieldPassword.text?.length < 4 {
            result = false
            message = "Password must be at least 4 charcaters."
            
        }
        
        if result && textfieldConfirmPassword.text != textfieldPassword.text {
            result = false
            message = "Confirm Password does not match."
        }
        
        
        if result == false {
//            let alert = UIAlertView.init(title: nil, message: message, delegate: nil, cancelButtonTitle: "OK")
//            alert.show()
            let alertController = UIAlertController(title: nil, message: message, preferredStyle: .Alert)
            alertController.show()
            
        }
        return result
    }
    
    func isValidEmail(testStr:String) -> Bool {
        // println("validate calendar: \(testStr)")
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,6}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegex)
        let ret = emailTest.evaluateWithObject(testStr)
        return ret
    }
    
    @IBAction func onSelectBirthday(sender: UITextField) {
        //let datePickerView: UIDatePicker = UIDatePicker()
        
        //datePickerView.option = 0x101;//  UICustomDatePicker.NSCustomDatePickerOptionDay | NSCustomDatePickerOptionLongMonth
        //datePickerView.order =  NSCustomDatePickerOrderDayMonthAndYear
        //datePickerView.datePickerMode = UIDatePickerMode.Date
        //sender.inputView = datePickerView
        
        //datePickerView.addTarget(self, action: #selector(datePickerValueChanged), forControlEvents: UIControlEvents.ValueChanged)

        birthdayPickerSheet.hidden = false
    }
    func datePickerValueChanged(sender:UIDatePicker) {
        
        let dateFormatter = NSDateFormatter()
        
        dateFormatter.dateStyle = NSDateFormatterStyle.MediumStyle
        
        dateFormatter.timeStyle = NSDateFormatterStyle.NoStyle
        
        textfieldBirthday.text = dateFormatter.stringFromDate(sender.date)
        
    }
    @IBAction func onBirthDayDone(sender: AnyObject) {
        birthdayPickerSheet.hidden = true
        textfieldBirthday.text = birthday_month + "/" + birthday_day
    }
    @IBAction func onBirthDayCancel(sender: AnyObject) {
        birthdayPickerSheet.hidden = true
    
    }
    
    // UIPickerView Delegate
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if (pickerView == monthPicker) {
            return Settings.MONTH_DATA_SOURCE.count
        }
        else if (pickerView == dayPicker) {
            return Settings.DAY_DATA_SOURCE.count
        }
        
        return 0
    }
    
    @IBAction func onShowPickers(sender: AnyObject) {
        textfieldConfirmPassword.resignFirstResponder()
        textfieldPassword.resignFirstResponder()
        textfieldEmail.resignFirstResponder()
        textfieldUsername.resignFirstResponder()
        textfieldName.resignFirstResponder()
        textfieldPhone.resignFirstResponder()
        textfieldZipcode.resignFirstResponder()
        
        birthdayPickerSheet.hidden = false
    }
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if (pickerView == monthPicker) {
            return Settings.MONTH_DATA_SOURCE[row]
        }
        else if (pickerView == dayPicker) {
            return Settings.DAY_DATA_SOURCE[row]
        }
        
        return ""
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int)
    {
        if (pickerView == monthPicker) {
            birthday_month = Settings.MONTH_DATA_SOURCE[row]
        }
        else if (pickerView == dayPicker) {
            birthday_day = Settings.DAY_DATA_SOURCE[row]
        }
    }
    
}
