//
//  WebService.swift
//  Loyalty
//
//  Created by striver on 12/14/15.
//  Copyright © 2015 Colectivo Coffee Roasters Inc. All rights reserved.
//

import UIKit
import Foundation

let WEBSERVICE : WebService  = WebService()

class WebService: NSObject {
    
    var storelist: NSMutableArray?
    func getService(url : String, param: [String : AnyObject], success:(response : NSData) -> Void, fail:(error : NSError)-> Void){
        do {
            let opt = try HTTP.GET(url, parameters: param)
            
            opt.start { response in
                if let err = response.error {
                    print("error: \(err.localizedDescription)")
                    fail(error: err)
                    return //also notify app of failure as needed
                }
                
                print("opt finished: \(response.text)")
                if let data = response.text!.dataUsingEncoding(NSUTF8StringEncoding) {
                    success(response : data)
                }
            }
        } catch let error {
            print("got an error creating the request: \(error)")
            fail(error:error as NSError)
        }
    }
    
    func getStoreListFromServer(success:() -> Void, fail:()-> Void){
        //      http://loyalty.yakuma.com/ws_app_service.php?is_base64=0&f_name=app_getstorelist&m_id=999999999999
        do {
            let v:String = String(2.0).toBase64String()
            let app : String = String("ios").toBase64String()
            let is_base64 : String = String("0").toBase64String()
            let f_name : String = String("app_getstorelist").toBase64String()
            let m_id :String = String(Settings.API_MERCHANT_ID).toBase64String()
            let dic : [String : AnyObject] = [
                "v":            v,
                "app":          app,
                "is_base64":    is_base64,
                "f_name":       f_name,
                "m_id":         m_id]
            
//            let requestUrl = Settings.API_URL + "&is_base64=0&f_name=" +
//                             Settings.APIFNC_STORE_LIST +
//                            "&m_id=" + String(Settings.API_MERCHANT_ID)
            
            let opt = try HTTP.POST(Settings.API_URL, parameters: dic)
            
            opt.start { response in
                if let err = response.error {
                    print("error: \(err.localizedDescription)")
                    fail()
                    return //also notify app of failure as needed
                }
                
                print("opt finished: \(response.text)")
                if let data = response.text!.dataUsingEncoding(NSUTF8StringEncoding) {
                    let status = ErrorEntity(JSONDecoder(data).dictionary!)
                    if let _ = status.key {
//                        let alert = UIAlertView.init(title: nil, message:status.msg as? String, delegate: nil, cancelButtonTitle: "OK")
//                        alert.show()
                        return
                    }
                    self.storelist  = StoreList(JSONDecoder(data)).storelist
                    success()
                }
            }
        } catch let error {
            print("got an error creating the request: \(error)")
            fail()
        }
    }
    
    func getCardInfoFromServer(success:(data : NSData) -> Void, fail:()-> Void){
        //        http://loyalty.yakuma.com/ws_app_service.php?
        //        is_base64=0&f_name=app_getcardinfo&ws_u=my_user&ws_p=myMD5password&hash=theMD5ha
        //        sh&m_id=999999999999
        //        MD5(app_getcardinfo+theusername+theMD5password+demo)
        
        do {
            let v = String(2.0).toBase64String()
            let app = String("ios").toBase64String()
            let is_base64 = String(0).toBase64String()
            let f_name = Settings.APIFNC_GET_CARD_INFO.toBase64String()
            let ws_u = USERMANAGER.getCurrentLoyaltyUser().username as! String
            let ws_u_base64 = (USERMANAGER.getCurrentLoyaltyUser().username as! String).toBase64String()
            let ws_p = USERMANAGER.getCurrentLoyaltyUser().password as! String
            let ws_p_base64 = (USERMANAGER.getCurrentLoyaltyUser().password as! String).toBase64String()
            let hash = Settings.APIFNC_GET_CARD_INFO + ws_u + ws_p + Settings.API_SECRET_KEY
            let m_id = String(Settings.API_MERCHANT_ID).toBase64String()
            let dic : [String : AnyObject] = ["v" : v,
                                              "app" : app,
                                              "is_base64": is_base64,
                                              "f_name": f_name,
                                              "ws_u" : ws_u_base64,
                                              "ws_p" : ws_p_base64,
                                              "hash" : hash.toMD5().toBase64String(),
                                              "m_id": m_id]
//            let requestUrl = Settings.API_URL + "&is_base64=0&f_name=" +
//                            Settings.APIFNC_GET_CARD_INFO + "&ws_u=" + ws_u +
//                            "&ws_p=" + ws_p + "&hash=" + hash.toMD5() +
//                            "&m_id=" + String(Settings.API_MERCHANT_ID)
            let opt = try HTTP.POST(Settings.API_URL, parameters: dic)
            
            opt.start { response in
                if let err = response.error {
                    print("error: \(err.localizedDescription)")
                    fail()
                    return //also notify app of failure as needed
                }
                
                print("opt finished: \(response.text)")
                if let data = response.text!.dataUsingEncoding(NSUTF8StringEncoding) {
                    success(data: data)
                }
            }
        } catch let error {
            print("got an error creating the request: \(error)")
            fail()
        }
    }
    
