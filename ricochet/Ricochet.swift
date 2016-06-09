//
//  Ricochet.swift
//  thinkmoist
//
//  Created by Lloyd Rochester on 6/6/16.
//  Copyright © 2016 CloseOut LLC. All rights reserved.
//

import SwiftyJSON

enum HttpMethods: String {
    case GET, POST, DELETE
}

class Ricochet {
    func post(url: String, json: JSON?) -> RicochetRequest {
        return httpRequest(.POST, url: url, json: json)
    }
    
    
    func get(url: String) -> RicochetRequest {
        return httpRequest(.GET, url: url, json: nil)
    }
    
    func get(url: String, queryParms: [String:String]) -> RicochetRequest {
        let query = "?"+self.getQueryString(queryParms)
        return httpRequest(.GET, url: url+query, json: nil)
    }
    
    func delete(url: String) -> RicochetRequest {
        return httpRequest(.DELETE, url: url, json: nil)
    }
    
    func delete(url: String, queryParms: [String:String]) -> RicochetRequest {
        let query = "?"+self.getQueryString(queryParms)
        return httpRequest(.DELETE, url: url+query, json: nil)
    }
    
    private func httpRequest(method: HttpMethods, url: String, json: JSON?) -> RicochetRequest {
        let nsUrl = NSURL(string: url)
        let req = NSMutableURLRequest(URL: nsUrl!)
        
        req.addValue("application/json", forHTTPHeaderField: "Content-Type")
        req.HTTPMethod = method.rawValue
        
        do {
            if let obj = json?.object {
                let data = try NSJSONSerialization.dataWithJSONObject(obj, options: .PrettyPrinted)
                req.HTTPBody = data
            }
        } catch _ {
            print("Error converting JSON to String for Request Body")
        }
        
        let ricoRequest = RicochetRequest(request: req)
        return ricoRequest
    }
    
    private func getQueryString(parms: [String:String]) -> String {
        var str = "" as String
        var app = "" as String
        var count = 0
        for (key,value) in parms {
            if(count != 0 && count != parms.count) {
                app = "&"
            }
            str += app+key+"="+value
            count += 1
        }
        return str
    }
}

class RicochetRequest {
    let session: NSURLSession;
    let request: NSMutableURLRequest
    var response: NSURLResponse?
    var error: NSError?
    
    init(request: NSMutableURLRequest) {
        self.request = request
        self.session = NSURLSession.sharedSession()
        self.response = nil
        self.error = nil
    }
    
    func setHeader(value: String, httpField: String) -> RicochetRequest {
        self.request.addValue(value, forHTTPHeaderField: httpField)
        return self;
    }
    
    func request(callback: (JSON?,NSData?,NSHTTPURLResponse?,NSError?) -> ()) {
        let task = session.dataTaskWithRequest(self.request, completionHandler: {data, response, error -> Void in
            dispatch_async(dispatch_get_main_queue(), {
                self.requestCatcher(data,response: response,error: error,callback: callback)
            })
        })
        task.resume()
    }
    
    func requestLowPriority(callback: (JSON?,NSData?,NSHTTPURLResponse?,NSError?) -> ()) {
        let task = session.dataTaskWithRequest(self.request, completionHandler: {data, response, error -> Void in
            self.requestCatcher(data,response: response,error: error,callback: callback)
        })
        task.resume()
    }
    
    func requestCatcher(data: NSData?, response: NSURLResponse?, error: NSError?, callback: (JSON?,NSData?,NSHTTPURLResponse?,NSError?) -> ()) {
        self.response = response
        self.error = error
        do {
            
            let httpResp = response as? NSHTTPURLResponse
            
            if data != nil {
                let jsonData = try NSJSONSerialization.JSONObjectWithData(data!, options: .MutableLeaves) as? NSDictionary
                let json = JSON(jsonData!)
                callback(json,data,httpResp,error)
            } else {
                callback(nil,data,httpResp,error)
                return
            }
        } catch _ {
            let jsonStr = NSString(data: data!, encoding: NSUTF8StringEncoding)
            print("Error could not parse JSON from response: '\(jsonStr)'")
        }
    }
}
