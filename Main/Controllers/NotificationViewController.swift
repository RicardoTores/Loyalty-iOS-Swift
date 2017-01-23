//
//  NotificationViewController.swift
//  Loyalty
//
//  Created by striver on 12/16/15.
//  Copyright © 2015 Colectivo Coffee Roasters Inc. All rights reserved.
//

import UIKit

class NotificationViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, NotificationTableViewCellDelegate{
    @IBOutlet weak var tableviewNotificationList: UITableView!
     var refreshControl:UIRefreshControl!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        // register notifications
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(NotificationViewController.refreshNotificationVC(_:)), name: "refreshNotificationVC", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(NotificationViewController.deleteMessage(_:)), name: "deleteMessage", object: nil)

        self.refreshControl = UIRefreshControl()
        self.refreshControl.addTarget(self, action: #selector(NotificationViewController.refresh(_:)), forControlEvents: UIControlEvents.ValueChanged)
        self.tableviewNotificationList.addSubview(refreshControl)
        USERMANAGER.downMyNotificationList()

        self.tableviewNotificationList.estimatedRowHeight = 40;
        self.tableviewNotificationList.rowHeight = UITableViewAutomaticDimension;
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        refreshNotificationVC(nil)
    }
    
    func refresh(sender:AnyObject) {
        USERMANAGER.downMyNotificationList()
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
        let vc = self.storyboard?.instantiateViewControllerWithIdentifier("MessageViewController") as! MessageViewController;
        self.navigationController?.presentViewController(vc, animated: true, completion: nil)
        let entity : MessageEntity = USERMANAGER.getNotificationList().objectAtIndex(indexPath.row) as! MessageEntity
        entity.isRead = true
        vc.setupUI(entity)

    }
    
    // MARK: DATASOURCE
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return USERMANAGER.getNotificationList().count
    }
    /*
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 50
    }
 */
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let row: Int = indexPath.row
        let cell = tableView.dequeueReusableCellWithIdentifier("NotificationTableViewCell") as! NotificationTableViewCell
        cell.setupUI(USERMANAGER.getNotificationList().objectAtIndex(row) as! MessageEntity)
        //cell.labelMessageText.text =
        cell.notificationCellDelegate = self
        return cell
    }
    
    
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {

    }
    
    func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
        
    }
    
    func refreshNotificationVC(notif: NSNotification?){
        // tell refresh control it can stop showing up now
        if self.refreshControl.refreshing
        {
            self.refreshControl.endRefreshing()
        }
        tableviewNotificationList.reloadData()
    }
    
    // NotificationTableViewCellDelegate 
    func onDeleteCell(cell: NotificationTableViewCell) {
        if let message = cell.entity {
            self.deleteNotification(message)
        }
    }

    func deleteMessage(notifi:NSNotification){
        if let message = notifi.object as? MessageEntity{
            self.deleteNotification(message)
        }
    }
    
    func deleteNotification(message: MessageEntity){
        USERMANAGER .getNotificationList().removeObject(message)
        USERMANAGER.setNotificationList(USERMANAGER.getNotificationList())
        NSNotificationCenter.defaultCenter().postNotificationName("refreshBadgeNum", object: nil);
        self.tableviewNotificationList.reloadData()
    }
}