    func login(param: [String : AnyObject], success:(data:NSData) -> Void, fail:()-> Void){
        //http://loyalty.yakuma.com/ws_app_service.php?
        //is_base64=0&f_name=app_signin&ws_u=valid&ws_p=9f7d0ee82b6a6ca7ddeae841f3253059&h
        //ash=307d35bfe5dfa0b25cff2432bf13b231&fncp=the_device_token&m_id=999999999999
        //MD5(app_signin+theusername+theMD5password+demo)
        do {
            let v = String(2.0).toBase64String()
            let app = String("ios").toBase64String()
            let is_base64 = String(0).toBase64String()
            let ws_u = param[PropertyKey.usernameKey] as! String
            let ws_p = param[PropertyKey.passwordKey] as! String
            let ws_u_base64 = (param[PropertyKey.usernameKey] as! String).toBase64String()
            let ws_p_base64 = (param[PropertyKey.passwordKey] as! String).toBase64String()
            let hash = (Settings.APIFNC_LOGIN + ws_u + ws_p + Settings.API_SECRET_KEY)
            let token = (USERMANAGER.getCurrentUserEntity().user_info!.device_token as! String).toBase64String()
            let m_id = String(Settings.API_MERCHANT_ID).toBase64String()
            let f_name = Settings.APIFNC_LOGIN.toBase64String()
            
            let dic : [String : AnyObject] = ["v" : v,
                                              "app" : app,
                                              "is_base64": is_base64,
                                              "f_name": f_name,
                                              "ws_u" : ws_u_base64,
                                              "ws_p" : ws_p_base64,
                                              "hash" : hash.toMD5().toBase64String(),
                                              "fncp" : token,
                                              "m_id": m_id]
            
//            let requestUrl = Settings.API_URL + "&is_base64=0&f_name=" +
//                Settings.APIFNC_LOGIN + "&ws_u=" + ws_u +
//                "&ws_p=" + ws_p + "&hash=" + hash.toMD5() + "&fncp=" + token +
//                "&m_id=" + String(Settings.API_MERCHANT_ID)
            
            let opt = try HTTP.POST(Settings.API_URL, parameters: dic)
            
            opt.start { response in
                if let err = response.error {
                    print("error: \(err.localizedDescription)")
                    fail()
                    return //also notify app of failure as needed
                }
                print("opt finished: \(response.description)")
                
                if let data = response.text!.dataUsingEncoding(NSUTF8StringEncoding) {
                    success(data: data)
                }
            }
        } catch let error {
            print("got an error creating the request: \(error)")
            fail()
        }
    }
    
