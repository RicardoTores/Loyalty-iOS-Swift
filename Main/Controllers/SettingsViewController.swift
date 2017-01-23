//
//  SettingsViewController.swift
//  Loyalty
//
//  Created by striver on 12/19/15.
//  Copyright © 2015 Colectivo Coffee Roasters Inc. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    let listTitle = ["MY PROFILE", "SIGN OUT"]
    let listImageName = ["profile", "Logout"]
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    // MARK: DELEGATE
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        switch indexPath.row
        {
            case 0 : //  Profile
                let vc = self.storyboard?.instantiateViewControllerWithIdentifier("ProfileViewController");
                self.navigationController?.pushViewController(vc!, animated: true)
                break
            case 1 : // Logout
                USERMANAGER.getCurrentLoyaltyUser().islogindone = false
                USERMANAGER.setCurrentLoyaltyUser(USERMANAGER.getCurrentLoyaltyUser())
                USERMANAGER.setCurrentUserEntity(USERMANAGER.getCurrentUserEntity())
                NSNotificationCenter.defaultCenter().postNotificationName("switchCardDetails", object: nil)
                NSNotificationCenter.defaultCenter().postNotificationName("gotoLogin", object: nil);
                break
            default :
                break
        }
    }
    
    // MARK: DATASOURCE
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let row: Int = indexPath.row
        let cell : SettingsTableCell = tableView.dequeueReusableCellWithIdentifier("SettingsTableCell") as! SettingsTableCell
        //cell.imageviewMark.image = UIImage(named: listImageName[row])
        cell.labelTitle.text = listTitle[row]
        return cell
    }
    
}
