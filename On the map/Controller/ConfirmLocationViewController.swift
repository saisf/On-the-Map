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

        guard let coordinate = Student.newLocation else {
            return
        }
        
        // Add annotation of confirming location
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        mapView?.addAnnotation(annotation)
        
        // Set region for mapView so it automatically zoom in when loaded
        let span = MKCoordinateSpanMake(0.005, 0.005)
        let region = MKCoordinateRegion(center: annotation.coordinate, span: span)
        mapView.setRegion(region, animated: true)
        
        // Reverse geocode using CLLocation to obtain detail name of entered location to be populated in annotation callout
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
                let userLocation = placemarks[0]
                guard let city = userLocation.locality, let state = userLocation.administrativeArea, let country = userLocation.country else {
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
        Convenience.sharedInstance.activityIndicator(loading: true)
        if Student.exist {
            APIClient.sharedInstance.updateExistingLocation(completion: { (success, error) in
                if error != nil { // Handle error…
                    return
                }
                if success {
                    guard let tabViewController = self.storyboard?.instantiateViewController(withIdentifier: "TabViewController") else {
                        return
                    }
                    Convenience.sharedInstance.activityIndicator(loading: false)
                    self.present(tabViewController, animated: true, completion: nil)
                }
            })
        } else {
            APIClient.sharedInstance.addNewLocation(completion: { (success, error) in
                if error != nil { // Handle error…
                    return
                }
                if success {
                    guard let tabViewController = self.storyboard?.instantiateViewController(withIdentifier: "TabViewController") else {
                        return
                    }
                    Convenience.sharedInstance.activityIndicator(loading: false)
                    self.present(tabViewController, animated: true, completion: nil)
                }
            })
        }
    }
}
