//
//  StudentConstants.swift
//  On the map
//
//  Created by Sai Leung on 5/19/18.
//  Copyright © 2018 Sai Leung. All rights reserved.
//

import Foundation
import MapKit
import NVActivityIndicatorView

extension Student {
    struct Constants {
        // MARK: URL
        static let ApiScheme = "https"
        static let ApiHost = "udacity.com"
        static let ApiPath = "/api"
    }
    
    struct Constant {
        
        static func mapPin(mapView: MKMapView?) {
            
            // MARK: Activity Indicator
            NVActivityIndicatorView.DEFAULT_BLOCKER_SIZE = CGSize(width: 80, height: 80)
            NVActivityIndicatorView.DEFAULT_TYPE = .orbit
            NVActivityIndicatorPresenter.sharedInstance.startAnimating(MapViewController.activityData)
            
            var request = URLRequest(url: URL(string: "https://parse.udacity.com/parse/classes/StudentLocation?limit=100&&order=-updatedAt")!)
            request.addValue("QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr", forHTTPHeaderField: "X-Parse-Application-Id")
            request.addValue("QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY", forHTTPHeaderField: "X-Parse-REST-API-Key")
            let session = URLSession.shared
            let task = session.dataTask(with: request) { data, response, error in
                // Handle error...
    //            NVActivityIndicatorPresenter.sharedInstance.stopAnimating()

                if error != nil {
                    return
                }
                DispatchQueue.main.async {
                    print(String(data: data!, encoding: .utf8)!)


                    let parseResult = try? JSONSerialization.jsonObject(with: data!, options: .allowFragments) as AnyObject


                    print(parseResult)
                    
                    guard let result = parseResult!["results"] as? [[String:AnyObject]] else {
                        return
                    }
            
                    
                    var num = 0
                    for student in result {
                        
                        let studentLocation = StudentLocation()
                        var first = ""
                        var last = ""
                        var lat = 0.0
                        var long = 0.0
                        var medURL = ""
                        
                        num += 1

                        print(num)
                        
                        if let firstName = student["firstName"] as? String {
                            
                            print("Saved successfully")
                            studentLocation.firstName = firstName
                            print(firstName)
                            first = firstName
                        }
                        
                        if let lastName = student["lastName"] as? String {
                            studentLocation.lastName = lastName
                            print(lastName)
                            last = lastName
                        }
                        
                        if let latitude = student["latitude"] as? Double {
                            studentLocation.latitude = latitude
                            print(latitude)
                            lat = latitude
                        }
                        
                        if let longitude = student["longitude"] as? Double {
                            studentLocation.longitude = longitude
                            print(longitude)
                            long = longitude
                        }
                        
                        if let mapString = student["mapString"] as? String {
                            studentLocation.mapString = mapString
                            print(mapString)
                        }
                        
                        if let mediaURL = student["mediaURL"] as? String {
                            studentLocation.mediaURL = mediaURL
                            print(mediaURL)
                            medURL = mediaURL
                        }
                        
                        if let objectId = student["objectId"] as? String {
                            studentLocation.objectId = objectId
                            print(objectId)
                        }
                        
                        if let uniqueKey = student["uniqueKey"] as? String {
                            studentLocation.uniqueKey = uniqueKey
                            print(uniqueKey)
                        }
                        
                        if let createdAt = student["createdAt"] as? String {
                            studentLocation.createdAt = createdAt
                            print(createdAt)
                        }
                        
                        if let updatedAt = student["updatedAt"] as? String {
                            studentLocation.updatedAt = updatedAt
                            print(updatedAt)
                        }
                        
                        StudentLocation.studentLocations.append(studentLocation)
                        
                        print("student location saved successfully")
                        let latt = CLLocationDegrees(lat)
                        let longg = CLLocationDegrees(long)
                        let coordinate = CLLocationCoordinate2D(latitude: latt, longitude: longg)
                        
                        let annotation = MKPointAnnotation()
                        annotation.coordinate = coordinate
                        annotation.title = "\(first) \(last)"
                        
                        annotation.subtitle = medURL
                        
                        mapView?.addAnnotation(annotation)
                    }
                    NVActivityIndicatorPresenter.sharedInstance.stopAnimating()
                }
            }
            task.resume()
        }
        
