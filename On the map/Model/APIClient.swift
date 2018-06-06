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
    func getStudentLocations(completion: @escaping (_ success: Bool, _ results: [[String:AnyObject]]?, _ error: Error?) -> Void) {
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
            }
        }
        task.resume()
    }
    
    // MARK: Get Student basic information
    func getStudentBasicInformation(completion: @escaping (_ success: Bool, _ results: AnyObject?, _ error: Error?) -> Void){
        let request = URLRequest(url: URL(string: "https://www.udacity.com/api/users/\(Student.uniqueKey)")!)
        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in
            if error != nil { // Handle error...
                completion(false, nil, error)
                return
            }
            
            DispatchQueue.main.async {
                let range = Range(5..<data!.count)
                let newData = data?.subdata(in: range) /* subset response data! */
                let parseResult = try? JSONSerialization.jsonObject(with: newData!, options: .allowFragments) as AnyObject
                completion(true, parseResult, nil)
                    return
                }
            }
        task.resume()
    }
    
    // MARK: Update Student existing location
    func updateExistingLocation(completion: @escaping(_ success: Bool, _ error: Error?) -> Void){
        guard let latitude = Student.newLocation?.latitude, let longitude = Student.newLocation?.longitude else {
            return
        }
        let urlString = "https://parse.udacity.com/parse/classes/StudentLocation/\(Student.objectId)"
        let url = URL(string: urlString)
        var request = URLRequest(url: url!)
        request.httpMethod = "PUT"
        request.addValue("QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr", forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue("QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY", forHTTPHeaderField: "X-Parse-REST-API-Key")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = "{\"uniqueKey\": \"\(Student.uniqueKey)\", \"firstName\": \"\(Student.firstName)\", \"lastName\": \"\(Student.lastName)\",\"mapString\": \"\(Student.studentCity), \(Student.studentState)\", \"mediaURL\": \"\(Student.mediaURL)\",\"latitude\": \(latitude), \"longitude\": \(longitude)}".data(using: .utf8)
        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in
            if error != nil { // Handle error…
                completion(false, error)
                return
            }
            completion(true, nil)
        }
        task.resume()
    }
    
    // MARK: Add brand new location
    func addNewLocation(completion: @escaping(_ success: Bool, _ error: Error?) -> Void){
        guard let latitude = Student.newLocation?.latitude, let longitude = Student.newLocation?.longitude else {
            return
        }
        var request = URLRequest(url: URL(string: "https://parse.udacity.com/parse/classes/StudentLocation")!)
        request.httpMethod = "POST"
        request.addValue("QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr", forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue("QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY", forHTTPHeaderField: "X-Parse-REST-API-Key")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = "{\"uniqueKey\": \"\(Student.uniqueKey)\", \"firstName\": \"\(Student.firstName)\", \"lastName\": \"\(Student.lastName)\",\"mapString\": \"\(Student.studentCity), \(Student.studentState)\", \"mediaURL\": \"\(Student.mediaURL)\",\"latitude\": \(latitude), \"longitude\": \(longitude)}".data(using: .utf8)
        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in
            if error != nil { // Handle error…
                completion(false, error)
                return
            }
            completion(true, nil)
//            DispatchQueue.main.async {
//                guard let tabViewController = viewController.storyboard?.instantiateViewController(withIdentifier: "TabViewController") else {
//                    return
//                }
//                Student.Constant.activityIndicator(loading: false)
//                viewController.present(tabViewController, animated: true, completion: nil)
//            }
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