    func signup(param: [String : AnyObject], success:(data : NSData) -> Void, fail:()-> Void){
        //http://loyalty.yakuma.com/ws_app_service.php?
        //is_base64=0&f_name=app_signup&ws_u=theusername&ws_p=theMD5password&
        //hash=theMD5hash&fncp=the_device_token|the_repeated_password|alex|alex@test.com|6234567890|
        //es08000|avenue%20111|31|12|0|0&m_id=999999999999
        //MD5(app_signup+theusername+name+email+demo)
        do {
            let ws_u = param[PropertyKey.usernameKey] as! String
            let name = param[PropertyKey.nameKey] as! String
            let ws_p = param[PropertyKey.passwordKey] as! String
            let email = param[PropertyKey.emailKey] as! String
            let phone = param[PropertyKey.phoneKey] as! String
            let zipcode = param[PropertyKey.zipcodeKey] as! String
            let birthday_month = param[PropertyKey.birthday_monthKey] as! String
            let birthday_day = param[PropertyKey.birthday_dayKey] as! String
            let address = ""
            let hash = Settings.APIFNC_SIGNUP + ws_u + name + email + Settings.API_SECRET_KEY
            let token = USERMANAGER.getCurrentUserEntity().user_info!.device_token as! String
            let fncp = token + "|" + ws_p + "|" + name + "|" + email + "|" + phone + "|" + zipcode + "|" + address + "|" + birthday_month + "|" + birthday_day
            let v = "2.0"
            let app = "ios"
            let m_id = String(Settings.API_MERCHANT_ID)
            let is_base64 = "0"
            
            let dic : [String : AnyObject] = ["v" : v.toBase64String(),
                                              "app" : app.toBase64String(),
                                              "is_base64": is_base64.toBase64String(),
                                              "f_name": Settings.APIFNC_SIGNUP.toBase64String(),
                                              "ws_u" : ws_u.toBase64String(),
                                              "ws_p" : ws_p.toBase64String(),
                                              "hash" : hash.toMD5().toBase64String(),
                                              "fncp" : fncp.toBase64String(),
                                              "m_id":m_id.toBase64String()]
            
//            let requestUrl = Settings.API_URL + "&is_base64=0&f_name=" +
//                Settings.APIFNC_SIGNUP + "&ws_u=" + ws_u +
//                "&ws_p=" + ws_p + "&hash=" + hash.toMD5() + "&fncp=" + fncp +
//                "&m_id=" + String(Settings.API_MERCHANT_ID)

            let opt = try HTTP.POST(Settings.API_URL, parameters: dic)
            
            opt.start { response in
                if let err = response.error {
                    print("error: \(err.localizedDescription)")
                    fail()
                    return //also notify app of failure as needed
                }
                
                print("opt finished: \(response.description)")
                if let data = response.text!.dataUsingEncoding(NSUTF8StringEncoding) {
                    success(data: data)
                }
            }
        } catch let error {
            print("got an error creating the request: \(error)")
            fail()
        }
    }
    
    func updateCustomer(param: [String : AnyObject], success:(data:NSData) -> Void, fail:()-> Void){
        //http://loyalty.yakuma.com/ws_app_service.php?
        //is_base64=0&
        //f_name=app_updatecustomer&
        //ws_u=theusername&
        //ws_p=theMD5password&
        //hash=theMD5hash&
        //fncp=the_device_token|name|email|phone|zipcode|address|birthday_day|birthday_mohth|accept_push|accept_emails|new_password|new_repeated_password&
        //m_id=999999999999
        
        //MD5(app_updatecustomer+theusername+name+email+demo)
        do {
            let name = param[PropertyKey.nameKey] as! String
            let ws_u = USERMANAGER.getCurrentLoyaltyUser().username as! String
            let ws_p = USERMANAGER.getCurrentLoyaltyUser().password as! String
            let email = param[PropertyKey.emailKey] as! String
            let phone = param[PropertyKey.phoneKey] as! String
            let zipcode = param[PropertyKey.zipcodeKey] as! String
            let userInfo = USERMANAGER.getCurrentUserEntity().user_info;
            NSLog("\(userInfo)");
            let address = "";//USERMANAGER.getCurrentUserEntity().user_info!.address as! String
            let birthday_day = param[PropertyKey.birthday_dayKey] as! String; // USERMANAGER.getCurrentUserEntity().user_info!.birthday_day as! String
            let birthday_month = param[PropertyKey.birthday_monthKey] as! String;//USERMANAGER.getCurrentUserEntity().user_info!.birthday_month as! String
            let accept_push = ""//USERMANAGER.getCurrentUserEntity().user_info!.accept_push as! String
            let accept_emails = ""//USERMANAGER.getCurrentUserEntity().user_info!.accept_emails as! String
            let new_password = param[PropertyKey.passwordKey] as! String
            let new_repeated_password = param[PropertyKey.confirmpasswordKey] as! String
            
            let hash = Settings.APIFNC_UPDATE_CUSTOMER + ws_u + name + email + Settings.API_SECRET_KEY
            let token = USERMANAGER.getCurrentUserEntity().user_info!.device_token as! String
            let fncp = token + "|" + name + "|" + email + "|" + phone + "|" + zipcode + "|" + address + "|" + birthday_day + "|" + birthday_month + "|" + accept_push + "|" + accept_emails + "|" + (new_password == "" ? "" : new_password) + "|" + (new_repeated_password == "" ? "" :new_repeated_password)
            
            let v = "2.0"
            let app = "ios"
            let is_base64 = "0"
            let m_id = String(Settings.API_MERCHANT_ID)
            let dic : [String : AnyObject] = ["v" : v.toBase64String(),
                                              "app" : app.toBase64String(),
                                              "is_base64": is_base64.toBase64String(),
                                              "f_name": Settings.APIFNC_UPDATE_CUSTOMER.toBase64String(),
                                              "ws_u" : ws_u.toBase64String(),
                                              "ws_p" : ws_p.toBase64String(),
                                              "hash" : hash.toMD5().toBase64String(),
                                              "fncp" : fncp.toBase64String(),
                                              "m_id":m_id.toBase64String()]
            
//            let requestUrl = Settings.API_URL + "&is_base64=0&f_name=" +
//                Settings.APIFNC_UPDATE_CUSTOMER + "&ws_u=" + ws_u +
//                "&ws_p=" + ws_p + "&hash=" + hash.toMD5() + "&fncp=" + fncp +
//                "&m_id=" + String(Settings.API_MERCHANT_ID)
            
            let opt = try HTTP.POST(Settings.API_URL, parameters: dic)
            
            opt.start { response in
                if let err = response.error {
                    print("error: \(err.localizedDescription)")
                    fail()
                    return //also notify app of failure as needed
                }
                
                print("opt finished: \(response.text)")
                if let data = response.text!.dataUsingEncoding(NSUTF8StringEncoding) {
                    success(data: data)
                }
            }
        } catch let error {
            print("got an error creating the request: \(error)")
            fail()
        }
    }
    
