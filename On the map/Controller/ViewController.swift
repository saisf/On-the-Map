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
        //        Student.Constant.authenticateStudent(username: user, password: password, viewController: self)
        
        // MARK: Authenticate User
        APIClient.sharedInstance.authenticateStudent(username: user, password: password) { (success, uniqueKey, error) in
            guard (error == nil) else {
                self.popAlert()
                return
            }
            guard let uniqueKey = uniqueKey else {
                return
            }
            if success {
                Student.uniqueKey = uniqueKey
                print(Student.uniqueKey)
                self.performSegue(withIdentifier: "ToTabView", sender: nil)
            }
        }
    }
    
    @IBAction func signupButton(_ sender: UIButton) {
        let signupURL = URL(string: "https://auth.udacity.com/sign-up")!
        Student.Constant.openSafari(url: signupURL)
    }
    
    fileprivate func popAlert() {
        let alert = UIAlertController(title: "Invalid Email or Password", message: nil, preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "Dismiss", style: .default, handler: nil)
        alert.addAction(alertAction)
        self.present(alert, animated: true, completion: nil)
    }
}

