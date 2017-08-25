//
//  MapUtils.swift
//  OnTheMap
//
//  Created by Raksha Vadim on 27.07.17.
//  Copyright © 2017 Vadim. All rights reserved.
//

import Foundation
import UIKit
import MapKit

class MapUtils {
    private init() {}
    
    public static func getLatLongBy(string addres: String,_ handler: @escaping (MKPlacemark?) -> Void) {
        let geocoder = CLGeocoder.init()
        geocoder.geocodeAddressString(addres, completionHandler: {
            placemarks, error -> Void in
            
            var placemark: MKPlacemark? = nil
            
            guard error == nil else {
                print(error!.localizedDescription)
                handler(placemark)
                return
            }
            
            if let placemarks = placemarks, placemarks.count > 0 {
                let topResult = placemarks[0]
                placemark = MKPlacemark(placemark: topResult)
            }
            
            handler(placemark)
        })
    }
    
}
