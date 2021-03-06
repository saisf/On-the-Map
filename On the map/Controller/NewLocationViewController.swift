//
//  NewLocationViewController.swift
//  On the map
//
//  Created by Sai Leung on 5/30/18.
//  Copyright © 2018 Sai Leung. All rights reserved.
//

import UIKit
import CoreLocation

class NewLocationViewController: UIViewController, UITextFieldDelegate {
    @IBOutlet weak var locationTextField: UITextField!
    @IBOutlet weak var mediaURL: UITextField!
    @IBOutlet weak var findLocationButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationTextField.delegate = self
        mediaURL.delegate = self
        findLocationButton.clipsToBounds = true
        findLocationButton.layer.cornerRadius = 10
        
        // MARK: Get user basic information
        APIClient.sharedInstance.getStudentBasicInformation { (success, results, error) in
            if error != nil { // Handle error...
                return
            }
            guard let user = results!["user"] as? [String:AnyObject], let lastName = user["last_name"] as? String, let firstName = user["first_name"] as? String else {
                return
            }
            Student.firstName = firstName
            Student.lastName = lastName
            print("\(Student.firstName) \(Student.lastName)")
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = false
    }

    @IBAction func findLocation(_ sender: UIButton) {
        guard let mediaURL = mediaURL.text else {
            return
        }
        if verifyUrl(urlString: mediaURL){
            getCoordinate(completion: { (coordinate) in
                Student.newLocation = coordinate
                Student.mediaURL = mediaURL
                self.performSegue(withIdentifier: "ConfirmLocationViewController", sender: nil)
            })
        } else {
            let alert = UIAlertController(title: "Invalid Link", message: nil, preferredStyle: .alert)
            let alertAction = UIAlertAction(title: "Dismiss", style: .default, handler: nil)
            alert.addAction(alertAction)
            present(alert, animated: true, completion: nil)
        }
    }
    
    // FUNCTION : Get coordinate from address string
    func getCoordinateFrom(address: String, completion: @escaping(_ coordinate: CLLocationCoordinate2D?, _ error: Error?) -> ()) {
        CLGeocoder().geocodeAddressString(address) { (placemarks, error) in
            completion(placemarks?.first?.location?.coordinate, error)
        }
    }
    
    func getCoordinate(completion: @escaping(_ studentCoordinate: CLLocationCoordinate2D)-> Void) {
        guard let userLocation = locationTextField.text else {
            return
        }
        getCoordinateFrom(address: userLocation) { (coordinate, error) in
            guard let coordinate = coordinate, error == nil else {
                return
            }
            let studentCoordinate = coordinate
            completion(studentCoordinate)
        }
    }
    
    func verifyUrl(urlString: String?) -> Bool {
        guard let urlString = urlString, let url = URL(string: urlString) else {
            return false
        }
        return UIApplication.shared.canOpenURL(url)
    }
}
