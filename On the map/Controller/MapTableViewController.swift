//
//  MapTableViewController.swift
//  On the map
//
//  Created by Sai Leung on 5/22/18.
//  Copyright © 2018 Sai Leung. All rights reserved.
//

import UIKit
import NVActivityIndicatorView

class MapTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        Convenience.sharedInstance.activityIndicator(loading: true)

        // MARK: Get student locations
        APIClient.sharedInstance.getStudentLocations { (success, results, error)  in
            if error != nil {
                Convenience.sharedInstance.activityIndicator(loading: false)
                self.fetchingFailureAlert()
                return
            }
            guard let results = results else {
                return
            }
            if success {
                self.loadCellData(results: results)
                Convenience.sharedInstance.activityIndicator(loading: false)
            }
        }
    }

    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return UserManager.sharedInstance.locations.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var first = "[No First Name]"
        var last = "[No Last Name]"
        var media = "[No Media URL]"
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let studentLocation = UserManager.sharedInstance.locations[indexPath.row]
        if let firstName = studentLocation.firstName {
            first = firstName
        }
        if let lastName = studentLocation.lastName {
            last = lastName
        }
        if let mediaURL = studentLocation.mediaURL {
            media = mediaURL
        }
        cell.textLabel?.text = "\(first) \(last)"
        cell.detailTextLabel?.text = media

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let studentLocation = UserManager.sharedInstance.locations[indexPath.row]
        if verifyUrl(urlString: studentLocation.mediaURL!) == true {
            let url = URL(string: studentLocation.mediaURL!)
            UIApplication.shared.open(url!, options: [:], completionHandler: nil)
        } else {
            popAlert()
        }
    }
    
    // Function to verify if a url entered can be opened
    func verifyUrl(urlString: String?) -> Bool {
        guard let urlString = urlString, let url = URL(string: urlString) else {
            return false
        }
        return UIApplication.shared.canOpenURL(url)
    }
    
    // MARK: Add annotations to map
    func loadCellData(results: [StudentInformation]) {
        UserManager.sharedInstance.locations.removeAll()
        UserManager.sharedInstance.locations = results
    }
    
    @IBAction func refreshButton(_ sender: UIBarButtonItem) {
        Convenience.sharedInstance.activityIndicator(loading: true)
        
        // MARK: Refresh student locations
        APIClient.sharedInstance.getStudentLocations { (success, results, error)  in
            if error != nil {
                Convenience.sharedInstance.activityIndicator(loading: false)
                self.fetchingFailureAlert()
                return
            }
            guard let results = results else {
                return
            }
            if success {
                self.loadCellData(results: results)
                Convenience.sharedInstance.activityIndicator(loading: false)
            }
        }
    }
    
    @IBAction func logoutButton(_ sender: UIBarButtonItem) {
        logoutAlert()
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
    func verifyPostedLocation(results: [StudentInformation]) {
        for student in results {
            guard let uniqueKey = student.uniqueKey else {
                return
            }
            guard let studentFirstName = student.firstName else {
                return
            }
            guard let studentLastName = student.lastName else {
                return
            }
            guard let objectId = student.objectId else {
                return
            }
            if uniqueKey == Student.uniqueKey {
                Student.exist = true
                Student.firstName = studentFirstName
                Student.lastName = studentLastName
                Student.objectId = objectId
            }
        }
    }
    
    // MARK: Fetching data failure alert
    func fetchingFailureAlert() {
        let alert = UIAlertController(title: "Connection Failed", message: "Please Try Again", preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "Dismiss", style: .default, handler: nil)
        alert.addAction(alertAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    // MARK: Logout confirmation alert
    func logoutAlert() {
        guard let loginViewController = self.storyboard?.instantiateViewController(withIdentifier: "LoginViewController") else {
            return
        }
        let alert = UIAlertController(title: nil, message: "Do you want to exit?", preferredStyle: .alert)
        let overwriteAlertAction = UIAlertAction(title: "Confirm", style: .default, handler: { (action) in
            self.present(loginViewController, animated: true, completion: nil)
            APIClient.sharedInstance.deleteSession()
        })
        let cancelAlertAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(overwriteAlertAction)
        alert.addAction(cancelAlertAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    // MARK: Alert when student has previously posted a location, option to overwrite to prompt segue
    fileprivate func studentAlreadyExistAlert() {
        let alert = UIAlertController(title: nil, message: "User \"\(Student.firstName) \(Student.lastName)\" Has Already Posted a Student Location. Would you like to Overwrite Their Location?", preferredStyle: .alert)
        let overwriteAlertAction = UIAlertAction(title: "Overwrite", style: .default, handler: { (action) in
            self.performSegue(withIdentifier: "ToAddLocationFromTable", sender: nil)
        })
        let cancelAlertAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(overwriteAlertAction)
        alert.addAction(cancelAlertAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    fileprivate func popAlert() {
        let alert = UIAlertController(title: "Invalid Link", message: nil, preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "Dismiss", style: .default, handler: nil)
        alert.addAction(alertAction)
        present(alert, animated: true, completion: nil)
    }
}
