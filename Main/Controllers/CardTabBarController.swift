//
//  CardTabBarController.swift
//  Loyalty
//
//  Created by striver on 12/14/15.
//  Copyright © 2015 Colectivo Coffee Roasters Inc. All rights reserved.
//

import UIKit

class CardTabBarController: UITabBarController {

    @IBOutlet weak var mTabBar: UITabBar!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        // register notifications refreshBadgeNum
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(CardTabBarController.switchCardDetails(_:)), name: "switchCardDetails", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(CardTabBarController.refreshBadgeNum(_:)), name: "refreshBadgeNum", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(CardTabBarController.gotoLogin(_:)), name: "gotoLogin", object: nil)

        let done = USERMANAGER.isLoginDone();
        if done {
            
        }else{
            self.gotoLogin(nil)
        }

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        refreshBadgeNum(nil)
    }
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
       /// UITabBar.appearance().setTintColor
        
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    override func viewWillLayoutSubviews() {
        var tabFrame = self.mTabBar.frame;
        tabFrame.size.height = 30;
        tabFrame.origin.y = self.view.frame.size.height - 30;
        self.tabBar.frame = tabFrame;
   
        let font = UIFont(name: "Lato-Bold", size: 13)
        
        let unselectedColors = NSArray(objects: font!, UIColor.whiteColor())
        let selectedColors = NSArray(objects: font!, UIColor.blackColor())
        let keys = NSArray(objects: NSFontAttributeName, NSForegroundColorAttributeName)
        
        UITabBarItem.appearance()
        for item in self.mTabBar.items! {
            item.setTitleTextAttributes(NSDictionary(objects: unselectedColors as [AnyObject], forKeys: keys as! [NSCopying]) as? [String : AnyObject], forState: UIControlState.Normal)
            item.setTitleTextAttributes(NSDictionary(objects: selectedColors as [AnyObject], forKeys: keys as! [NSCopying]) as? [String : AnyObject], forState: UIControlState.Selected)
            
        }
    }
    
    override func tabBar(tabBar: UITabBar, didSelectItem item: UITabBarItem) {

    }
    
    func switchCardDetails(notif: NSNotification){
        self.selectedIndex = 0;
    }
    
    func refreshBadgeNum(notif: NSNotification?){
        let tabArray = self.tabBar.items as NSArray!
        let notitab = tabArray.objectAtIndex(1) as! UITabBarItem
        let count = USERMANAGER.getCountNotReadNotification()
        if count == 0 {
            notitab.badgeValue = nil
        }else{
            notitab.badgeValue = "\(count)"
        }
    }
    
    func gotoLogin(notif: NSNotification?){
        let vc = self.storyboard?.instantiateViewControllerWithIdentifier("SignViewController") as! SignViewController
        self.navigationController?.pushViewController(vc, animated: false)

    }

}
