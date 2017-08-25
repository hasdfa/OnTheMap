//
//  PostLocationViewController.swift
//  OnTheMap
//
//  Created by Raksha Vadim on 27.07.17.
//  Copyright © 2017 Vadim. All rights reserved.
//

import UIKit

class PostLocationViewController: UIViewController {

    
    @IBOutlet weak var loadingView: UIView!
    @IBOutlet weak var locationTextView: UITextView!
    @IBAction func findOnTheMap(_ sender: UIButton){
        if locationTextView.text.isEmpty || locationTextView.text.lowercased() == "enter your location here" {
            let alert = UIAlertController(title: "Your Location is empty", message: nil, preferredStyle: .alert)
            alert.addAction(
                UIAlertAction(title: "OK", style: .default, handler: {
                    alertAction -> Void in
                    alert.dismiss(animated: true, completion: nil)
                })
            )
            self.present(alert, animated: true, completion: nil)
        } else {
            self.loadingView.alpha = 1
            MapUtils.getLatLongBy(string: locationTextView.text) {
                placemarker -> Void in
                
                if let placemarker = placemarker {
                    if let nextVC = self.storyboard?.instantiateViewController(withIdentifier: "enterLink") as? EnterLinkMapViewControler {
                        nextVC.placemarker = placemarker
                        
                        (UIApplication.shared.delegate as? AppDelegate)?.sharedStudent.latitude = placemarker.coordinate.latitude
                        (UIApplication.shared.delegate as? AppDelegate)?.sharedStudent.longitude = placemarker.coordinate.longitude
                        
                        self.present(nextVC, animated: true, completion: nil)
                    }
                } else {
                    let alert = UIAlertController(title: "Oops, we didn`t find your location.", message: nil, preferredStyle: .alert)
                    alert.addAction(
                        UIAlertAction(title: "OK", style: .default, handler: {
                            alertAction -> Void in
                            alert.dismiss(animated: true, completion: nil)
                        })
                    )
                    self.present(alert, animated: true, completion: nil)
                }
                DispatchQueue.main.async {
                    self.loadingView.alpha = 0
                }
            }
        }
    }
    @IBAction func cancelAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.loadingView.alpha = 0
        locationTextView.delegate = self
    }
}

extension PostLocationViewController: UITextViewDelegate {
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text.lowercased() == "enter your location here" {
            textView.text = ""
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "Enter Your Location Here"
        }
    }
    
}
