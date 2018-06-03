//
//  MapViewController.swift
//  On the map
//
//  Created by Sai Leung on 5/21/18.
//  Copyright © 2018 Sai Leung. All rights reserved.
//

import UIKit
import MapKit
import NVActivityIndicatorView

class MapViewController: UIViewController, MKMapViewDelegate{
    @IBOutlet weak var mapView: MKMapView!
    static let activityData = ActivityData()
    var exist: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
//        Student.Constant.mapPin(mapView: mapView)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
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
                    let latt = CLLocationDegrees(lat)
                    let longg = CLLocationDegrees(long)
                    let coordinate = CLLocationCoordinate2D(latitude: latt, longitude: longg)
                    
                    let annotation = MKPointAnnotation()
                    annotation.coordinate = coordinate
                    annotation.title = "\(first) \(last)"
                    
                    annotation.subtitle = medURL
                    
                    self.mapView?.addAnnotation(annotation)
                }
                
                NVActivityIndicatorPresenter.sharedInstance.stopAnimating()
                self.mapView.reloadInputViews()
            }
        }
        task.resume()
        print("Refresh successfully")
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let reuseId = "pin"

        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView

        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.canShowCallout = true
            pinView!.pinTintColor = .red
            pinView!.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)

        } else {
            pinView!.annotation = annotation
        }

        return pinView
    }

    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {

        guard let subtitle = view.annotation?.subtitle!, let url = URL(string: subtitle) else {
            return
        }

        if (UIApplication.shared.canOpenURL(url)) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        } else {
            let alert = UIAlertController(title: "Invalid Link", message: nil, preferredStyle: .alert)
            let alertAction = UIAlertAction(title: "Dismiss", style: .default, handler: nil)
            alert.addAction(alertAction)
            present(alert, animated: true, completion: nil)
        }

    }
    
    @IBAction func refreshButton(_ sender: UIBarButtonItem) {
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
                    let latt = CLLocationDegrees(lat)
                    let longg = CLLocationDegrees(long)
                    let coordinate = CLLocationCoordinate2D(latitude: latt, longitude: longg)

                    let annotation = MKPointAnnotation()
                    annotation.coordinate = coordinate
                    annotation.title = "\(first) \(last)"

                    annotation.subtitle = medURL

                    self.mapView?.addAnnotation(annotation)
                }
                
                NVActivityIndicatorPresenter.sharedInstance.stopAnimating()
                self.mapView.reloadInputViews()
            }
        }
        task.resume()
        print("Refresh successfully")
        
        
        
    }
    
    @IBAction func logoutButton(_ sender: UIBarButtonItem) {
        guard let loginViewController = self.storyboard?.instantiateViewController(withIdentifier: "LoginViewController") else {
            return
        }
        self.present(loginViewController, animated: true, completion: nil)
    }
    
    @IBAction func addLocationButton(_ sender: UIBarButtonItem) {
        
        

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
                                self.performSegue(withIdentifier: "addLocation", sender: nil)
                            })
                        let cancelAlertAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
                        alert.addAction(overwriteAlertAction)
                        alert.addAction(cancelAlertAction)
                        self.present(alert, animated: true, completion: nil)
                    }
            }
        }
        task.resume()
    }
    

    
    
//        func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
//
//            guard let subtitle = view.annotation?.subtitle! else {
//                return
//            }
//            let url = URL(string: subtitle)
//
//            if (UIApplication.shared.canOpenURL(URL(string: "")!)) {
//
//            } else {
//
//            }
//            UIApplication.shared.open(url!, options: [:], completionHandler: nil)
//    }

}
