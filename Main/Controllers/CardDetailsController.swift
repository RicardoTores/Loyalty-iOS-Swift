//
//  CardDetailsController.swift
//  Loyalty
//
//  Created by Alex on 04/10/15.
//  Copyright © 2015 Colectivo Coffee Roasters Inc. All rights reserved.
//

import UIKit
//import ACFramework

class CardDetailsController: UIViewController {
    
    @IBOutlet weak var imgQRCode: UIImageView!
    @IBOutlet weak var labelQRCode: UILabel!
    @IBOutlet weak var labelGift: UILabel!
    @IBOutlet weak var labelLoyalty: UILabel!
    
    @IBOutlet weak var cutomerName: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        // register notifications
        let nc = NSNotificationCenter.defaultCenter()
        nc.addObserver(self, selector:#selector(CardDetailsController.refreshUI(_:)), name:"refreshUI", object: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
            refreshUI(nil)
    }
    
    @IBAction func onRefresh(sender: AnyObject) {
        Util.sharedInstant().showHub(true)
        WEBSERVICE.getCardInfoFromServer(
            {data in
                dispatch_async(dispatch_get_main_queue()) {
                    Util.sharedInstant().showHub(false)
                    let status = ErrorEntity(JSONDecoder(data).dictionary!)
                    if let _ = status.key {
//                        let alert = UIAlertView.init(title: nil, message:status.msg as? String, delegate: nil, cancelButtonTitle: "OK")
//                        alert.show()
                        Util.sharedInstant().showMessage(self, messageWith: status.msg as? String);                       return
                    }
                    let json = JSONDecoder(data)
                    if let aDec = json["card_balance"].value{
                        let entity = CardBalance(aDec as! Dictionary<String,JSONDecoder>)
                        USERMANAGER.getCurrentUserEntity().card_balance = entity
                    }
                    self.refreshUI(nil)
                }
            },
            fail: {
                dispatch_async(dispatch_get_main_queue()) {
                    Util.sharedInstant().showHub(false)
//                    let alert = UIAlertView.init(title: nil, message: "Server connection error!", delegate: nil, cancelButtonTitle: "OK")
//                    alert.show()
                    Util.sharedInstant().showMessage(self, messageWith: "Server connection error!")
                }
        })

    }
    func refreshUI(notifi:NSNotification?){
        let userentity = USERMANAGER.getCurrentUserEntity()
        // QRcode
        var qrCodeInfo: QRCode = QRCode((userentity.user_info?.card)! as String)!
        
        if qrCodeInfo.image != nil {
            qrCodeInfo.size = CGSize(width: imgQRCode.frame.width, height: imgQRCode.frame.height)
            qrCodeInfo.color = CIColor(rgba: "000")
            qrCodeInfo.backgroundColor = CIColor(rgba: "fff")
            
            //imgQRCode.image = generateQRCodeFromString((userentity.user_info?.card)! as String)// qrCodeInfo.image
            imgQRCode.image = generatePDF417BarcodeFromString((userentity.user_info?.card)! as String)
        }
        labelQRCode.text = userentity.user_info?.card as? String
        cutomerName.text = userentity.user_info?.name as? String
        
        // Loyalty Balance
        let loyaltyBalance = userentity.card_balance?.loyalty_points!.doubleValue
        print("loyaltyBalance: \(loyaltyBalance)")
        labelLoyalty.text = String(format: "%.0f", loyaltyBalance!)
        
        // Gift Balance
        labelGift.text = "$" + ((userentity.card_balance?.gift_balance)! as String) as String// + " USD"
    }
    
    func generateQRCodeFromString(string: String) -> UIImage? {
        let data = string.dataUsingEncoding(NSISOLatin1StringEncoding)
        
        if let filter = CIFilter(name: "CIQRCodeGenerator") {
            filter.setValue(data, forKey: "inputMessage")
            filter.setValue("H", forKey: "inputCorrectionLevel")
            let transform = CGAffineTransformMakeScale(10, 10)
            
            if let output = filter.outputImage?.imageByApplyingTransform(transform) {
                return UIImage(CIImage: output)
            }
        }
        
        return nil
    }
    
    func generatePDF417BarcodeFromString(string: String) -> UIImage? {
        let data = string.dataUsingEncoding(NSISOLatin1StringEncoding)
        
        if let filter = CIFilter(name: "CIPDF417BarcodeGenerator") {
            filter.setValue(data, forKey: "inputMessage")
            let transform = CGAffineTransformMakeScale(2, 2)
            
            if let output = filter.outputImage?.imageByApplyingTransform(transform) {
                return UIImage(CIImage: output)
            }
        }
        
        return nil
    }
    
    
    
    
    

}
