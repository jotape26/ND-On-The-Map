//
//  MapViewController.swift
//  On The Map
//
//  Created by João Leite on 06/01/19.
//  Copyright © 2019 João Leite. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController {
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var studentPins: [StudentInformation]?
    
    @IBOutlet weak var studentMap: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        studentMap.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        NotificationCenter.default.addObserver(self, selector: #selector(populateMap), name: .studentDataDownloaded, object: nil)
    }
    
}

extension MapViewController: MKMapViewDelegate {
    
    @objc func populateMap(){
        DispatchQueue.main.async {
            self.studentMap.removeAnnotations(self.studentMap.annotations)
        }
        studentPins = appDelegate.studentPins!
        var annotations = [MKPointAnnotation]()
        for pin in studentPins! {
            
            guard let first = pin.firstName, let last = pin.lastName else { continue }
            
            let lat = CLLocationDegrees(pin.latitude!)
            let long = CLLocationDegrees(pin.longitude!)
            
            let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
            
            let annotation = MKPointAnnotation()
            annotation.coordinate = coordinate
            annotation.title = "\(first) \(last)"
            if let url = pin.mediaURL {
                annotation.subtitle = url
            }
            
            annotations.append(annotation)
        }
        self.studentMap.addAnnotations(annotations)
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
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if control == view.rightCalloutAccessoryView {
            if let toOpen = view.annotation {
                if let subtitle = toOpen.subtitle ?? "" {
                    if !subtitle.isEmpty{
                        let websiteURL = URL(string: subtitle)!
                        UIApplication.shared.open(websiteURL)
                    } else {
                        showURLError()
                    }
                } else {
                    showURLError()
                }
            } else {
                showURLError()
            }
        }
    }
    
    func showURLError(){
        let alert = UIAlertController(title: "Uh Oh!",
                                      message: "It looks like another student sent us an invalid URL. Please select another url!",
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel))
        self.present(alert, animated: true, completion: nil)
    }
    
}
