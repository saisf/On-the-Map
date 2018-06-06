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
    }
    
    override func viewWillAppear(_ animated: Bool) {
        Convenience.sharedInstance.activityIndicator(loading: true)
        
        // MARK: Get student locations
        APIClient.sharedInstance.getStudentLocations(mapView: mapView) { (success, results, error) in
            if error != nil {
                return
            }
            guard let results = results else {
                return
            }
            if success {
                self.addAnnotation(results: results)
                Convenience.sharedInstance.activityIndicator(loading: false)
                self.mapView?.reloadInputViews()
            }
        }
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let reuseId = "pin"
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.canShowCallout = true
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
            popAlert()
        }
    }
    
    @IBAction func refreshButton(_ sender: UIBarButtonItem) {
        Convenience.sharedInstance.activityIndicator(loading: true)
        APIClient.sharedInstance.getStudentLocations(mapView: mapView) { (success, results, error) in
            if error != nil {
                return
            }
            guard let results = results else {
                return
            }
            if success {
                self.addAnnotation(results: results)
                Convenience.sharedInstance.activityIndicator(loading: false)
                self.mapView?.reloadInputViews()
            }
        }
    }
    
    @IBAction func logoutButton(_ sender: UIBarButtonItem) {
        guard let loginViewController = self.storyboard?.instantiateViewController(withIdentifier: "LoginViewController") else {
            return
        }
        self.present(loginViewController, animated: true, completion: nil)
        APIClient.sharedInstance.deleteSession()
    }
    
    @IBAction func addLocationButton(_ sender: UIBarButtonItem) {
        Convenience.sharedInstance.activityIndicator(loading: true)
        APIClient.sharedInstance.verifyUserLocationAlreadyExist { (results, error) in
            if error != nil {
                print("Error: \(String(describing: error))")
                return
            }
            guard let results = results else {
                return
            }
            self.verifyPostedLocation(results: results)
            Convenience.sharedInstance.activityIndicator(loading: false)
            if Student.exist {
                self.studentAlreadyExistAlert()
            }
        }
    }
    
    // MARK: Verify if student has previously posted any location
    func verifyPostedLocation(results: [[String:AnyObject]]) {
        for student in results {
            if student["uniqueKey"] as? String == Student.uniqueKey {
                Student.exist = true
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
            }
        }
    }
    
    // MARK: Add annotations to map
    func addAnnotation(results: [[String:AnyObject]]) {
        for student in results {
            let studentLocation = StudentLocation()
            var first = ""
            var last = ""
            var lat = 0.0
            var long = 0.0
            var medURL = ""
            
            if let firstName = student["firstName"] as? String {
                studentLocation.firstName = firstName
                first = firstName
            }
            if let lastName = student["lastName"] as? String {
                studentLocation.lastName = lastName
                last = lastName
            }
            if let latitude = student["latitude"] as? Double {
                studentLocation.latitude = latitude
                lat = latitude
            }
            if let longitude = student["longitude"] as? Double {
                studentLocation.longitude = longitude
                long = longitude
            }
            if let mapString = student["mapString"] as? String {
                studentLocation.mapString = mapString
            }
            if let mediaURL = student["mediaURL"] as? String {
                studentLocation.mediaURL = mediaURL
                medURL = mediaURL
            }
            if let objectId = student["objectId"] as? String {
                studentLocation.objectId = objectId
            }
            if let uniqueKey = student["uniqueKey"] as? String {
                studentLocation.uniqueKey = uniqueKey
            }
            if let createdAt = student["createdAt"] as? String {
                studentLocation.createdAt = createdAt
            }
            if let updatedAt = student["updatedAt"] as? String {
                studentLocation.updatedAt = updatedAt
            }
            StudentLocation.studentLocations.append(studentLocation)
            let latt = CLLocationDegrees(lat)
            let longg = CLLocationDegrees(long)
            let coordinate = CLLocationCoordinate2D(latitude: latt, longitude: longg)
            let annotation = MKPointAnnotation()
            annotation.coordinate = coordinate
            annotation.title = "\(first) \(last)"
            annotation.subtitle = medURL
            self.mapView?.addAnnotation(annotation)
        }
    }
    
    // MARK: Alert when mediaURL cannot be opened
    fileprivate func popAlert() {
        let alert = UIAlertController(title: "Invalid Link", message: nil, preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "Dismiss", style: .default, handler: nil)
        alert.addAction(alertAction)
        present(alert, animated: true, completion: nil)
    }
    
    // MARK: Alert when student has previously posted a location, option to overwrite to prompt segue
    fileprivate func studentAlreadyExistAlert() {
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
