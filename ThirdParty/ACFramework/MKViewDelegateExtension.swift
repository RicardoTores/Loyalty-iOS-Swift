//
//  MKViewDelegateExtension.swift
//  
//
//  Created by Alex on 04/10/15.
//
//

import UIKit
import MapKit

extension UIViewController/*: MKMapViewDelegate*/ {

    /**
        Extensión to show our own annotations of type MKPinLocation
    
        Only our MKPinLocation will be rendered specially by this function. In case of a simple MKPointAnnotation the normal render will be used.
    
        Just add this line of code to your ViewController where your MapKit is placed:
    
        yourMapViewObject.delegate = self
    
        (In your view viewDidLoad() function)
    */
    public func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        if let annotation = annotation as? MKPinLocation {
            let identifier = "pin"
            var view: MKPinAnnotationView
            if let dequeuedView = mapView.dequeueReusableAnnotationViewWithIdentifier(identifier) as? MKPinAnnotationView {
                dequeuedView.annotation = annotation
                view = dequeuedView
            } else {
                // 3
                view = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
                view.canShowCallout = true
                view.calloutOffset = CGPoint(x: -5, y: 5)
                view.rightCalloutAccessoryView = UIButton(type: .DetailDisclosure) as UIView
            }
            return view
        }
        return nil
    }
}