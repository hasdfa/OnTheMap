//
//  UdacityStudent.swift
//  OnTheMap
//
//  Created by Raksha Vadim on 26.07.17.
//  Copyright © 2017 Vadim. All rights reserved.
//

import Foundation
import UIKit

class UdacityStudent {
    fileprivate init() {}
    
    var createdAt: String?
    var firstName: String?
    var lastName: String?
    var latitude: Double?
    var longitude: Double?
    var mapString: String?
    var mediaURL: String?
    var objectId: String?
    var uniqueKey: UInt64?
    var updatedAt: String?
}

extension UdacityStudent {
    
    public static var empty = UdacityStudent()
    
    public static func parseUdacityStudents(jObject: [String: Any]) -> [UdacityStudent]{
        var students: [UdacityStudent] = []
        if let results = jObject[UdacityAPIHelper.UdacityResponceKeys.results] as? [[String: Any]] {
            for j in results {
                let newStudent = createStudent(jsonObj: j)
                students.append(newStudent)
            }
            print(results.count)
        } else {
            print("error when get an array")
        }
        return students
    }
    
    fileprivate static func createStudent(jsonObj: [String: Any]) -> UdacityStudent {
        let student = UdacityStudent()
        let pH = ParceHelper(jsonObj)
        
        student.createdAt = pH.getStringByKey(UdacityAPIHelper.UdacityResponceKeys.createdAt)
        student.firstName = pH.getStringByKey(UdacityAPIHelper.UdacityResponceKeys.firstName)
        student.lastName  = pH.getStringByKey(UdacityAPIHelper.UdacityResponceKeys.lastName)
        student.latitude  = pH.getDoubleByKey(UdacityAPIHelper.UdacityResponceKeys.latitude)
        student.longitude = pH.getDoubleByKey(UdacityAPIHelper.UdacityResponceKeys.longitude)
        student.mapString = pH.getStringByKey(UdacityAPIHelper.UdacityResponceKeys.mapString)
        student.mediaURL  = pH.getStringByKey(UdacityAPIHelper.UdacityResponceKeys.mediaURL)
        student.objectId  = pH.getStringByKey(UdacityAPIHelper.UdacityResponceKeys.objectId)
        student.uniqueKey = pH.getUInt64ByKey(UdacityAPIHelper.UdacityResponceKeys.uniqueKey)
        student.updatedAt = pH.getStringByKey(UdacityAPIHelper.UdacityResponceKeys.updatedAt)
        
        return student
    }
    
    class ParceHelper {
        
        private var jObject: [String: Any]
        
        init(_ jsonObject: [String: Any]) {
            jObject = jsonObject
        }
        
        fileprivate func getStringByKey(_ key: String) -> String? {
            return jObject[key] as? String
        }
        
        fileprivate func getDoubleByKey(_ key: String) -> Double? {
            return jObject[key] as? Double
        }
        
        fileprivate func getUInt64ByKey(_ key: String) -> UInt64? {
            return jObject[key] as? UInt64
        }
    }
    
}
