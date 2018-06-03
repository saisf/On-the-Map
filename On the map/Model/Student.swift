//
//  Student.swift
//  On the map
//
//  Created by Sai Leung on 5/19/18.
//  Copyright © 2018 Sai Leung. All rights reserved.
//

import Foundation
import CoreLocation

class Student: NSObject {
    
    // shared session
    var session = URLSession.shared
    
    var sessionID: String? = nil
    
    static var uniqueKey = ""
    static var firstName = ""
    static var lastName = ""
    static var newLocation: CLLocationCoordinate2D?
    static var mediaURL = ""
    static var exist = false
    static var studentCity = ""
    static var studentState = ""
    
    override init() {
        super.init()
    }
    
    //tmdURLFromParameters (path extension)
    
    //convertDataWithCompletionHandler (parse the data and use the data)
    
    // given raw JSON, return a usable Foundation object
//    func taskForPOSTMethod(user: String, password: String, parameters: [String:AnyObject], jsonBody: String, completionHandlerForPOST: @escaping (_ result: AnyObject?, _ error: NSError?) -> Void) -> URLSessionTask
    func taskForPOSTMethod(user: String, password: String, completionHandlerForPOST: @escaping (_ result: AnyObject?, _ error: NSError?) -> Void) -> URLSessionTask {
        
        // 1. Set the parameter
        let sessionString = "https://www.udacity.com/api/session"
        
        // 2/3. Build the URL, Configure the request
        let url = URL(string: sessionString)!
        let request = NSMutableURLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = "{\"udacity\": {\"username\": \"\(user)\", \"password\": \"\(password)\"}}".data(using: .utf8)
        
        // 4. Make the request
        let task = session.dataTask(with: url) { (data, response, error) in
            
            func sendError(_ error: String) {
                print(error)
                let userInfo = [NSLocalizedDescriptionKey : error]
                completionHandlerForPOST(nil, NSError(domain: "taskForGETMethod", code: 1, userInfo: userInfo))
            }
            
            // GUARD: Was there an error?
            guard (error == nil) else {
                sendError("There was an error with your request: \(error!)")
                return
            }
            
            // GUARD: Did we get a successful 2XX response?
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else {
                sendError("Your request returned a status code other than 2xx!")
                return
            }
            
            // GUARD: Was there any data returned?
            guard let data = data else {
                sendError("No data was returned by the request!")
                return
            }
            
            let range = Range(5..<data.count)
            let newData = data.subdata(in: range)
            
            // 5.6. Parse the data and use the data (happens in completion handler)
//            self.convertDataWithCompletionHandler(data, completionHandlerForConvertData: completionHandlerForPOST)
            self.convertDataWithCompletionHandler(newData, completionHandlerForConvertData: completionHandlerForPOST)
        }
        
        task.resume()
        
        return task
    }
    
    // create a URL from parameters
    private func urlFromParameters(_ parameters: [String:AnyObject], withPathExtension: String? = nil) -> URL {
        var components = URLComponents()
        components.scheme = Student.Constants.ApiScheme
        components.host = Student.Constants.ApiHost
        components.path = Student.Constants.ApiPath + (withPathExtension ?? "")
        components.queryItems = [URLQueryItem]()
        
        for (key, value) in parameters {
            let queryItem = URLQueryItem(name: key, value: "\(value)")
            components.queryItems?.append(queryItem)
        }
        
        return components.url!
    }
    
    // given raw JSON, return a usable Foundation object
    private func convertDataWithCompletionHandler(_ data: Data, completionHandlerForConvertData: (_ result: AnyObject?, _ error: NSError?) -> Void) {
        
        var parseResult: AnyObject! = nil
        do {
            parseResult = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as AnyObject
        } catch {
            let userInfo = [NSLocalizedDescriptionKey: "Could not parse the data as JSON: '\(data)'"]
            completionHandlerForConvertData(nil, NSError(domain: "convertDataWithCompletionHandler", code: 1, userInfo: userInfo))
        }
        completionHandlerForConvertData(parseResult, nil)
    }
    
    // MARK: Shared Instance
    
    class func sharedInstance() -> Student {
        struct Singleton {
            static var sharedInstance = Student()
        }
        return Singleton.sharedInstance
    }
}
