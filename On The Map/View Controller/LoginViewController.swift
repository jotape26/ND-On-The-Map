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
    @IBOutlet weak var btnLogin: UIButton!
    let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        txtEmail.delegate = self
        txtPassword.delegate = self
        btnLogin.layer.cornerRadius = 4
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        txtEmail.text = ""
        txtPassword.text = ""
    }

    @IBAction func loginButtonClicked(_ sender: Any) {
        var email = ""
        var password = ""
        
        
        if let emailText = txtEmail.text {
            if emailText != "" {
                email = emailText
            } else {
                let alert = UIAlertController(title: "Empty Email",
                                              message: "Please fill out the Email Box",
                                              preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .cancel))
                self.present(alert, animated: true, completion: nil)
                return
            }
        }
        
        if let passwordText = txtPassword.text {
            if passwordText != "" {
                password = passwordText
            } else {
                let alert = UIAlertController(title: "Empty Password",
                                              message: "Please fill out the Password Box",
                                              preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .cancel))
                self.present(alert, animated: true, completion: nil)
                return
            }
        }
        
        let actIndicator = UIActivityIndicatorView(style: .gray)
        self.view.addSubview(actIndicator)
        actIndicator.frame = view.bounds
        actIndicator.startAnimating()
        
        UserService().userLogin(email: email,
                                password: password, success: { (res) in
                                    if let account = res["account"] as? [String: AnyObject] {
                                        self.defaults.set(account["key"]!, forKey: "userKey")
                                        
                                        DispatchQueue.main.sync {
                                            actIndicator.removeFromSuperview()
                                            self.performSegue(withIdentifier: "LoginToMainSegue", sender: nil)
                                        }
                                    } else if (res["error"] as? String) != nil {
                                        let alert = UIAlertController(title: "Uh oh!",
                                                                      message: "It appears that the credentials you entered are invalid. Please verify your credentials and try again.",
                                                                      preferredStyle: .alert)
                                        alert.addAction(UIAlertAction(title: "OK", style: .cancel))
                                        
                                        DispatchQueue.main.async {
                                            self.present(alert, animated: true, completion: nil)
                                            actIndicator.removeFromSuperview()
                                            self.txtPassword.text = ""
                                            self.txtPassword.becomeFirstResponder()
                                        }
                                    }
        }) { (err) in
            let alert = UIAlertController(title: "Uh Oh!",
                                          message: "Something went wrong while trying to log you in. Please try again later",
                                          preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .cancel))
            DispatchQueue.main.async {
                self.present(alert, animated: true, completion: nil)
                actIndicator.removeFromSuperview()
                self.btnLogin.isEnabled = true
                self.btnLogin.titleLabel?.text = "LOG IN"
            }
        }
    }
    
}

// MARK: - TextFieldDelegate Methods
extension LoginViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
