//
//  ConfirmLocationViewController.swift
//  On the map
//
//  Created by Sai Leung on 5/31/18.
//  Copyright © 2018 Sai Leung. All rights reserved.
//

import UIKit
import MapKit
import NVActivityIndicatorView

class ConfirmLocationViewController: UIViewController, MKMapViewDelegate {
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var finish: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        finish.clipsToBounds = true
        finish.layer.cornerRadius = 10
        // Do any additional setup after loading the view.
//        guard let coordinate = Student.newLocation else {
//            return
//        }
//        let annotation = MKPointAnnotation()
//        annotation.coordinate = coordinate
////        annotation.title = "\(first) \(last)"
////
////        annotation.subtitle = medURL
//
//        mapView?.addAnnotation(annotation)
        
        guard let coordinate = Student.newLocation else {
            return
        }
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
//        annotation.title = "Hi"
        //
        //        annotation.subtitle = medURL
        print("Location successful")
        mapView?.addAnnotation(annotation)
        
        let span = MKCoordinateSpanMake(0.005, 0.005)
        
        let region = MKCoordinateRegion(center: annotation.coordinate, span: span)
        mapView.setRegion(region, animated: true)
        
        let location = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
        
        CLGeocoder().reverseGeocodeLocation(location) { (placemarks, error) in
            if error != nil {
                print("Reverse geocoder failed with error" + (error?.localizedDescription)!)
                return
            }
            
            guard let placemarks = placemarks else {
                return
            }
            
            if placemarks.count > 0 {

                let pm = placemarks[0]
                guard let city = pm.locality, let state = pm.administrativeArea, let country = pm.country else {
                    return
                }
                annotation.title = "\(city), \(state), \(country)"
                Student.studentCity = city
                Student.studentState = state
            } else {
                print("Problem with the data received from geocoder")
            }
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.tabBarController?.tabBar.isHidden = false
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {

        var pinView = mapView as? MKPinAnnotationView
        pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: nil)
        pinView?.canShowCallout = true
        
        return pinView

    }
    @IBAction func finishButton(_ sender: UIButton) {
        // if not exist
        
        
        
        // if exist
        if Student.exist {
            NVActivityIndicatorView.DEFAULT_BLOCKER_SIZE = CGSize(width: 80, height: 80)
            NVActivityIndicatorView.DEFAULT_TYPE = .orbit
            NVActivityIndicatorPresenter.sharedInstance.startAnimating(MapViewController.activityData)
            guard let latitude = Student.newLocation?.latitude, let longitude = Student.newLocation?.longitude else {
                return
            }
            let objectId = "oAjNASo7n7"
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
                    return
                }
                DispatchQueue.main.async {
                    print(String(data: data!, encoding: .utf8)!)
                    guard let tabViewController = self.storyboard?.instantiateViewController(withIdentifier: "TabViewController") else {
                        return
                    }

                    NVActivityIndicatorPresenter.sharedInstance.stopAnimating()
                    self.present(tabViewController, animated: true, completion: nil)
                }

            }
            task.resume()
        } else {
            NVActivityIndicatorView.DEFAULT_BLOCKER_SIZE = CGSize(width: 80, height: 80)
            NVActivityIndicatorView.DEFAULT_TYPE = .orbit
            NVActivityIndicatorPresenter.sharedInstance.startAnimating(MapViewController.activityData)
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
                    return
                }
                DispatchQueue.main.async {
                    print(String(data: data!, encoding: .utf8)!)
                    guard let tabViewController = self.storyboard?.instantiateViewController(withIdentifier: "TabViewController") else {
                        return
                    }
                    NVActivityIndicatorPresenter.sharedInstance.stopAnimating()
                    self.present(tabViewController, animated: true, completion: nil)
                }
                
            }
            task.resume()
        }
    }
    
    func addNewLocation() {
        var request = URLRequest(url: URL(string: "https://parse.udacity.com/parse/classes/StudentLocation")!)
        request.httpMethod = "POST"
        request.addValue("QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr", forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue("QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY", forHTTPHeaderField: "X-Parse-REST-API-Key")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = "{\"uniqueKey\": \"1234\", \"firstName\": \"John\", \"lastName\": \"Doe\",\"mapString\": \"Mountain View, CA\", \"mediaURL\": \"https://udacity.com\",\"latitude\": 37.386052, \"longitude\": -122.083851}".data(using: .utf8)
        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in
            if error != nil { // Handle error…
                return
            }
            print(String(data: data!, encoding: .utf8)!)
        }
        task.resume()
        
    }
    
    func updateExistingLocation() {
        let urlString = "https://parse.udacity.com/parse/classes/StudentLocation/8ZExGR5uX8"
        let url = URL(string: urlString)
        var request = URLRequest(url: url!)
        request.httpMethod = "PUT"
        request.addValue("QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr", forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue("QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY", forHTTPHeaderField: "X-Parse-REST-API-Key")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = "{\"uniqueKey\": \"1234\", \"firstName\": \"John\", \"lastName\": \"Doe\",\"mapString\": \"Cupertino, CA\", \"mediaURL\": \"https://udacity.com\",\"latitude\": 37.322998, \"longitude\": -122.032182}".data(using: .utf8)
        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in
            if error != nil { // Handle error…
                return
            }
            print(String(data: data!, encoding: .utf8)!)
        }
        task.resume()
        
    }
    
//    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
//        let pinToZoomOn = view.annotation
//
//        let span = MKCoordinateSpanMake(0.5, 0.5)
//
//        let region = MKCoordinateRegion(center: pinToZoomOn!.coordinate, span: span)
//        mapView.setRegion(region, animated: true)
//    }
//    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        // Get the new view controller using segue.destinationViewController.
//        // Pass the selected object to the new view controller.
//    }
//    */

}
