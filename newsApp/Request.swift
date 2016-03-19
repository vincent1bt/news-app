//
//  Data.swift
//  newsApp
//
//  Created by vicente rodriguez on 2/24/16.
//  Copyright © 2016 vicente rodriguez. All rights reserved.
//

import Foundation
import UIKit
import TwitterKit
//se crea un alias, este devuelve un json o un posible error
typealias ResponseWithJSON = (JSON, NSError?) -> Void

struct Request {
    static let sharedInstance = Request()
    
    private let keyMostView = "df44537e748f15225473138a13a01619:14:74524472"
    private let searchKey = "8515ec3897b3a7a4716b8f166db7635a:9:74524472"
    
    func getMostView(onCompletion: ResponseWithJSON) {
        let urlString = "mostpopular/v2/mostviewed/all-sections/1?api-key=\(keyMostView)"
        
        makeHTTPRequest(urlString, onCompletion: { json, error in
            onCompletion(json, error)
        })
    }
    
    func search(q: String, onCompletion: ResponseWithJSON) {
        let urlString = "search/v2/articlesearch.json?q=\(q)&sort=newest&api-key=\(searchKey)"
        makeHTTPRequest(urlString, onCompletion: {
            json, error in
            onCompletion(json, error)
        })
    }
    
    func getTweets(query q: String, onCompletion: ResponseWithJSON) {
        makeTwitterRequest(query: q, onCompletion: {
            json, error in
            onCompletion(json, error)
        })
    }
}

//esta funcion usa el alias Response para devolver el objeto json o el error
func makeHTTPRequest(url: String, onCompletion: ResponseWithJSON) {
    let endPoint = "http://api.nytimes.com/svc/\(url)"
    let request = NSMutableURLRequest(URL: NSURL(string: endPoint)!)
    let session = NSURLSession.sharedSession()
    
    //se crea una tarea que pide los datos del request que se le pase
    //este responde con los datos la peticion o un error
    let task = session.dataTaskWithRequest(request, completionHandler: { data, response, error -> Void in
        //si hay datos, se crea un objeto de tipo json
        let json: JSON = JSON(data: data!)
        //se regresa el objeto json y el posible error
        onCompletion(json, error)
    })
    
    task.resume()
}


func makeTwitterRequest(query q: String, onCompletion: ResponseWithJSON) {
    let userID = Twitter.sharedInstance().sessionStore.session()?.userID
    let client = TWTRAPIClient(userID: userID)
    let endPoint = "https://api.twitter.com/1.1/search/tweets.json"
    let params = ["q": q, "count": "10", "result_type": "mixed"]
    var clientError: NSError?
    
    let request = Twitter.sharedInstance().APIClient.URLRequestWithMethod("GET", URL: endPoint, parameters: params, error: &clientError)
    
    guard clientError == nil else {
        onCompletion(nil, clientError)
        return
    }
    
    client.sendTwitterRequest(request) {
        response, data, connectionError -> Void in
        
        if connectionError == nil {
            let json: JSON = JSON(data: data!)
            onCompletion(json, nil)
        } else {
            onCompletion(nil, connectionError)
        }
    }

    
}
