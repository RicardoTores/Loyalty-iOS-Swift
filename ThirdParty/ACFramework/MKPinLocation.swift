//
//  MKPinLocation.swift
//  Loyalty
//
//  Created by Alex on 04/10/15.
//  Copyright © 2015 Colectivo Coffee Roasters Inc. All rights reserved.
//

import Foundation
import MapKit

public class MKPinLocation: NSObject, MKAnnotation {
    public let title: String?
    let locationName: String
    let phone: String
    public let coordinate: CLLocationCoordinate2D
    
    public init(title: String, locationName: String, phone: String, coordinate: CLLocationCoordinate2D) {
        self.title = title
        self.locationName = locationName
        self.phone = phone
        self.coordinate = coordinate
        
        super.init()
    }
    
    public var subtitle: String? {
        return locationName
    }
}