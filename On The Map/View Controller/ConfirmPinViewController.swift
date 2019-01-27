//
//  ConfirmPinViewController.swift
//  On The Map
//
//  Created by João Leite on 06/01/19.
//  Copyright © 2019 João Leite. All rights reserved.
//

import UIKit
import MapKit

class ConfirmPinViewController: UIViewController {

    @IBOutlet weak var txtURL: UITextField!
    @IBOutlet weak var map: MKMapView!
    @IBOutlet weak var btnPost: UIButton!
    
    var location: CLLocation?
    var mapString: String?
    let defaults = UserDefaults.standard
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        map.delegate = self
        txtURL.delegate = self
        txtURL.becomeFirstResponder()
        populateMap()
    }
    
    @IBAction func postButtonClicked(_ sender: Any) {
        
        if let userKey = defaults.string(forKey: "userKey"),
            let firstName = defaults.string(forKey: "userFirstName"),
            let lastName = defaults.string(forKey: "userLastName"),
            let userMapString = mapString,
            let studentURL = txtURL.text,
            let coordinate = location?.coordinate{
            
            let postMap = [
                "uniqueKey": userKey,
                "firstName": firstName,
                "lastName": lastName,
                "mapString": userMapString,
                "mediaURL": studentURL,
                "latitude": coordinate.latitude,
                "longitude": coordinate.longitude,
                ] as [String: AnyObject]
            
            let postInfo = StudentInformation(postMap)
            
            PinsService().postNewPin(params: postInfo,
                                     success: { (res) in
                                        DispatchQueue.main.async {
                                            let alert = UIAlertController(title: "Pin Posted!",
                                                                          message: "Your pin was successfully posted to the Udacity Community!", preferredStyle: .alert)
                                            alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: { _ in
                                                self.dismiss(animated: true, completion: nil)
                                            }))
                                            self.present(alert, animated: true, completion: nil)
                                        }
            }) { (err) in
                print(err.localizedDescription)
            }
        } else {
            DispatchQueue.main.async {
                let alert = UIAlertController(title: "Error posting Pin",
                                              message: "There was an error while preparing your information to be sent. Don't worry, this incident was sent to our team for further investigation. Sorry for the inconvenience.", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: { _ in
                    self.dismiss(animated: true, completion: nil)
                }))
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
}

extension ConfirmPinViewController: MKMapViewDelegate {
    func populateMap(){
        let annotation = MKPointAnnotation()
        
        guard let coordinate = location?.coordinate else { return }
        annotation.coordinate = coordinate
        annotation.title = "Your location!"
        self.map.addAnnotations([annotation])
        self.map.setCenter(coordinate, animated: true)
        self.map.camera.altitude = CLLocationDistance(exactly: 5000.0)!
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        let reuseId = "pin"
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
        
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView?.animatesDrop = true
            pinView?.pinTintColor = .red
            pinView?.canShowCallout = true
            pinView?.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        }
        else {
            pinView?.annotation = annotation
        }
        return pinView
    }
}

extension ConfirmPinViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
