//
//  SearchViewController.swift
//  newsApp
//
//  Created by vicente rodriguez on 2/24/16.
//  Copyright © 2016 vicente rodriguez. All rights reserved.
//

import UIKit
import TwitterKit

class SearchViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate, UISearchResultsUpdating, TWTRTweetViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    var refreshControl: UIRefreshControl!
    var searhNewsArray = [[String: String?]]()
    var resultsSearchController = UISearchController()
    var addedRefresh: Bool = false
    var searchKey: String = ""
    var tweets = [TWTRTweet]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureSearchBar()
        configureTableView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - TableView
    func configureTableView() {
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.registerClass(TWTRTweetTableViewCell.self, forCellReuseIdentifier: "twitterCell")
        self.refreshControl = UIRefreshControl()
        self.refreshControl.addTarget(self, action: "refreshData", forControlEvents: .ValueChanged)
    }
    
    func configureSearchBar() {
        self.resultsSearchController = UISearchController(searchResultsController: nil)
        self.resultsSearchController.searchResultsUpdater = self
        self.resultsSearchController.searchBar.delegate = self
        self.resultsSearchController.dimsBackgroundDuringPresentation = true
        self.tableView.tableHeaderView = resultsSearchController.searchBar
        self.resultsSearchController.searchBar.sizeToFit()
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 60.0
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return "New York Times"
        case 1:
            return "Twitter"
        default:
            return "None"
        }
    }
    
    func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 100
        } else if indexPath.section == 1 {
            return 150
        } else {
            return 150
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCellWithIdentifier("searchCell", forIndexPath: indexPath) as! NewsYorkTableViewCell
            
            let dic = searhNewsArray[indexPath.row]
            
            if let title = dic["title"] {
                cell.titleLabel?.text = title
            } else {
                cell.titleLabel?.text = "no title"
            }
            if let date = dic["date"]{
                cell.subTitleLabel?.text = date
            }
            return cell
            
        } else if indexPath.section == 1 {
            let tweet = tweets[indexPath.row]
            let cell = tableView.dequeueReusableCellWithIdentifier("twitterCell", forIndexPath: indexPath) as! TWTRTweetTableViewCell
            cell.configureWithTweet(tweet)
            cell.tweetView.delegate = self
            return cell
        } else {
            let cell: UITableViewCell = tableView.dequeueReusableCellWithIdentifier("searchCell", forIndexPath: indexPath)
            return cell
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
         return searhNewsArray.count
        } else if section == 1 {
            return tweets.count
        } else {
            return 10
        }
    }
    
    func updateSearchResultsForSearchController(searchController: UISearchController) {
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        let text = searchBar.text!
        self.resultsSearchController.searchBar.resignFirstResponder()
        searchNewsData(query: text)
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.section == 0 {
            self.performSegueWithIdentifier("getDetail", sender: self)
        }
    }
    // MARK: - GetData
    
    func refreshData() {
        searchNewsData(query: self.searchKey)
    }
    
    func searchNewsData(query q: String) {
        let query = q.stringByReplacingOccurrencesOfString(" ", withString: "+")
        self.searchKey = query
        self.searhNewsArray = [[String: String?]]()
        
        Data.sharedInstance.getDataFromTweets(query: query) {
            [unowned self] (json, error) in
            if error != nil {
                print("error in tweets")
                return
            }

            self.tweets = TWTRTweet.tweetsWithJSONArray(json!["statuses"].object as! [AnyObject]) as! [TWTRTweet]
            
            dispatch_async(dispatch_get_main_queue()) {
                self.tableView.reloadData()
                self.tableView.reloadSections(NSIndexSet(index: 1), withRowAnimation: .Fade)
            }
        }
        
        Data.sharedInstance.getDataFromNews(query: query, onCompletion: {
            [unowned self] (dic, error) in
            if error != nil {
                return
            }
            
            self.searhNewsArray = dic!
            
            dispatch_async(dispatch_get_main_queue()) {
                self.tableView.reloadSections(NSIndexSet(index: 0), withRowAnimation: .Fade)
                if self.addedRefresh {
                    self.refreshControl.endRefreshing()
                } else {
                    self.tableView.addSubview(self.refreshControl)
                    self.addedRefresh = true
                }
            }
        })
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "getDetail" {
            let detailViewController = segue.destinationViewController as! NewsDetailViewController
            let index = self.tableView.indexPathForSelectedRow!
            let row = index.row
            let title = self.searhNewsArray[row]["title"]!
            let url = self.searhNewsArray[row]["url"]!
            
            if title != nil {
                detailViewController.stringTitle = title!
            } else if title == nil {
                detailViewController.stringTitle = "No title"
            }
            
            if url != nil {
                detailViewController.urlString = url!
            } else if url == nil {
                return
            }
        }
    }
}
