//
//  ViewController.swift
//  On the map
//
//  Created by Sai Leung on 5/18/18.
//  Copyright © 2018 Sai Leung. All rights reserved.
//

import UIKit
import NVActivityIndicatorView

class ViewController: UIViewController {

    
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var login: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        login.clipsToBounds = true
        login.layer.cornerRadius = 10
    }
    
    override func viewWillAppear(_ animated: Bool) {
        // Ensure username and password are required to be entered when logout
        usernameTextField.text = ""
        passwordTextField.text = ""
    }

    @IBAction func loginButton(_ sender: UIButton) {
        
        guard let user = usernameTextField.text, let password = passwordTextField.text else {
            return
        }
        
        Student.Constant.authenticateStudent(username: user, password: password, viewController: self)
        
//        var request = URLRequest(url: URL(string: "https://www.udacity.com/api/session")!)
//        request.httpMethod = "POST"
//        request.addValue("application/json", forHTTPHeaderField: "Accept")
//        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
//        request.httpBody = "{\"udacity\": {\"username\": \"\(user)\", \"password\": \"\(password)\"}}".data(using: .utf8)
//        let session = URLSession.shared
//        let task = session.dataTask(with: request) { data, response, error in
//            if error != nil { // Handle error…
//                return
//            }
//
//            DispatchQueue.main.async {
//                let range = Range(5..<data!.count)
//                let newData = data?.subdata(in: range) /* subset response data! */
//                print(String(data: newData!, encoding: .utf8)!)
//                var parseResult: AnyObject! = nil
//
//                do {
//                    parseResult = try JSONSerialization.jsonObject(with: newData!, options: .allowFragments) as AnyObject
//                } catch {
//                    print("Error: \(error)")
//                }
//
//                guard let sessionID = parseResult?["session"] as? [String: String] else {
//                    let alert = UIAlertController(title: "Invalid Email or Password", message: nil, preferredStyle: .alert)
//                    let alertAction = UIAlertAction(title: "Dismiss", style: .default, handler: nil)
//                    alert.addAction(alertAction)
//                    self.present(alert, animated: true, completion: nil)
//                    return
//                }
//
//                guard let session = sessionID["id"] else {
//                    return
//                }
//
//                guard let account = parseResult?["account"] as? [String: AnyObject], let registered = account["registered"] as? Bool, let uniqueKey = account["key"] as? String else {
//                    return
//                }
//
//                Student.uniqueKey = uniqueKey
//
//                if registered {
//                    self.performSegue(withIdentifier: "ToTabView", sender: nil)
//                    Student.Constant.deleteSession()
//                }
//            }
//
//        }
//
//        task.resume()

    }
    @IBAction func signupButton(_ sender: UIButton) {
        let signupURL = URL(string: "https://auth.udacity.com/sign-up")!
        Student.Constant.openSafari(url: signupURL)
    }
}

