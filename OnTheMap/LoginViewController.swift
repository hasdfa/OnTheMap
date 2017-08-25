//
//  LoginViewController.swift
//  OnTheMap
//
//  Created by Raksha Vadim on 27.07.17.
//  Copyright © 2017 Vadim. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    @IBOutlet weak var loginTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var udacityMiniImageView: UIImageView!
    @IBOutlet weak var loadingView: UIView!
    
    
    @IBAction func createAccount(_ sender: Any) {
        UIApplication.shared.openURL(URL(string: "https://auth.udacity.com/sign-up?next=https%3A%2F%2Fudacity.com")!)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadingView.alpha = 0
        setup(loginTextField)
        setup(passwordTextField)
    }
    
    private func setup(_ textField: UITextField){
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: textField.frame.height))
        textField.leftView = paddingView
        textField.leftViewMode = .always
    }
    
    @IBAction func login(_ sender: UIButton){
        check()
    }
    

    private func check() {
        loadingView.alpha = 1
        var title: String? = nil
        if loginTextField.text == nil || loginTextField.text!.isEmpty {
            title = "Email is empty"
        } else {
            let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
            if !NSPredicate(format: "SELF MATCHES %@", emailRegEx).evaluate(with: loginTextField.text!) {
                title = "Email is incorrect"
            }
        }
        if passwordTextField.text == nil || passwordTextField.text!.isEmpty {
            title = "Password is empty"
        }
        if (passwordTextField.text == nil || passwordTextField.text!.isEmpty) && (loginTextField.text == nil || loginTextField.text!.isEmpty) {
            title = "Email and password is empty"
        }
        if let title = title {
            let alert = UIAlertController(title: title, message: nil, preferredStyle: .alert)
            alert.addAction(
                UIAlertAction(title: "OK", style: .default, handler: {
                    alertAction -> Void in
                    alert.dismiss(animated: true, completion: nil)
                    self.loadingView.alpha = 0
                })
            )
            present(alert, animated: true, completion: {
                self.loadingView.alpha = 0
            })
        } else {
            LoginHelper.login(login: self.loginTextField.text!, password: passwordTextField.text!) {
                success, errorStr -> Void in
                DispatchQueue.main.async {
                    self.loadingView.alpha = 0
                    if success {
                        if let vc = self.storyboard?.instantiateViewController(withIdentifier: "mainVC") {
                            self.present(vc, animated: true, completion: nil)
                        }
                    } else {
                        let title = errorStr ?? "Oops, some error. Please reply later."
                        let alert = UIAlertController(title: title, message: nil, preferredStyle: .alert)
                        alert.addAction(
                            UIAlertAction(title: "OK", style: .default, handler: {
                                alertAction -> Void in
                                alert.dismiss(animated: true, completion: nil)
                                self.loadingView.alpha = 0
                            })
                        )
                        self.present(alert, animated: true, completion: {
                            self.loadingView.alpha = 0
                        })
                    }
                }
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
