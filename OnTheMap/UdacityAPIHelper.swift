//
//  UdacityAPIHelper.swift
//  OnTheMap
//
//  Created by Vadim on 26.07.17.
//  Copyright © 2017 Vadim. All rights reserved.
//

import Foundation

class UdacityAPIHelper {
    struct Keys {
        static let ParseApplicationID = "QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr"
        static let RESTAPIKey = "QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY"
    }
    
    struct Udacity {
        static let Main = "https://parse.udacity.com/parse/classes"
        static let Session = "https://parse.udacity.com/api/session"
    }
    
    struct HEADERS {
        static var DONT_CHANGE_IT_1 = "QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr"
        static var DONT_CHANGE_IT_2 = "QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY"
    }
    
    struct UdacitySub {
        static let studentLocation = "/StudentLocation/"
        struct StudentLocation {
            static var limit = "limit"
            static var skip = "skip"
            static var order = "order"
        }
    }
    
    struct UdacityResponceKeys {
        static var results = "results"
        static var createdAt = "createdAt"
        static var firstName = "firstName"
        static var lastName = "lastName"
        static var latitude = "latitude"
        static var longitude = "longitude"
        static var mapString = "mapString"
        static var mediaURL = "mediaURL"
        static var objectId = "objectId"
        static var uniqueKey = "uniqueKey"
        static var updatedAt = "updatedAt"
    }
    
}
