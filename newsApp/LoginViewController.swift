//
//  LoginViewController.swift
//  newsApp
//
//  Created by vicente rodriguez on 3/16/16.
//  Copyright © 2016 vicente rodriguez. All rights reserved.
//

import UIKit
import TwitterKit

class LoginViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func twitterButton(sender: AnyObject) {
        Twitter.sharedInstance().logInWithCompletion {
            session, error in
            if session != nil {
                print("hola \(session?.userName)")
                self.performSegueWithIdentifier("searchController", sender: nil)
            } else {
                print("error", error?.localizedDescription)
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
