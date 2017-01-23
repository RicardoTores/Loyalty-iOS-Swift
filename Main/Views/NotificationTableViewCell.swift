//
//  MessageTableViewCell.swift
//  Loyalty
//
//  Created by striver on 12/12/15.
//  Copyright © 2015 Colectivo Coffee Roasters Inc. All rights reserved.
//

import UIKit

protocol NotificationTableViewCellDelegate {
    func onDeleteCell(cell: NotificationTableViewCell)
//    func onSetCellasRead(cell: NotificationTableViewCell)
}

class NotificationTableViewCell: SWTableViewCell, SWTableViewCellDelegate{
    @IBOutlet weak var labelMessageText: UILabel!
    @IBOutlet weak var messageDate: UILabel!
    //@IBOutlet weak var labelDate: UILabel!
    //@IBOutlet weak var labelTitle: UILabel!
    //@IBOutlet weak var imageviewIndicator: UIImageView!
 
    var entity : MessageEntity?
    var notificationCellDelegate: NotificationTableViewCellDelegate?

    func setupUI(info:MessageEntity){
        
        entity = info
        //labelTitle.text = entity?.title as? String
        //let util : Util = Util.sharedInstant() as! Util
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "dd MMM yyy"
        //        dateFormatter.dateStyle = NSDateFormatterStyle.MediumStyle
        let dateObj = dateFormatter.stringFromDate((entity?.date)!)
        messageDate.text = dateObj//NSDate.string//util.timeLeftSinceDate(entity?.date)
        labelMessageText.text = entity?.message as? String
        //imageviewIndicator.clipsToBounds = true;
        //imageviewIndicator.layer.cornerRadius = imageviewIndicator.frame.size.width / 2.0;

        if entity!.isRead {
            //imageviewIndicator.hidden = true
        }else{
            //imageviewIndicator.hidden = false
        }
        
        self.rightUtilityButtons = self.rightButtons() as [AnyObject]
        self.setLeftUtilityButtons(self.leftButtons() as [AnyObject], withButtonWidth: 70.0)
        
        self.delegate = self

    }
    
    // SWTabelViewCellDelegate
    func swipeableTableViewCell(cell: SWTableViewCell!, canSwipeToState state: SWCellState) -> Bool {
        return true
    }
    
    
    // click event on left utility button
    func swipeableTableViewCell(cell: SWTableViewCell!, didTriggerLeftUtilityButtonWithIndex index: Int) {
        switch index {
        case 0:
            self.onSetCellasRead()
            self.hideUtilityButtonsAnimated(true)
            break
        default:
            break
        }
    }
    
    // click event on right utility button
    func swipeableTableViewCell(cell: SWTableViewCell!, didTriggerRightUtilityButtonWithIndex index: Int) {
        switch index {
        case 0:
            if let _ = self.entity {
                self.notificationCellDelegate?.onDeleteCell(self)
                self.hideUtilityButtonsAnimated(true)
            }
            break
        default:
            break
        }
    }
    
    // utility button open/close event
    func swipeableTableViewCell(cell: SWTableViewCell!, scrollingToState state: SWCellState) {
        //
    }
    
    func swipeableTableViewCellDidEndScrolling(cell: SWTableViewCell!) {
        //
    }
    
    // prevent multiple cells from showing utilty buttons simultaneously
    func swipeableTableViewCellShouldHideUtilityButtonsOnSwipe(cell: SWTableViewCell!) -> Bool {
        return true
    }
    
    func rightButtons() -> NSArray {
        let rightUtilityButtons = NSMutableArray()
        rightUtilityButtons.sw_addUtilityButtonWithColor(UIColor(red: 1.0, green: 0.231, blue: 0.188, alpha: 1.0), title: "Delete")
        return rightUtilityButtons
    }
    
    func leftButtons() -> NSArray {
        let leftUtilityButtons = NSMutableArray()
        
        let button = UIButton(type: UIButtonType.Custom)
        button.backgroundColor = UIColor(red: 0.0392, green: 0.3765, blue: 1.0, alpha: 1.0)
        button.titleLabel!.lineBreakMode =  NSLineBreakMode.ByWordWrapping
        button.titleLabel!.textAlignment = NSTextAlignment.Center;
        if entity?.isRead == true{
            button.setTitle("Set as\nUnread", forState: UIControlState.Normal)
        }else{
            button.setTitle("Set as\nRead", forState: UIControlState.Normal)
        }
        button.setTitleColor(UIColor.whiteColor(), forState:UIControlState.Normal);
        leftUtilityButtons.addObject(button)
        return leftUtilityButtons
    }
    
    func onSetCellasRead(){
        entity!.isRead = !entity!.isRead
        NSNotificationCenter.defaultCenter().postNotificationName("refreshBadgeNum", object: nil);
        self.setupUI(entity!)
    }
    
    // When clicked the close(x) button
    @IBAction func onClickCloseButton(sender: AnyObject) {
        if let _ = self.entity {
            self.notificationCellDelegate?.onDeleteCell(self)
        }
        
    }
    
}
