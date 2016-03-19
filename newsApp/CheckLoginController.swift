//
//  CheckLoginController.swift
//  newsApp
//
//  Created by vicente rodriguez on 3/16/16.
//  Copyright © 2016 vicente rodriguez. All rights reserved.
//

import UIKit
import TwitterKit

class CheckLoginController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        //self.tabBar.tintColor = UIColor(red: 142, green: 68, blue: 173, alpha: 1.0)
        //rgba(142, 68, 173,1.0)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
        let userID: String? = Twitter.sharedInstance().sessionStore.session()?.userID
        if (userID == nil) {
            if let loginController = self.storyboard?.instantiateViewControllerWithIdentifier("loginController") as? LoginViewController {
                self.presentViewController(loginController, animated: true, completion: nil)
            }
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
