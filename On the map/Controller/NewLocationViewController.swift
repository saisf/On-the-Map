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

//    var exist = false
    
    @IBOutlet weak var locationTextField: UITextField!
    @IBOutlet weak var mediaURL: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        locationTextField.delegate = self
        mediaURL.delegate = self
//        print(exist)
//        getCoordinateFrom(address: "Kalamazoo, Michigan") { (coordinate, error) in
//            guard let coordiante = coordinate, error == nil else {
//                return
//            }
//            DispatchQueue.main.async {
//                print(coordinate)
//            }
//        }
        
        let request = URLRequest(url: URL(string: "https://www.udacity.com/api/users/\(Student.uniqueKey)")!)
        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in
            if error != nil { // Handle error...
                return
            }
            
            DispatchQueue.main.async {
                let range = Range(5..<data!.count)
                let newData = data?.subdata(in: range) /* subset response data! */
                //                print(String(data: newData!, encoding: .utf8)!)
                let parseResult = try? JSONSerialization.jsonObject(with: newData!, options: .allowFragments) as AnyObject
                guard let user = parseResult!["user"] as? [String:AnyObject], let lastName = user["last_name"] as? String, let firstName = user["first_name"] as? String else {
                    return
                }
                print("\(firstName) \(lastName)" )
            }
            
        }
        task.resume()
    }

    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = false
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
        let objectId = "oAjNASo7n7"
        let urlString = "https://parse.udacity.com/parse/classes/StudentLocation/\(objectId)"
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
    
    func getCoordinateFrom(address: String, completion: @escaping(_ coordinate: CLLocationCoordinate2D?, _ error: Error?) -> ()) {
        CLGeocoder().geocodeAddressString(address) { (placemarks, error) in
            completion(placemarks?.first?.location?.coordinate, error)
        }
    }
    
    @IBAction func findLocation(_ sender: UIButton) {
//        var studentCoordinate: CLLocationCoordinate2D?
//
//        guard let userLocation = locationTextField.text else {
//            return
//        }
        guard let mediaURL = mediaURL.text else {
            return
        }
        
//        getCoordinateFrom(address: userLocation) { (coordinate, error) in
//            guard let coordinate = coordinate, error == nil else {
//                return
//            }
//            studentCoordinate = coordinate
//            Student.newLocation = coordinate
//            DispatchQueue.main.async {
//                print(coordinate)
//            }
//        }
        
        if verifyUrl(urlString: mediaURL){
//            performSegue(withIdentifier: "ConfirmLocationViewController", sender: nil)
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
    
    func getCoordinate(completion: @escaping(_ studentCoordinate: CLLocationCoordinate2D)-> Void) {
        guard let userLocation = locationTextField.text else {
            return
        }
        getCoordinateFrom(address: userLocation) { (coordinate, error) in
            guard let coordinate = coordinate, error == nil else {
                return
            }
            let studentCoordinate = coordinate
//            Student.newLocation = coordinate
            DispatchQueue.main.async {
                print(coordinate)
            }
            completion(studentCoordinate)
        }
    }
    
    func verifyUrl(urlString: String?) -> Bool {
        guard let urlString = urlString, let url = URL(string: urlString) else {
            return false
        }
        return UIApplication.shared.canOpenURL(url)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
