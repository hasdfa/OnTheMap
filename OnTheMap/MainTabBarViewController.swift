//
//  MainTabBarViewController.swift
//  OnTheMap
//
//  Created by Raksha Vadim on 27.07.17.
//  Copyright © 2017 Vadim. All rights reserved.
//

import UIKit

class MainTabBarViewController: UITabBarController {

    public var UdacityData: UdacityDataModel = UdacityDataModel()
    public var isDataLoaded = false

    public var handlerAfterLoadData: [Any] = []
    
    @IBAction func logoutAction(_ sender: Any) {
        loadingView.alpha = 1
        RequestsHelper.deleteSession()
        loadingView.alpha = 0
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func refreshAction(_ sender: Any) {
        self.UdacityData = UdacityDataModel()
        self.isDataLoaded = false
        for handler in self.handlerAfterLoadData {
            DispatchQueue.main.async {
                if let handler_ = handler as? () -> Void {
                    handler_()
                }
            }
        }
        viewWillAppear(true)
    }
    
    @IBOutlet var loadingView: UIView!
        
    @IBAction func addLocation(_ sender: Any) {
        print((UIApplication.shared.delegate as? AppDelegate)!.isLocation, "bool")
        if (UIApplication.shared.delegate as? AppDelegate)!.sharedStudent.latitude != nil {
            print("true")
            let alert = UIAlertController(title: "You Have Already Posted a Student Location.", message: "Would You Like to Overwrite Your Current Location?", preferredStyle: .alert)
            alert.addAction(
                UIAlertAction(title: "Overwrite", style: .default, handler: {
                    action -> Void in
                    if let vc = self.storyboard?.instantiateViewController(withIdentifier: "postLocation") as? PostLocationViewController {
                        self.present(vc, animated: true, completion: nil)
                    }
                })
            )
            alert.addAction(
                UIAlertAction(title: "Cancel", style: .destructive, handler: {
                    action -> Void in
                    alert.dismiss(animated: true, completion: nil)
                })
            )
            self.present(alert, animated: true, completion: nil)
        } else {
            print("false")
            if let vc = storyboard?.instantiateViewController(withIdentifier: "postLocation") as? PostLocationViewController {
                self.present(vc, animated: true, completion: nil)
            }
        }

    }

    //o52-qT7-Bq8-D2t
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadingView.alpha = 0
        UdacityData.userID = (UIApplication.shared.delegate as? AppDelegate)?.userID ?? ""
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadingView.alpha = 1
        let getDataRequest = RequestsHelper.requestBuilder(
            path: UdacityAPIHelper.UdacitySub.studentLocation,
            options: [
                UdacityAPIHelper.UdacitySub.StudentLocation.limit: "100",
                UdacityAPIHelper.UdacitySub.StudentLocation.order: "-updatedAt"
            ]
        )
        
        JSONObject.getJSONObjectFrom(urlRequest: getDataRequest, handler: {
            json, success, error -> Void in
            
            guard error == nil else {
                print(error!.localizedDescription)
                let alert = UIAlertController(title: error!.localizedDescription, message: nil, preferredStyle: .alert)
                alert.addAction(
                    UIAlertAction(title: "OK", style: .default, handler: {
                        action -> Void in
                        alert.dismiss(animated: true, completion: nil)
                    })
                )
                self.present(alert, animated: true, completion: nil)
                return
            }
            
            if success, let json = json {
                self.UdacityData.studentsList = UdacityStudent.parseUdacityStudents(jObject: json)
            }
        }) /* after */ {
            self.isDataLoaded = true
            for handler in self.handlerAfterLoadData {
                // Cast Any to function (UdacityDataModel?) -> Void
                // And then call this func
                DispatchQueue.main.async {
                    if let handler_ = handler as? () -> Void {
                        handler_()
                    }
                    self.loadingView.alpha = 0
                }
            }
        }
        print("Appear")
    }
    //location = "<null>";
    override func viewWillDisappear(_ animated: Bool) {
        isDataLoaded = false
        self.UdacityData = UdacityDataModel()
        print("Disappear")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}
