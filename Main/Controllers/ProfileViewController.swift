//
//  ProfileViewController.swift
//  Loyalty
//
//  Created by Alex on 04/10/15.
//  Copyright © 2015 Colectivo Coffee Roasters Inc. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController, UITextFieldDelegate, UIPickerViewDataSource, UIPickerViewDelegate {

    @IBOutlet weak var textfieldPassword: UITextField!
    @IBOutlet weak var textfieldEmail: UITextField!
    @IBOutlet weak var textfieldPhone: UITextField!
    @IBOutlet weak var textfieldSurname: UITextField!
    @IBOutlet weak var textfieldUserName: UITextField!
    @IBOutlet weak var textfieldZipcode: UITextField!
    @IBOutlet weak var textfieldConfirmPass: UITextField!
    @IBOutlet weak var birthdayPickerSheet: UIView!

    @IBOutlet weak var textfieldBirthday: UITextField!
    @IBOutlet weak var monthPicker: UIPickerView!
    @IBOutlet weak var dayPicker: UIPickerView!
    var birthday_month: String = ""
    var birthday_day: String = ""
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        birthdayPickerSheet.hidden = true
        updateUI()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UISfdoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    @IBAction func onSave(sender: AnyObject) {
        textfieldUserName.resignFirstResponder()
        textfieldPassword.resignFirstResponder()
        textfieldConfirmPass.resignFirstResponder()
        textfieldEmail.resignFirstResponder()
        textfieldSurname.resignFirstResponder()
        textfieldPhone.resignFirstResponder()
        textfieldZipcode.resignFirstResponder()

        if checkupData() {
            Util.sharedInstant().showHub(true)
            let dic : [String : AnyObject] = [
                PropertyKey.usernameKey : textfieldUserName.text!,
                PropertyKey.nameKey : textfieldSurname.text!,
                PropertyKey.phoneKey : textfieldPhone.text!,
                PropertyKey.emailKey : textfieldEmail.text!,
                PropertyKey.zipcodeKey : textfieldZipcode.text!,
                PropertyKey.passwordKey : textfieldPassword.text!,
                PropertyKey.confirmpasswordKey : textfieldConfirmPass.text!,
                PropertyKey.birthday_monthKey : birthday_month,
                PropertyKey.birthday_dayKey : birthday_day
            ]

            WEBSERVICE.updateCustomer(dic,
                success:{data in
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
                        loyaltyuser.surname = self.textfieldSurname.text
                        let password = self.textfieldPassword.text! as String
                        if (password != "") {
                            loyaltyuser.password = password
                        }
                        USERMANAGER.setCurrentLoyaltyUser(loyaltyuser)

                        self.navigationController?.popViewControllerAnimated(true)
                    }
                
                },
                fail:{
                    dispatch_async(dispatch_get_main_queue()) {
                        Util.sharedInstant().showHub(false)
//                        let alert = UIAlertView.init(title: nil, message: "Server connection error!", delegate: nil, cancelButtonTitle: "OK")
//                        alert.show()
                        Util.sharedInstant().showMessage(self, messageWith: "Server connection error!")
                    }
            })
        }
    }
    @IBAction func onBack(sender: AnyObject) {
        self.navigationController?.popViewControllerAnimated(true)
    }
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        if (self.textfieldUserName == textField) {
            textfieldSurname.becomeFirstResponder();
        }
        else if (self.textfieldSurname == textField) {
            self.textfieldEmail.becomeFirstResponder();
        }
        else if (self.textfieldEmail == textField) {
            self.textfieldPhone.becomeFirstResponder();
        }
        else if (self.textfieldPhone == textField) {
            self.textfieldZipcode.becomeFirstResponder();
        }
        else if (self.textfieldZipcode == textField) {
            self.textfieldPassword.becomeFirstResponder();
        }
        else if (self.textfieldPassword == textField) {
            self.textfieldConfirmPass.becomeFirstResponder();
        }
        else if (self.textfieldConfirmPass == textField){
            self.textfieldConfirmPass.resignFirstResponder();
        }
        textField.resignFirstResponder()
        return true
    }
    
    func updateUI(){
        let userentity = USERMANAGER.getCurrentUserEntity()
        let loyaltyuser = USERMANAGER.getCurrentLoyaltyUser()
        birthday_month = (userentity.user_info?.birthday_month as? String)!
        birthday_day = (userentity.user_info?.birthday_day as? String)!
        textfieldUserName.text = loyaltyuser.username as? String
        textfieldEmail.text = userentity.user_info?.email as? String
        textfieldPhone.text = userentity.user_info?.phone as? String
        textfieldPassword.text = userentity.user_info?.password as? String
        textfieldConfirmPass.text = userentity.user_info?.password as? String
        textfieldSurname.text = userentity.user_info?.name as? String
        textfieldZipcode.text = userentity.user_info?.zipcode as? String
        textfieldBirthday.text = birthday_month + "/" + birthday_day
        updateBirthDaySheet()
    }
    
    func updateBirthDaySheet() {
    
        for i in 0..<Settings.MONTH_DATA_SOURCE.count {
            if (Settings.MONTH_DATA_SOURCE[i] == self.birthday_month) {

                monthPicker.selectRow( i, inComponent: 0, animated: true)
            }
        }
           
        for i in 0..<Settings.DAY_DATA_SOURCE.count {
            if (Settings.DAY_DATA_SOURCE[i] == self.birthday_day) {

                dayPicker.selectRow( i, inComponent: 0, animated: true)
            }
        }
        
        
    }
    
    // check up
    func checkupData() -> Bool{
        var result = true
        var message : String?
        
        if result && textfieldUserName.text?.length < 1 {
            result = false
            message = "Username required."
        }

        if result && textfieldSurname.text?.length < 1 {
            result = false
            message = "Name required."
        }
        
        if result &&  textfieldEmail.text?.length < 1 {
            result = false
            message = "Email required."
            
        }
        
        //if result &&  textfieldPhone.text?.length < 1 {
        //    result = false
        //    message = "Phone number required."
            
        //}
        
        if result && isValidEmail(textfieldEmail.text!) == false {
            result = false
            message = "Invalid email address."
        }

        //if result &&  textfieldZipcode.text?.length < 1 {
        //    result = false
        //    message = "Zip code required."
        //}
        
        if result && textfieldPassword.text?.length < 4 && textfieldPassword.text?.length > 1 {
            result = false
            message = "Password must be at least 4 characters."
        }
        
        if result && textfieldPassword.text != textfieldConfirmPass.text {
            result = false
            message = "Confirm Password does not match password."
        }
        
        if result == false {
//            let alert = UIAlertView.init(title: nil, message: message, delegate: nil, cancelButtonTitle: "OK")
//            alert.show()
            Util.sharedInstant().showMessage(self, messageWith: message)
        }
        return result
    }

    func isValidEmail(testStr:String) -> Bool {
        // println("validate calendar: \(testStr)")
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,6}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluateWithObject(testStr)
    }

    
    @IBAction func onSelectBrithDay(sender: AnyObject) {
        textfieldUserName.resignFirstResponder()
        textfieldPassword.resignFirstResponder()
        textfieldConfirmPass.resignFirstResponder()
        textfieldEmail.resignFirstResponder()
        textfieldSurname.resignFirstResponder()
        textfieldPhone.resignFirstResponder()
        textfieldZipcode.resignFirstResponder()
        birthdayPickerSheet.hidden = false
    }
    
    @IBAction func onDonePicker(sender: AnyObject) {
        birthdayPickerSheet.hidden = true
        textfieldBirthday.text = birthday_month + "/" + birthday_day
    }
    @IBAction func onCancelPicker(sender: AnyObject) {
        birthdayPickerSheet.hidden = true
        birthday_month = ""
        birthday_day = ""
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