        static func checkIfUserAlreadyExist() {
            var exist: Bool = false
            var firstName = ""
            var lastName = ""
            
            // REQUEST
            var request = URLRequest(url: URL(string: "https://parse.udacity.com/parse/classes/StudentLocation?limit=500&&order=-updatedAt")!)
            request.addValue("QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr", forHTTPHeaderField: "X-Parse-Application-Id")
            request.addValue("QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY", forHTTPHeaderField: "X-Parse-REST-API-Key")
            let session = URLSession.shared
            let task = session.dataTask(with: request) { data, response, error in
                // Handle error...
                if error != nil {
                    return
                }
                
                NVActivityIndicatorPresenter.sharedInstance.startAnimating(MapViewController.activityData)
                DispatchQueue.main.async {
                    print(String(data: data!, encoding: .utf8)!)
                    
                    
                    let parseResult = try? JSONSerialization.jsonObject(with: data!, options: .allowFragments) as AnyObject
                    
                    
                    print(parseResult)
                    
                    guard let result = parseResult!["results"] as? [[String:AnyObject]] else {
                        return
                    }
                    var num = 0
                    for student in result {
                        num += 1
                        print(num)
                        if student["uniqueKey"] as? String == Student.uniqueKey {

                            print(student["uniqueKey"] as? String)
                            print("I got it")
                            guard let studentFirstName = student["firstName"] as? String else {
                                return
                            }
                            guard let studentLastName = student["lastName"] as? String else {
                                return
                            }
                            
                            Student.firstName = studentFirstName
                            Student.lastName = studentLastName
                        }
                    }
                    
                    NVActivityIndicatorPresenter.sharedInstance.stopAnimating()

                    
                }
            }
            
            task.resume()
        }
        
        // MARK: Delete Session ID
        static func deleteSession() {
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
            let task = session.dataTask(with: request) { data, response, error in
                if error != nil { // Handle error…
                    return
                }
                let range = Range(5..<data!.count)
                let newData = data?.subdata(in: range) /* subset response data! */
                print(String(data: newData!, encoding: .utf8)!)
            }
            task.resume()
        }
        
        // MARK: Open Safari with given url
        static func openSafari(url: URL) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
        
        // MARK: Activity Loading Indicator
        
        static func activityIndicator(loading: Bool) {
            NVActivityIndicatorView.DEFAULT_BLOCKER_SIZE = CGSize(width: 80, height: 80)
            NVActivityIndicatorView.DEFAULT_TYPE = .orbit
            
            if loading {
                NVActivityIndicatorPresenter.sharedInstance.startAnimating(MapViewController.activityData)
            } else {
                NVActivityIndicatorPresenter.sharedInstance.stopAnimating()
            }
        }
        
        // MARK: Authenticate user before allowing to use the app
        static func authenticateStudent(username: String, password: String, viewController: UIViewController) {
            var request = URLRequest(url: URL(string: "https://www.udacity.com/api/session")!)
            request.httpMethod = "POST"
            request.addValue("application/json", forHTTPHeaderField: "Accept")
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.httpBody = "{\"udacity\": {\"username\": \"\(username)\", \"password\": \"\(password)\"}}".data(using: .utf8)
            let session = URLSession.shared
            let task = session.dataTask(with: request) { data, response, error in
                if error != nil { // Handle error…
                    return
                }
                
                DispatchQueue.main.async {
                    let range = Range(5..<data!.count)
                    let newData = data?.subdata(in: range) /* subset response data! */
                    print(String(data: newData!, encoding: .utf8)!)
                    var parseResult: AnyObject! = nil
                    
                    do {
                        parseResult = try JSONSerialization.jsonObject(with: newData!, options: .allowFragments) as AnyObject
                    } catch {
                        print("Error: \(error)")
                    }
                    guard let sessionID = parseResult?["session"] as? [String: String] else {
                        let alert = UIAlertController(title: "Invalid Email or Password", message: nil, preferredStyle: .alert)
                        let alertAction = UIAlertAction(title: "Dismiss", style: .default, handler: nil)
                        alert.addAction(alertAction)
                        viewController.present(alert, animated: true, completion: nil)
                        return
                    }
                    guard let session = sessionID["id"] else {
                        return
                    }
                    guard let account = parseResult?["account"] as? [String: AnyObject], let registered = account["registered"] as? Bool, let uniqueKey = account["key"] as? String else {
                        return
                    }
                    Student.uniqueKey = uniqueKey
                    
                    if registered {
                        viewController.performSegue(withIdentifier: "ToTabView", sender: nil)
                    }
                }
            }
            task.resume()
        }
        
