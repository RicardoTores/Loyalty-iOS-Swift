//
//  MessageViewController.swift
//  Loyalty
//
//  Created by striver on 12/16/15.
//  Copyright © 2015 Colectivo Coffee Roasters Inc. All rights reserved.
//

import UIKit

class MessageViewController: UIViewController {
    
    @IBOutlet weak var barbtnSetAsNotRead: UIBarButtonItem!
    @IBOutlet weak var imageviewReadMark: UIImageView!
    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var textviewMessage: UITextView!
    @IBOutlet weak var labelDate: UILabel!
    @IBOutlet weak var labelTitle: UILabel!
    var message : MessageEntity?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        setupUI(message!)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    func setupUI(info:MessageEntity){
    
        message = info
        labelTitle.text = info.title as? String
        let util : Util = Util.sharedInstant() as! Util
        labelDate.text = util.timeLeftSinceDate(info.date)
        textviewMessage.text = info.message as? String
        if info.isRead {
            barbtnSetAsNotRead.title = "Set as not read"
            imageviewReadMark.image = UIImage(named: "checkmark-icon")
        }else{
            barbtnSetAsNotRead.title = "Set as read"
            imageviewReadMark.image = nil
        }

    }

    @IBAction func onBack(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func onSetAsNotRead(sender: AnyObject) {
        message!.isRead = !message!.isRead
        self.setupUI(message!)
    }

    @IBAction func onDelete(sender: AnyObject) {
        NSNotificationCenter.defaultCenter().postNotificationName("deleteMessage", object: message)
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}

