//
//  ViewController.swift
//  OnTheMap
//
//  Created by Vadim on 26.07.17.
//  Copyright © 2017 Vadim. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController, MKMapViewDelegate {

    @IBOutlet weak var mapView: MKMapView!
    var data: UdacityDataModel = UdacityDataModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewDidLoad()
        if let tabController = self.tabBarController as? MainTabBarViewController {
            if tabController.isDataLoaded {
                DispatchQueue.main.async {
                    self.loaded(tabController.UdacityData)
                }
            } else {
                tabController.handlerAfterLoadData.append({
                    DispatchQueue.main.async {
                        self.loaded(tabController.UdacityData)
                    }
                })
            }
        }
        print("handler Added from Map")
    }

    var annotations = [MKPointAnnotation]()
    func loaded(_ data: UdacityDataModel) {
        self.data = data
        
        mapView.removeAnnotations(annotations)
        
        for student in data.studentsList {
            let lat = CLLocationDegrees(student.latitude ?? 0)
            let long = CLLocationDegrees(student.longitude ?? 0)
            
            let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
            
            let first = student.firstName
            let last = student.lastName
            let mediaURL = student.mediaURL
            
            let annotation = MKPointAnnotation()
            annotation.coordinate = coordinate
            annotation.title = "\(first ?? "Empty") \(last ?? "name")"
            annotation.subtitle = mediaURL ?? "https://google.com"
            
            annotations.append(annotation)
        }
        
        self.mapView.addAnnotations(annotations)
    }

    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        let reuseId = "pin"
        
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
        
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.canShowCallout = true
            pinView!.pinTintColor = .red
            pinView!.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        } else {
            pinView!.annotation = annotation
        }
        print(annotation.subtitle!)
        
        return pinView
    }
    
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if control == view.rightCalloutAccessoryView {
            if let toOpen = view.annotation?.subtitle! {
                UIApplication.shared.openURL(URL(string: toOpen) ?? URL(string: "http://google.com")!)
            }
        }
    }
    
}

