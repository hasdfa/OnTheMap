//
//  LoginHelper.swift
//  OnTheMap
//
//  Created by Raksha Vadim on 29.07.17.
//  Copyright © 2017 Vadim. All rights reserved.
//

import Foundation
import UIKit

class LoginHelper {
    private init() {}
    
    public static func login(login: String, password: String,_ handlerAfter: @escaping (Bool, String?) -> Void) {
        var errorStr: String? = nil
        var sucs = false
        var id = ""
        let request = RequestsHelper.loginRequest(
            username: login,
            password: password
        )
        JSONObject.getNSStringFrom(urlRequest: request, handler: {
            json -> Void in
            
            print(json)
            if let boo = json?.contains("error"), !boo {
                if let str = json?.components(separatedBy: "\"key\": ")[1].components(separatedBy: "}")[0] {
                    if let id_ = Int(str.components(separatedBy: "\"")[1].components(separatedBy: "\"")[0]) {
                        id = "\(id_)"
                        sucs = true
                        print(id)
                    }
                }
            } else {
                errorStr = json?.components(separatedBy: "\"error\": \"")[1].components(separatedBy: "\"}")[0]
            }
        }, {
            let getStudentRequest = RequestsHelper.requestBuilder(path: "/StudentLocation?where={\"uniqueKey\":\"\(id)\"}", options: [:])
            print(getStudentRequest.url!)
            JSONObject.getJSONObjectFrom(urlRequest: getStudentRequest, handler: {
                json, success, error -> Void in
                
                guard error == nil else {
                    print(error!.localizedDescription)
                    errorStr = error!.localizedDescription
                    return
                }
                if success, let json = json {
                    print(json)
                    let student = UdacityStudent.parseUdacityStudents(jObject: json)
                    if student.count >= 1 {
                        (UIApplication.shared.delegate as? AppDelegate)?.sharedStudent = student[0]
                    } else {
                        RequestsHelper.getUserPublicData(userID: id, handler: {
                            json, error -> Void in
                            
                            guard error == nil else {
                                print(error!.localizedDescription)
                                return
                            }
                            
                            if let user = json["user"] as? [String: Any] {
                                let s =  UdacityStudent.empty
                                s.uniqueKey = UInt64(id)
                                if let first_name = user["first_name"] as? String {
                                    s.firstName = first_name
                                }
                                if let last_name = user["last_name"] as? String {
                                    s.lastName = last_name
                                }
                                (UIApplication.shared.delegate as? AppDelegate)?.sharedStudent = s
                            }
                            if let test = (json["user"] as? String)?.contains("location = \"<null>\";"), test {
                                (UIApplication.shared.delegate as? AppDelegate)?.isLocation = false
                            }
                        }, {
                            (UIApplication.shared.delegate as? AppDelegate)?.userID = id
                            print((UIApplication.shared.delegate as? AppDelegate)!.isLocation)
                        })
                    }
                }
            }) {
                handlerAfter(sucs && !id.isEmpty, errorStr)
            }
        })
    }
}
