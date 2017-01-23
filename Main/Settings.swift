//
//  Settings.swift
//  Loyalty
//
//  Created by Alex on 04/10/15.
//  Copyright © 2015 Colectivo Coffee Roasters Inc. All rights reserved.
//

import Foundation

class Settings {

    static let GOOGLE_API_KEY: String = "AIzaSyDSIE7z1wobkVjF3OC3k-WR356-NgwQPA8" //"AIzaSyBl0vB4AZ4AAAGk3pui-8kFk0gdtwV2E44"//
    static let API_URL: String = "http://uranium.colectivocoffee.com/yakuma_livedata/ws_app_service.php"
    //static let API_URL: String = "http://loyalty.yakuma.com/ws_app_service.php?v=2.0&app=ios"
    
//    static let API_URL: String = "http://demoloyalty.yakuma.com/ws_app_service.php"
    
    static let API_MERCHANT_ID: NSNumber = NSNumber(longLong: 999999999999)
    static let API_SECRET_KEY: String = "C013kt1v0_K0ffee%$"// "demo"
    
    static let STORE_IMAGE_TEMPLATE_URL = "http://loyalty.yakuma.com/img/merchant1/%@.jpg" 

    // test push url
    static let SAVE_TOKEN_URL = "http://www.hoodclips.com/api/save_token.php"
    static let GET_PUSH_MESSAGE_URL = "http://www.hoodclips.com/api/get_push.php"
    // API Functions
    static let APIFNC_LOGIN: String = "app_signin"
    static let APIFNC_SIGNUP: String = "app_signup"
    static let APIFNC_STORE_LIST: String = "app_getstorelist"
    static let APIFNC_UPDATE_CUSTOMER: String = "app_updatecustomer"
    static let APIFNC_GET_CARD_INFO: String = "app_getcardinfo"
    static let APIFNC_UPDATE_PASSWORD: String = "app_updatepassword"
    static let GOOGLE_MAP_DEAULT_ZOOM_LEVEL:Float = 10.0
    
    static let MONTH_DATA_SOURCE = ["January", "February ", "March", "April ", "May", "June", "July", "August", "September", "October", "November", "December"]
    static let DAY_DATA_SOURCE = ["01", "02", "03", "04", "05", "06", "07", "09", "10", "11", "12", "13", "14", "15", "16", "17", "18", "19", "20", "21", "22", "23", "24", "25", "26", "27", "28", "29", "30", "31"]
}