    // for Push testing
    func testPush(param: [String : String], success:() -> Void, fail:()-> Void){
        do {
            let opt = try HTTP.POST(Settings.SAVE_TOKEN_URL, parameters: param)
            
            opt.start { response in
                if let err = response.error {
                    print("error: \(err.localizedDescription)")
                    fail()
                    return //also notify app of failure as needed
                }
                
                print("opt finished: \(response.text)")
                if let _ = response.text!.dataUsingEncoding(NSUTF8StringEncoding) {
                    success()
                }
            }
        } catch let error {
            print("got an error creating the request: \(error)")
            fail()
        }
    }
    
    func getPushList(param:[String : String], success:(data:NSData) -> Void, fail:()-> Void){
        do {
            let opt = try HTTP.POST(Settings.GET_PUSH_MESSAGE_URL, parameters: param)
            
            opt.start { response in
                if let err = response.error {
                    print("error: \(err.localizedDescription)")
                    fail()
                    return //also notify app of failure as needed
                }
                
                print("opt finished: \(response.text)")
                if let data = response.text!.dataUsingEncoding(NSUTF8StringEncoding) {
                    success(data: data)
                }
            }
        } catch let error {
            print("got an error creating the request: \(error)")
            fail()
        }
    }
    
    func getCurrentServerDate(successed:(servertime:String?) -> Void){
        let param = ["from":""]
        WEBSERVICE.getPushList(param,
                               success: {data in
                                dispatch_async(dispatch_get_main_queue()) {
                                    let json = JSONDecoder(data)
                                    if let success = json["succeeded"].string {
                                        if success == "OK" {
                                            if let pushlist = json["data"].array {
                                                if pushlist.count > 0 {
                                                    let decoder = pushlist[0]
                                                    if let aDecoder = decoder[PropertyKey.dateServerKey].string{
                                                        successed(servertime: aDecoder)
                                                    }
                                                }
                                            }
                                        }
                                    }
                                }
            },
                               fail: {
                                dispatch_async(dispatch_get_main_queue()) {
//                                    let alert = UIAlertView.init(title: nil, message: "Server connection error!", delegate: nil, cancelButtonTitle: "OK")
//                                    alert.show()
                                    let alertController = UIAlertController(title: nil, message: "Server connection error!", preferredStyle: .Alert)
                                    alertController.show()
                                }
        })
    }
}
