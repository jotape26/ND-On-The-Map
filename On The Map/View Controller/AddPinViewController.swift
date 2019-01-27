//
//  AddPinViewController.swift
//  On The Map
//
//  Created by João Leite on 06/01/19.
//  Copyright © 2019 João Leite. All rights reserved.
//

import UIKit
import MapKit

class AddPinViewController: UIViewController {

    @IBOutlet weak var txtLocation: UITextField!
    @IBOutlet weak var btnSearch: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    let locationHelper = CLGeocoder()
    var parsedLocation: CLLocation?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        btnSearch.layer.cornerRadius = 4
        txtLocation.delegate = self
        txtLocation.becomeFirstResponder()
        toggleActivityIndicator(activityIndicator)
        // Do any additional setup after loading the view.
    }
    
    @IBAction func cancelButtonClicked(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }

    @IBAction func searchButtonClicked(_ sender: Any) {
        guard let stringLocation = self.txtLocation.text else { return }
        toggleActivityIndicator(activityIndicator)
        txtLocation.resignFirstResponder()
        findLocation(stringLocation)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "SearchToConfirmPinSegue"{
            if let viewController = segue.destination as? ConfirmPinViewController {
                viewController.location = parsedLocation
                viewController.mapString = txtLocation.text
            }
        }
    }
    
}

extension AddPinViewController {
    func findLocation(_ location: String){
        locationHelper.geocodeAddressString(location) { (mark, err) in
            if err != nil {
                let alert = UIAlertController(title: "Uh oh!",
                                              message: "Error parsing your location. Please verify your location and try again.",
                                              preferredStyle: .alert)
                
                alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                self.present(alert, animated: true, completion: {
                    DispatchQueue.main.async {
                        self.txtLocation.text = ""
                    }
                })
                return
            }
            
            if !(mark?.isEmpty)! {
                self.parsedLocation = mark?.first?.location
                self.toggleActivityIndicator(self.activityIndicator)
                self.performSegue(withIdentifier: "SearchToConfirmPinSegue", sender: nil)
            } else {
                let alert = UIAlertController(title: "Location Not Found",
                                              message: "Sorry, we couldn't find your location. Please verify your location and try again.",
                                              preferredStyle: .alert)
                
                alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                self.present(alert, animated: true, completion: {
                    DispatchQueue.main.async {
                        self.txtLocation.text = ""
                    }
                })
            }
        }
    }
    
    func toggleActivityIndicator(_ indicator: UIActivityIndicatorView){
        if indicator.isHidden == true {
            indicator.isHidden = !indicator.isHidden
            indicator.startAnimating()
        } else {
            indicator.isHidden = !indicator.isHidden
            indicator.stopAnimating()
        }
    }
}

extension AddPinViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
