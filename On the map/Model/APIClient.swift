//
//  APIClient.swift
//  On the map
//
//  Created by Sai Leung on 6/5/18.
//  Copyright © 2018 Sai Leung. All rights reserved.
//

import Foundation

class APIClient{
    
//    var session = URLSession.shared
    
    // MARK: Authenticate user before allowing to use the app
    func authenticateStudent(username: String, password: String, completion: @escaping (_ success: Bool, _ uniqueKey: String?, _ errorString: String?) -> Void) {
        var request = URLRequest(url: URL(string: "https://www.udacity.com/api/session")!)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = "{\"udacity\": {\"username\": \"\(username)\", \"password\": \"\(password)\"}}".data(using: .utf8)
        let session = URLSession.shared
        let task = session.dataTask(with: request) { (data, response, error) in
            if error != nil {
                completion(false, nil, "Error")
                return
            }
            DispatchQueue.main.async {
                let range = Range(5..<data!.count)
                let newData = data?.subdata(in: range) /* subset response data! */
                var parseResult: AnyObject! = nil
                do {
                    parseResult = try JSONSerialization.jsonObject(with: newData!, options: .allowFragments) as AnyObject
                } catch {
                    print("Error: \(error)")
                }
                guard let account = parseResult?["account"] as? [String: AnyObject], let uniqueKey = account["key"] as? String else {
                    completion(false, nil, "Error")
                    return
                }
                completion(true, uniqueKey, nil)
            }
        }
        task.resume()
    }
    
//    func authenticateStudent(username: String, password: String, viewController: UIViewController) {
//        var request = URLRequest(url: URL(string: "https://www.udacity.com/api/session")!)
//        request.httpMethod = "POST"
//        request.addValue("application/json", forHTTPHeaderField: "Accept")
//        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
//        request.httpBody = "{\"udacity\": {\"username\": \"\(username)\", \"password\": \"\(password)\"}}".data(using: .utf8)
//        let session = URLSession.shared
//        let task = session.dataTask(with: request) { data, response, error in
//            if error != nil { // Handle error…
//                return
//            }
//
//
//            DispatchQueue.main.async {
//                let range = Range(5..<data!.count)
//                let newData = data?.subdata(in: range) /* subset response data! */
//                var parseResult: AnyObject! = nil
//                do {
//                    parseResult = try JSONSerialization.jsonObject(with: newData!, options: .allowFragments) as AnyObject
//                } catch {
//                    print("Error: \(error)")
//                }
//                guard let sessionID = parseResult?["session"] as? [String: String] else {
//                    let alert = UIAlertController(title: "Invalid Email or Password", message: nil, preferredStyle: .alert)
//                    let alertAction = UIAlertAction(title: "Dismiss", style: .default, handler: nil)
//                    alert.addAction(alertAction)
//                    viewController.present(alert, animated: true, completion: nil)
//                    return
//                }
//                guard let session = sessionID["id"] else {
//                    return
//                }
//                guard let account = parseResult?["account"] as? [String: AnyObject], let registered = account["registered"] as? Bool, let uniqueKey = account["key"] as? String else {
//                    return
//                }
//                Student.uniqueKey = uniqueKey
//                if registered {
//                    viewController.performSegue(withIdentifier: "ToTabView", sender: nil)
//                }
//            }
////        }
////        task.resume()
//    }
    
    
    // given raw JSON, return a usable Foundation object
    private func convertDataWithCompletionHandler(_ data: Data, completionHandlerForConvertData: (_ result: AnyObject?, _ error: NSError?) -> Void) {
        let range = Range(5 ..< data.count)
        
        let newData = data.subdata(in: range) /* subset response data! */
        var parsedResult: AnyObject! = nil
        do {
            parsedResult = try JSONSerialization.jsonObject(with: newData, options: .allowFragments) as AnyObject
        } catch {
            let userInfo = [NSLocalizedDescriptionKey : "Could not parse the data as JSON: '\(data)'"]
            completionHandlerForConvertData(nil, NSError(domain: "convertDataWithCompletionHandler", code: 1, userInfo: userInfo))
        }
        
        completionHandlerForConvertData(parsedResult, nil)
    }
    
    // MARK: Shared Instance
    static let sharedInstance = APIClient()
}
