//
//  ViewController.swift
//  newsApp
//
//  Created by vicente rodriguez on 2/24/16.
//  Copyright © 2016 vicente rodriguez. All rights reserved.
//

import UIKit
import TwitterKit

class MainViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, TWTRTweetViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    var newsArray = [[String : String?]]()
    var tweets = [TWTRTweet]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getData()
        self.tableView.delegate = self
        self.tableView.dataSource = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    func getData() {
        Data.sharedInstance.getDataFromMostViews() {
           [unowned self] dic, error in
            if error != nil {
                return
            }
            
            self.newsArray = dic!
            
            dispatch_async(dispatch_get_main_queue()) {
                self.tableView.reloadData()
            }
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.newsArray.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath)
        
        let dic = self.newsArray[indexPath.item]
        let title = dic["title"]!
        let date = dic["date"]!
        cell.accessoryType = .DisclosureIndicator
        cell.textLabel!.text = title
        cell.detailTextLabel!.text = date
        return cell
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "getDetail" {
            let detailVC = segue.destinationViewController as! NewsDetailViewController
            
            let indexPath = self.tableView.indexPathForSelectedRow!
            let row = indexPath.row
            let title = newsArray[row]["title"]!
            let url = newsArray[row]["url"]!
            
            detailVC.stringTitle = title!
            detailVC.urlString = url!
        }
    }


}