        // MARK: Get student locations function
        static func getStudentLocations(mapView: MKMapView?) {
            Student.Constant.activityIndicator(loading: true)
            
            var request = URLRequest(url: URL(string: "https://parse.udacity.com/parse/classes/StudentLocation?limit=100&&order=-updatedAt")!)
            request.addValue("QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr", forHTTPHeaderField: "X-Parse-Application-Id")
            request.addValue("QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY", forHTTPHeaderField: "X-Parse-REST-API-Key")
            let session = URLSession.shared
            let task = session.dataTask(with: request) { data, response, error in
                // Handle error...
                
                if error != nil {
                    return
                }
                DispatchQueue.main.async {
                    print(String(data: data!, encoding: .utf8)!)
                    
                    
                    let parseResult = try? JSONSerialization.jsonObject(with: data!, options: .allowFragments) as AnyObject
                    
                    
                    print(parseResult)
                    
                    guard let result = parseResult!["results"] as? [[String:AnyObject]] else {
                        return
                    }
                    
                    StudentLocation.studentLocations.removeAll()
                    var num = 0
                    for student in result {
                        
                        let studentLocation = StudentLocation()
                        var first = ""
                        var last = ""
                        var lat = 0.0
                        var long = 0.0
                        var medURL = ""
                        
                        num += 1
                        
                        print(num)
                        
                        if let firstName = student["firstName"] as? String {
                            
                            print("Saved successfully")
                            studentLocation.firstName = firstName
                            print(firstName)
                            first = firstName
                        }
                        
                        if let lastName = student["lastName"] as? String {
                            studentLocation.lastName = lastName
                            print(lastName)
                            last = lastName
                        }
                        
                        if let latitude = student["latitude"] as? Double {
                            studentLocation.latitude = latitude
                            print(latitude)
                            lat = latitude
                        }
                        
                        if let longitude = student["longitude"] as? Double {
                            studentLocation.longitude = longitude
                            print(longitude)
                            long = longitude
                        }
                        
                        if let mapString = student["mapString"] as? String {
                            studentLocation.mapString = mapString
                            print(mapString)
                        }
                        
                        if let mediaURL = student["mediaURL"] as? String {
                            studentLocation.mediaURL = mediaURL
                            print(mediaURL)
                            medURL = mediaURL
                        }
                        
                        if let objectId = student["objectId"] as? String {
                            studentLocation.objectId = objectId
                            print(objectId)
                        }
                        
                        if let uniqueKey = student["uniqueKey"] as? String {
                            studentLocation.uniqueKey = uniqueKey
                            print(uniqueKey)
                        }
                        
                        if let createdAt = student["createdAt"] as? String {
                            studentLocation.createdAt = createdAt
                            print(createdAt)
                        }
                        
                        if let updatedAt = student["updatedAt"] as? String {
                            studentLocation.updatedAt = updatedAt
                            print(updatedAt)
                        }
                        
                        StudentLocation.studentLocations.append(studentLocation)
                        
                        print("student location saved successfully")
                        if mapView != nil {
                            let latt = CLLocationDegrees(lat)
                            let longg = CLLocationDegrees(long)
                            let coordinate = CLLocationCoordinate2D(latitude: latt, longitude: longg)
                            
                            let annotation = MKPointAnnotation()
                            annotation.coordinate = coordinate
                            annotation.title = "\(first) \(last)"
                            
                            annotation.subtitle = medURL
                            
                            mapView?.addAnnotation(annotation)
                        }
                    }
                    
                    Student.Constant.activityIndicator(loading: false)
                    if mapView != nil {
                        mapView?.reloadInputViews()
                    }
                }
            }
            task.resume()
            print("Refresh successfully")
        }
        
