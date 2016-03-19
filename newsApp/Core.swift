//
//  core.swift
//  newsApp
//
//  Created by vicente rodriguez on 3/9/16.
//  Copyright © 2016 vicente rodriguez. All rights reserved.
//

import Foundation

typealias Response = ([Dictionary<String, String?>]?, NSError?) -> Void
typealias ResponseWithJson = (JSON?, NSError?) -> Void

struct Data {
    static let sharedInstance = Data()
    
    func getDataFromNews(query q: String, onCompletion: Response) {
        Request.sharedInstance.search(q, onCompletion: {
            (json, error) in
            if error != nil {
                onCompletion(nil, error)
                return
            }
            
            let results = json["response"]
            let docs = results["docs"]
            var dic = [[String: String?]]()
            
            for key in docs {
                let title = key.1["snippet"].object as? String
                let date = (key.1["pub_date"].object as? String)?.componentsSeparatedByString("T")[0]
                let url = key.1["web_url"].object as? String
                let newsDic = ["title": title, "date": date, "url": url]
                dic.append(newsDic)
            }
            onCompletion(dic, nil)
        })
    }
    
    func getDataFromMostViews(onCompletion: Response) {
        Request.sharedInstance.getMostView() { json, error in
            if error != nil {
                onCompletion(nil, error)
                return
            }
            let results = json["results"]
            var dic = [[String: String?]]()
            for key in results {
                let title = key.1["title"].object as? String
                let url = key.1["url"].object as? String
                let date = key.1["published_date"].object as? String
                let newsDic = ["title": title, "url": url, "date": date]
                dic.append(newsDic)
            }
            onCompletion(dic, nil)
        }
    }
    
    func getDataFromTweets(query q: String, onCompletion: ResponseWithJson) {
        Request.sharedInstance.getTweets(query: q) {
            json, error in
            onCompletion(json, error)
        }
    }
}