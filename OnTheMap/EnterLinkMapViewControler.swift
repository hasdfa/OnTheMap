//
//  EnterLinkMapViewControler.swift
//  OnTheMap
//
//  Created by Raksha Vadim on 27.07.17.
//  Copyright © 2017 Vadim. All rights reserved.
//

import UIKit
import MapKit

class EnterLinkMapViewControler: UIViewController {

    var placemarker: MKPlacemark? = nil
    
    
    @IBOutlet weak var loadingView: UIView!
    @IBOutlet weak var linkTextView: UITextView!
    @IBOutlet weak var mapView: MKMapView!
    
    @IBAction func cancelAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func submitAction(_ sender: Any) {
        if let placemarker = placemarker {
            let student = (UIApplication.shared.delegate as? AppDelegate)!.sharedStudent
            student.mediaURL = self.linkTextView.text
            let request = RequestsHelper.requestBuilder(path: UdacityAPIHelper.UdacitySub.studentLocation, options: [:], student: student)
            var succs = false
            loadingView.alpha = 1
            JSONObject.getJSONObjectFrom(urlRequest: request, handler: {
                json, success, error -> Void in
                guard error == nil else {
                    let alert = UIAlertController(title: "Error", message: error!.localizedDescription, preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: {
                        action -> Void in
                        alert.dismiss(animated: true, completion: nil)
                    }))
                    DispatchQueue.main.async {
                        self.loadingView.alpha = 0
                        self.present(alert, animated: true)
                    }
                    return
                }
                if succs, let json = json {
                    print(json)
                    succs = true
                }
            }) /* after */ {
                if succs {
                    (UIApplication.shared.delegate as? AppDelegate)?.sharedStudent.mediaURL = self.linkTextView.text
                    let request = RequestsHelper.requestBuilder(path: UdacityAPIHelper.UdacitySub.studentLocation, options: [:], student: (UIApplication.shared.delegate as? AppDelegate)?.sharedStudent)
                    JSONObject.getJSONObjectFrom(urlRequest: request, handler: {
                        json, success, error -> Void in
                        succs = false
                        
                        guard error == nil else {
                            let alert = UIAlertController(title: "Error", message: error!.localizedDescription, preferredStyle: .alert)
                            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: {
                                action -> Void in
                                alert.dismiss(animated: true, completion: nil)
                            }))
                            DispatchQueue.main.async {
                                self.loadingView.alpha = 0
                                self.present(alert, animated: true)
                            }
                            return
                        }
                        if succs, let json = json {
                            print(json)
                            succs = true
                        }
                    }) /* after */ {
                        if let vc = self.storyboard?.instantiateViewController(withIdentifier: "mainVC") {
                            self.present(vc, animated: true, completion: nil)
                        }
                        DispatchQueue.main.async {
                            self.loadingView.alpha = 0
                        }
                    }
                } else {
                    if let vc = self.storyboard?.instantiateViewController(withIdentifier: "mainVC") {
                        self.present(vc, animated: true, completion: nil)
                    }
                    DispatchQueue.main.async {
                        self.loadingView.alpha = 0
                    }
                }
            }
        }
    }
    
    
    override func dismiss(animated flag: Bool, completion: (() -> Void)? = nil) {
        DispatchQueue.main.async {
            super.dismiss(animated: flag, completion: completion)
        }
    }
    
    override func present(_ viewControllerToPresent: UIViewController, animated flag: Bool, completion: (() -> Void)? = nil) {
        DispatchQueue.main.async {
            super.present(viewControllerToPresent, animated: flag, completion: completion)
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadingView.alpha = 0
        linkTextView.delegate = self
        
        if let placemarker = placemarker {
            mapView.addAnnotation(placemarker)
            mapView.camera.centerCoordinate = placemarker.coordinate
            mapView.camera.altitude = 1_000_000
        }
    }

}


extension EnterLinkMapViewControler: UITextViewDelegate {
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text.lowercased() == "enter a link to share here" {
            textView.text = ""
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "Enter a Link to Share Here"
        }
    }
    
}