        // MARK: Verify if student has previously posted location
        static func verifyUserLocationAlreadyExist(viewController: UIViewController, segueIdentifier: String) {
            // REQUEST
            var request = URLRequest(url: URL(string: "https://parse.udacity.com/parse/classes/StudentLocation?limit=500&&order=-updatedAt")!)
            request.addValue("QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr", forHTTPHeaderField: "X-Parse-Application-Id")
            request.addValue("QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY", forHTTPHeaderField: "X-Parse-REST-API-Key")
            let session = URLSession.shared
            let task = session.dataTask(with: request) { data, response, error in
                // Handle error...
                if error != nil {
                    return
                }
                
                NVActivityIndicatorPresenter.sharedInstance.startAnimating(MapViewController.activityData)
                DispatchQueue.main.async {
                    print(String(data: data!, encoding: .utf8)!)
                    
                    
                    let parseResult = try? JSONSerialization.jsonObject(with: data!, options: .allowFragments) as AnyObject
                    
                    
                    print(parseResult)
                    
                    guard let result = parseResult!["results"] as? [[String:AnyObject]] else {
                        return
                    }
                    var num = 0
                    for student in result {
                        num += 1
                        print(num)
                        if student["uniqueKey"] as? String == Student.uniqueKey {
                            Student.exist = true
                            print(student["uniqueKey"] as? String)
                            print("I got it")
                            guard let studentFirstName = student["firstName"] as? String else {
                                return
                            }
                            guard let studentLastName = student["lastName"] as? String else {
                                return
                            }
                            guard let objectId = student["objectId"] as? String else {
                                return
                            }
                            Student.firstName = studentFirstName
                            Student.lastName = studentLastName
                            Student.objectId = objectId
                            print(studentFirstName)
                            print(studentLastName)
                            print(objectId)
                        }
                    }
                    
                    NVActivityIndicatorPresenter.sharedInstance.stopAnimating()
                    if Student.exist {
                        let alert = UIAlertController(title: nil, message: "User \"\(Student.firstName) \(Student.lastName)\" Has Already Posted a Student Location. Would you like to Overwrite Their Location?", preferredStyle: .alert)
                        let overwriteAlertAction = UIAlertAction(title: "Overwrite", style: .default, handler: { (action) in
                            viewController.performSegue(withIdentifier: segueIdentifier, sender: nil)
                        })
                        let cancelAlertAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
                        alert.addAction(overwriteAlertAction)
                        alert.addAction(cancelAlertAction)
                        viewController.present(alert, animated: true, completion: nil)
                    }
                }
            }
            task.resume()
        }
        
         // MARK: Get Student basic information
        static func getStudentBasicInformation() {
            let request = URLRequest(url: URL(string: "https://www.udacity.com/api/users/\(Student.uniqueKey)")!)
            let session = URLSession.shared
            let task = session.dataTask(with: request) { data, response, error in
                if error != nil { // Handle error...
                    return
                }
                
                DispatchQueue.main.async {
                    let range = Range(5..<data!.count)
                    let newData = data?.subdata(in: range) /* subset response data! */
                    let parseResult = try? JSONSerialization.jsonObject(with: newData!, options: .allowFragments) as AnyObject
                    guard let user = parseResult!["user"] as? [String:AnyObject], let lastName = user["last_name"] as? String, let firstName = user["first_name"] as? String else {
                        return
                    }
                    print("\(firstName) \(lastName)" )
                }
                
            }
            task.resume()
        }
        
    }
}
