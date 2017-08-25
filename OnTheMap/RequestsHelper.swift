//
//  RequestsHelper.swift
//  OnTheMap
//
//  Created by Vadim on 26.07.17.
//  Copyright © 2017 Vadim. All rights reserved.
//

import Foundation
import UIKit

class RequestsHelper {
    private init() {}
    
    public static func loginRequest(username: String, password: String) -> URLRequest {
        let request = NSMutableURLRequest(url: URL(string: "https://www.udacity.com/api/session")!)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = "{\"udacity\": {\"username\": \"\(username)\", \"password\": \"\(password)\"}}".data(using: String.Encoding.utf8)
        
        return request as URLRequest
    }
    
    public static func getUserPublicData(userID: String, handler: @escaping ([String: Any], Error?) -> Void,_ after: Any){
        let request = NSMutableURLRequest(url: URL(string: "https://www.udacity.com/api/users/\(userID)")!)
        let session = URLSession.shared
        let task = session.dataTask(with: request as URLRequest) { data, response, error in
            if error != nil { // Handle error...
                handler([:], error)
                return
            }
            let range = Range(5..<data!.count)
            print(range)
            let newData = data?.subdata(in: range) /* subset response data! */
            if let newData = newData {
                do {
                    if let json = try JSONSerialization.jsonObject(with: newData, options: .allowFragments) as? [String: Any]{
                        handler(json, nil)
                    }
                } catch {
                    handler([:], error)
                }
            } else {
                handler([:], nil)
            }
            
            (after as? ()->Void)?()
        }
        task.resume()
    }
    
    public static func deleteSession() {
        let request = NSMutableURLRequest(url: URL(string: "https://www.udacity.com/api/session")!)
        request.httpMethod = "DELETE"
        var xsrfCookie: HTTPCookie? = nil
        let sharedCookieStorage = HTTPCookieStorage.shared
        for cookie in sharedCookieStorage.cookies! {
            if cookie.name == "XSRF-TOKEN" { xsrfCookie = cookie }
        }
        if let xsrfCookie = xsrfCookie {
            request.setValue(xsrfCookie.value, forHTTPHeaderField: "X-XSRF-TOKEN")
        }
        let session = URLSession.shared
        let task = session.dataTask(with: request as URLRequest) { data, response, error in
            if error != nil { // Handle error…
                return
            }
            let range = Range(5..<data!.count)
            let newData = data?.subdata(in: range) /* subset response data! */
            print(NSString(data: newData!, encoding: String.Encoding.utf8.rawValue)!)
        }
        task.resume()
    }
    
    public static func requestBuilder(path: String, options: [String: String], student: UdacityStudent? = nil) -> URLRequest {
        var url = UdacityAPIHelper.Udacity.Main
        
        var array: [String] = []
        for (k, v) in options {
            array.append("\(k)=\(v)")
        }
        if array.count > 0 {
            url += (path + "?" + array.joined(separator: "&"))
        } else {
            url += path
        }
        let request = NSMutableURLRequest(url: URL(string: url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)!)
        
        request.addValue(UdacityAPIHelper.HEADERS.DONT_CHANGE_IT_1, forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue(UdacityAPIHelper.HEADERS.DONT_CHANGE_IT_2, forHTTPHeaderField: "X-Parse-REST-API-Key")
        
        if let student = student {
            request.httpMethod = "POST"
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.httpBody = ("{" +
                    "\"uniqueKey\": \"\(student.uniqueKey ?? 0)\"," +
                    "\"firstName\": \"\(student.firstName ?? "")\"," +
                    "\"lastName\":  \"\(student.lastName ?? "")\"," +
                    "\"mapString\": \"\(student.mapString ?? "")\", " +
                    "\"mediaURL\":  \"\(student.mediaURL ?? "")\"," +
                    "\"latitude\":  \(student.latitude ?? 0.0), " +
                    "\"longitude\": \(student.longitude ?? 0.0)" +
                "}"
                ).data(using: String.Encoding.utf8)
        }
        
        return request as URLRequest
    }
    
    public static func requestBuilder(url: URL, options: [String: String], student: UdacityStudent? = nil) -> URLRequest {
        let request = NSMutableURLRequest(url: url)
        
        request.addValue("QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr", forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue("QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY", forHTTPHeaderField: "X-Parse-REST-API-Key")
        
        if let student = student {
            request.httpMethod = "POST"
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.httpBody = ("{" +
                "\"uniqueKey\": \"\(student.uniqueKey ?? 0)\"," +
                "\"firstName\": \"\(student.firstName ?? "")\"," +
                "\"lastName\":  \"\(student.lastName ?? "")\"," +
                "\"mapString\": \"\(student.mapString ?? "")\", " +
                "\"mediaURL\":  \"\(student.mediaURL ?? "")\"," +
                "\"latitude\":  \(student.latitude ?? 0.0), " +
                "\"longitude\": \(student.longitude ?? 0.0)" +
                "}"
                ).data(using: String.Encoding.utf8)
        }
        
        return request as URLRequest
    }

    
    public static func downloadImage(url: URL, handler: @escaping (UIImage?) -> Void) {
        DispatchQueue.global().async {
            var image: UIImage? = nil
            
            if let data = NSData(contentsOf: url) as Data? {
                image = UIImage(data: data)
            }
            DispatchQueue.main.async {
                handler(image)
            }
        }
    }
    
}
