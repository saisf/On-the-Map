//
//  APIClient.swift
//  On the map
//
//  Created by Sai Leung on 6/5/18.
//  Copyright © 2018 Sai Leung. All rights reserved.
//

import Foundation
import MapKit

class APIClient: NSObject{
    
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
    
    // MARK: Get Student Location
    func getStudentLocations(mapView: MKMapView, completion: @escaping (_ success: Bool, _ results: [[String:AnyObject]]?, _ error: Error?) -> Void) {
        var request = URLRequest(url: URL(string: "https://parse.udacity.com/parse/classes/StudentLocation?limit=100&&order=-updatedAt")!)
        request.addValue("QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr", forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue("QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY", forHTTPHeaderField: "X-Parse-REST-API-Key")
        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in
            // Handle error...
            if error != nil {
                completion(false, nil, error)
                return
            }
            DispatchQueue.main.async {
                let parseResult = try? JSONSerialization.jsonObject(with: data!, options: .allowFragments) as AnyObject
                guard let result = parseResult!["results"] as? [[String:AnyObject]] else {
                    return
                }
                completion(true, result, nil)
            }
        }
        task.resume()
    }
    
    // MARK: Verify if student has previously posted location
    func verifyUserLocationAlreadyExist(completion: @escaping (_ results: [[String:AnyObject]]?, _ error: Error?) -> Void) {
        Student.Constant.activityIndicator(loading: true)
        var request = URLRequest(url: URL(string: "https://parse.udacity.com/parse/classes/StudentLocation?limit=500&&order=-updatedAt")!)
        request.addValue("QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr", forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue("QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY", forHTTPHeaderField: "X-Parse-REST-API-Key")
        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in
            // Handle error...
            if error != nil {
                completion(nil, error)
                return
            }
            
            DispatchQueue.main.async {
                let parseResult = try? JSONSerialization.jsonObject(with: data!, options: .allowFragments) as AnyObject
                guard let result = parseResult!["results"] as? [[String:AnyObject]] else {
                    return
                }
                completion(result, nil)
//                var num = 0
//                for student in result {
//                    
//                    num += 1
//                    if student["uniqueKey"] as? String == Student.uniqueKey {
//                        Student.exist = true
//                        print(student["uniqueKey"] as? String)
//                        print("I got it")
//                        guard let studentFirstName = student["firstName"] as? String else {
//                            return
//                        }
//                        guard let studentLastName = student["lastName"] as? String else {
//                            return
//                        }
//                        guard let objectId = student["objectId"] as? String else {
//                            return
//                        }
//                        Student.firstName = studentFirstName
//                        Student.lastName = studentLastName
//                        Student.objectId = objectId
//                    }
//                }
//                Student.Constant.activityIndicator(loading: false)
//                if Student.exist {
//                    let alert = UIAlertController(title: nil, message: "User \"\(Student.firstName) \(Student.lastName)\" Has Already Posted a Student Location. Would you like to Overwrite Their Location?", preferredStyle: .alert)
//                    let overwriteAlertAction = UIAlertAction(title: "Overwrite", style: .default, handler: { (action) in
//                        viewController.performSegue(withIdentifier: segueIdentifier, sender: nil)
//                    })
//                    let cancelAlertAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
//                    alert.addAction(overwriteAlertAction)
//                    alert.addAction(cancelAlertAction)
//                    viewController.present(alert, animated: true, completion: nil)
//                }
            }
        }
        task.resume()
    }
    
    // MARK: Delete Session ID
    func deleteSession() {
        var request = URLRequest(url: URL(string: "https://www.udacity.com/api/session")!)
        request.httpMethod = "DELETE"
        var xsrfCookie: HTTPCookie? = nil
        let sharedCookieStorage = HTTPCookieStorage.shared
        for cookie in sharedCookieStorage.cookies! {
            if cookie.name == "XSRF-TOKEN" { xsrfCookie = cookie }
        }
        if let xsrfCookie = xsrfCookie {
            request.setValue(xsrfCookie.value, forHTTPHeaderField: "X-XSRF-TOKEN")
        }
        let session = URLSession.shared
        let task = session.dataTask(with: request)
        task.resume()
    }
    
    // MARK: Shared Instance
    static let sharedInstance = APIClient()
}
