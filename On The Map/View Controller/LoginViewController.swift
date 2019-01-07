//
//  LoginViewController.swift
//  On The Map
//
//  Created by João Leite on 06/01/19.
//  Copyright © 2019 João Leite. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        txtEmail.delegate = self
        txtPassword.delegate = self
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        txtEmail.text = ""
        txtPassword.text = ""
    }

    @IBAction func loginButtonClicked(_ sender: Any) {
        guard let email = txtEmail.text else {
            print("email empty")
            return
        }
        
        guard let password = txtPassword.text else {
            print("password empty")
            return
        }
        
        var request = URLRequest(url: Constants.ApiURL.init().loginURL)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = "{\"udacity\": {\"username\": \"\(email)\", \"password\": \"\(password)\"}}".data(using: .utf8)
        let session = URLSession.shared
        
        let task = session.dataTask(with: request) { (data, res, err) in
            if err != nil {
                print(err!)
                return
            }
            
                let parsedData = try! JSONSerialization.jsonObject(with: data!.subdata(in: 5..<data!.count), options: .allowFragments) as! [String : AnyObject]
                
                if let account = parsedData["account"] as? [String: AnyObject] {
                    self.defaults.set(account["key"]!, forKey: "userKey")
                    
                    DispatchQueue.main.sync {
                        self.performSegue(withIdentifier: "LoginToMainSegue", sender: nil)
                    }
            }
            
        }
        
        task.resume()
        
    }
    
}

// MARK: - TextFieldDelegate Methods
extension LoginViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
