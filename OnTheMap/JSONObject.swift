//
//  JSONObject.swift
//  SleepingInTheLibrary
//
//  Created by Raksha Vadim on 25.07.17.
//  Copyright © 2017 Udacity. All rights reserved.
//
/*
 Copyright 2017 Vadim Raksha
 
 Licensed under the Apache License, Version 2.0 (the "License");
 you may not use this file except in compliance with the License.
 You may obtain a copy of the License at
 
 http://www.apache.org/licenses/LICENSE-2.0
 
 Unless required by applicable law or agreed to in writing, software
 distributed under the License is distributed on an "AS IS" BASIS,
 WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 See the License for the specific language governing permissions and
 limitations under the License.
*/

import Foundation
import UIKit

class JSONObject: Any {
    
    private init() {}
    
//    fileprivate var jsonObject: [String: Any]? = nil
//    fileprivate var jsonString: NSString? = ""
//    
//    init(_ object: Any?, _ jsonString: NSString?) {
//        self.jsonObject = object as? [String: Any]
//        self.jsonString = jsonString
//    }
//    
//    fileprivate init(_ object: Any?) {
//        self.jsonObject = object as? [String: Any]
//    }
//    
//    fileprivate init(_ object: JSONObject?) {
//        self.jsonObject = object?.jsonObject
//        self.jsonString = object?.jsonString
//    }
//    
//    init(_ dictionary: [String: Any]?, _ jsonString: NSString?) {
//        self.jsonObject = dictionary
//        self.jsonString = jsonString
//    }
    
}

// MARK: parse extensions
//extension JSONObject {
//    
//    fileprivate subscript(_ str: String) -> Any? {
//        return jsonObject?[str]
//    }
//    
//    public func toString() -> NSString {
//        return jsonString ?? "JSONObject(_: empty)"
//    }
//    
//    public func getJsonObject(_ sub: String) -> JSONObject? {
//        return JSONObject(jsonObject?[sub])
//    }
//    
//    public func getJsonArray(_ sub: String) -> JSONArray? {
//        return JSONArray(jsonObject?[sub])
//    }
//    
//    public func getString(_ sub: String) -> String? {
//        return
//            jsonObject?[sub] as? String
//    }
//    
//    public func getInt(_ sub: String) -> Int? {
//        return jsonObject?[sub] as? Int
//    }
//    
//    public func getAny(_ sub: String) -> Any {
//        return jsonObject?[sub] as Any
//    }
//    
//    fileprivate func getArray() -> [String: Any]? {
//        return jsonObject
//    }
//    
//}

// MARK: static extension
extension JSONObject {
    
    public static func createJSONObject(data: Data, options: JSONSerialization.ReadingOptions = .allowFragments, handler: ([String: Any]?, Bool, Error?) -> Void) {
        
//        let newData = NSString(data: data, encoding: String.Encoding.utf8.rawValue)!
        do {
            if let json = try JSONSerialization.jsonObject(with: data, options: options) as? [String: Any] {
                handler(json, true, nil)
                return
            }
        } catch {
            handler(nil, false, error)
            return
        }
        handler(nil, false, nil)
    }
    
    
    public static func getJSONObjectFrom(urlRequest: URLRequest, handler: @escaping ([String: Any]?, Bool, Error?) -> Void,_ after: Any...) {
        
        let task = URLSession(configuration: .default).dataTask(with: urlRequest as URLRequest, completionHandler: { data, responder, error -> Void in
            
            guard error == nil else {
                handler(nil, false, error)
                return
            }
            
            if let data = data {
                JSONObject.createJSONObject(data: data, handler: handler)
            } else {
                handler(nil, false, error)
            }
            // MARK: after
            for a in after {
                if let afterHandler = a as? () -> Void {
                    afterHandler()
                }
            }
        })
        task.resume()
    }
    
    
    public static func getNSStringFrom(urlRequest: URLRequest, handler: @escaping (NSString?) -> Void,_ after: Any...) {
        let task = URLSession(configuration: .default).dataTask(with: urlRequest as URLRequest, completionHandler: { data, responder, error -> Void in
            
            guard error == nil else {
                handler(nil)
                return
            }
            
            if let data = data {
                let newData = NSString(data: data, encoding: String.Encoding.utf8.rawValue)
                handler(newData)
            } else {
                handler(nil)
            }
            // MARK: after
            for a in after {
                if let afterHandler = a as? () -> Void {
                    afterHandler()
                }
            }
        })
        task.resume()
    }
}
