//
//  MenuDetailsViewContoller.swift
//  Loyalty
//
//  Created by bongbong on 5/2/16.
//  Copyright © 2016 Colectivo Coffee Roasters Inc. All rights reserved.
//

import UIKit


class MenuDetailsViewController: UIViewController {

    @IBOutlet weak var menuImageView: ImageScrollView!
    
    var menuImageName = "Menus_Food_General"
    
    override func viewDidLoad() {
        let image = UIImage(named: menuImageName)
        menuImageView.displayImage(image!)
    }
    
    @IBAction func onClickBack(sender: AnyObject) {
        
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}
