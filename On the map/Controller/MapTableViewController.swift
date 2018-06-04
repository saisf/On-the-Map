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
        tableView.reloadData()
        Student.Constant.getStudentLocations(mapView: nil)
    }

    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return StudentLocation.studentLocations.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var first = "[No First Name]"
        var last = "[No Last Name]"
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let studentLocation = StudentLocation.studentLocations[indexPath.row]
        if let firstName = studentLocation.firstName {
            first = firstName
        }
        if let lastName = studentLocation.lastName {
            last = lastName
        }
        cell.textLabel?.text = "\(first) \(last)"
        cell.detailTextLabel?.text = studentLocation.mediaURL

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let studentLocation = StudentLocation.studentLocations[indexPath.row]

        if verifyUrl(urlString: studentLocation.mediaURL!) == true {
            let url = URL(string: studentLocation.mediaURL!)
            UIApplication.shared.open(url!, options: [:], completionHandler: nil)
        } else {
            let alert = UIAlertController(title: "Invalid Link", message: nil, preferredStyle: .alert)
            let alertAction = UIAlertAction(title: "Dismiss", style: .default, handler: nil)
            alert.addAction(alertAction)
            present(alert, animated: true, completion: nil)
        }
        
    }
    
    // Function to verify if a url entered can be opened
    func verifyUrl(urlString: String?) -> Bool {
        guard let urlString = urlString, let url = URL(string: urlString) else {
            return false
        }
        return UIApplication.shared.canOpenURL(url)
    }
    
    @IBAction func refreshButton(_ sender: UIBarButtonItem) {
        Student.Constant.getStudentLocations(mapView: nil)
    }
    
    @IBAction func logoutButton(_ sender: UIBarButtonItem) {
        guard let loginViewController = self.storyboard?.instantiateViewController(withIdentifier: "LoginViewController") else {
            return
        }
        self.present(loginViewController, animated: true, completion: nil)
        Student.Constant.deleteSession()
    }
    
    @IBAction func addLocationButton(_ sender: UIBarButtonItem) {
        Student.Constant.verifyUserLocationAlreadyExist(viewController: self, segueIdentifier: "ToAddLocationFromTable")
    }
}
