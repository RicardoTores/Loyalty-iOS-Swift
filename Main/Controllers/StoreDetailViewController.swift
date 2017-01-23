//
//  StoreDetailViewController.swift
//  Loyalty
//
//  Created by great summit an on 4/21/16.
//  Copyright © 2016 Colectivo Coffee Roasters Inc. All rights reserved.
//

import UIKit
import MapKit
import GoogleMaps
import PXGoogleDirections

class StoreDetailViewController: UIViewController,CLLocationManagerDelegate, MKMapViewDelegate {

    @IBOutlet weak var storeMap: MKMapView!
    @IBOutlet weak var img_storephoto: UIImageView!
    
    @IBOutlet weak var lbl_sincemark: UILabel!
    @IBOutlet weak var lbl_storename: UILabel!
    @IBOutlet weak var lbl_addr: UILabel!
    @IBOutlet weak var lbl_phone: UILabel!
    @IBOutlet weak var lbl_tt1lb: UILabel!
    @IBOutlet weak var lbl_tt2lb: UILabel!
    @IBOutlet weak var lbl_tt1: UILabel!
    @IBOutlet weak var lbl_tt2: UILabel!
    @IBOutlet weak var lbl_tt3lb: UILabel!
    @IBOutlet weak var lbl_tt3: UILabel!
    @IBOutlet weak var lbl_tt4lb: UILabel!
    @IBOutlet weak var lbl_tt4: UILabel!
    
    
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var btnDirection: UIButton!
    @IBOutlet weak var btnCall: UIButton!
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var storeImageHeight: NSLayoutConstraint!
    
    var currentStore: StoreEntity!
    var geocoder: CLGeocoder!
    let regionRadius: CLLocationDistance = 1000
    var locationManager = CLLocationManager()
    
    @IBOutlet weak var gMapView: GMSMapView!
    var myLocation: CLLocationCoordinate2D!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initialize()
        self.cafesDetailUIDataSet(currentStore);
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    func cafesDetailUIDataSet(storeInfo:StoreEntity?){
        if let store = storeInfo{
        
            let initialLocation = CLLocation(latitude: store.lat!.doubleValue, longitude: store.lng!.doubleValue)
            centerMapOnLocation(initialLocation);            
            drawStoreInMap(store)
            
            self.currentStore = store
            
            // set color of some component for store color
            self.headerView.backgroundColor = UIColor(hexString: store.clr! as String)
            self.bottomView.backgroundColor = UIColor(hexString: store.clr! as String)

            self.btnDirection.backgroundColor = UIColor(hexString: store.clr! as String)
            self.btnCall.backgroundColor = UIColor(hexString: store.clr! as String)
            self.lbl_storename.textColor = UIColor(hexString: store.clr! as String)
            
            self.lbl_storename.text = store.name as? String
            self.lbl_addr.text = (store.addr as? String)! + ", " + (store.city as? String)!
            self.lbl_phone.text = store.phn as? String
            self.lbl_tt1.text = store.tt1 as? String
            self.lbl_tt1lb.text = store.tt1lb as? String
            self.lbl_tt2.text = store.tt2 as? String
            self.lbl_tt2lb.text = store.tt2lb as? String
            self.lbl_tt3.text = store.tt3 as? String
            self.lbl_tt3lb.text = store.tt3lb as? String

            self.lbl_tt4.text = store.tt4 as? String
            self.lbl_tt4lb.text = store.tt4lb as? String

            
            let defaultpath = String(format: NSLocalizedString(Settings.STORE_IMAGE_TEMPLATE_URL, comment: ""), store.store_id!)
            let url = NSURL(string: defaultpath)
            
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
                let data = NSData(contentsOfURL: url!) //make sure your image in this url does exist, otherwise unwrap in a if let check
                dispatch_async(dispatch_get_main_queue(), {
                    if(data != nil){
                        let image:UIImage = UIImage(data: data!)!
                        let width = image.size.width
                        let height = image.size.height
                        self.storeImageHeight.constant = self.img_storephoto.frame.width * (height / width)
                        self.img_storephoto.image = image;
                    }
                    
                });
            }
        }
    }
    
    func initialize (){
        
        // MAP
        //storeMap.delegate = self // Use our own extension defined in ACFramework.MK*
        //storeMap.showsUserLocation = true
        //storeMap.zoomEnabled = true
        //storeMap.scrollEnabled = true
//        if #available(iOS 9.0, *) {
//            //storeMap.showsCompass = true
//        }
        if (CLLocationManager.locationServicesEnabled())
        {
            locationManager = CLLocationManager()
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.requestWhenInUseAuthorization()
            locationManager.startUpdatingLocation()
            
            if let locValue:CLLocation = locationManager.location {
                let initialLocation = CLLocation(latitude: locValue.coordinate.latitude, longitude: locValue.coordinate.longitude)
                centerMapOnLocation(initialLocation);
                self.myLocation = CLLocationCoordinate2DMake(locValue.coordinate.latitude, locValue.coordinate.longitude)
            } else {
                NSLog("Unable to retrieve current user GPS position")
            }
        } else {
            NSLog("USER DO NOT CONSENTS to retrieve current user GPS position")
        }
        
        
    }
    
    //Location Manager Delegate
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        myLocation = manager.location?.coordinate
        print("myLocation = \(myLocation.latitude) \(myLocation.longitude)")
    }
    
    func checkLocationAuthorizationStatus() {
        if CLLocationManager.authorizationStatus() == .AuthorizedWhenInUse {
            //storeMap.showsUserLocation = true
        } else {
            locationManager.requestWhenInUseAuthorization()
        }
    }
  
    
    func centerMapOnLocation(location: CLLocation) {
        //let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate, regionRadius * 2.0, regionRadius * 2.0)
        //storeMap.setRegion(coordinateRegion, animated: true)
        let camera = GMSCameraPosition.cameraWithLatitude(location.coordinate.latitude, longitude: location.coordinate.longitude, zoom: Settings.GOOGLE_MAP_DEAULT_ZOOM_LEVEL)
        gMapView.camera = camera
        gMapView.myLocationEnabled = true

    }
    
    
    func calculateDistanceFromHere(store:StoreEntity) -> CLLocationDistance{
        var dis : CLLocationDistance = 0
        if let locValue:CLLocation = locationManager.location {
            let currentLocation = CLLocation(latitude: locValue.coordinate.latitude, longitude: locValue.coordinate.longitude)
            let storeLoc = CLLocation(latitude: store.lat!.doubleValue, longitude: store.lng!.doubleValue)
            dis = currentLocation.distanceFromLocation(storeLoc)
        }
        return dis
    }
    
    private func drawStoreInMap(store: StoreEntity) {
        
                let s : StoreEntity = store 
                let location = CLLocationCoordinate2D(latitude : s.lat!.doubleValue,
                                                      longitude : s.lng!.doubleValue)
                //let annotation = MKPinLocation( title: s.name! as String, locationName: s.addr! as String, phone: s.phn! as String, coordinate: location)
                //storeMap.addAnnotation(annotation)
                let marker = GMSMarker(position:location);
                marker.title = s.name! as String
                marker.snippet = s.addr! as String
                marker.map = gMapView
    }

    func getDirections(store: StoreEntity) {
        
        let s : StoreEntity = store;
        let destination = CLLocationCoordinate2D(latitude : s.lat!.doubleValue,
                                              longitude : s.lng!.doubleValue)
        let request = MKDirectionsRequest()
        request.source = MKMapItem.mapItemForCurrentLocation()
       // request.source = MKMapItem(placemark: MKPlacemark(coordinate: CLLocationCoordinate2D(latitude:43.224505999999998, longitude:-87.984363999999999), addressDictionary: nil))
        request.destination = MKMapItem(placemark: MKPlacemark(coordinate: destination, addressDictionary: nil))
        
        //request.source = MKMapItem(placemark: MKPlacemark(coordinate: CLLocationCoordinate2D(latitude: 43.059127, longitude: -87.885158), addressDictionary: nil))
        //request.destination = MKMapItem(placemark: MKPlacemark(coordinate: CLLocationCoordinate2D(latitude: 40.748441, longitude: -73.985564), addressDictionary: nil))
        
        request.requestsAlternateRoutes = true
        request.transportType = .Automobile
//         self.geocoder = CLGeocoder ()
        //let destLocation = CLLocation(latitude: currentStore.lat!.doubleValue, longitude: currentStore.lng!.doubleValue)
        //self.geocoder.reverseGeocodeLocation(destLocation, completionHandler: {
        //    placemarks, error in
        //    if error == nil && placemarks!.count > 0 {
                
        //    }
        //})
        
        let directions = MKDirections(request: request)
        
        directions.calculateDirectionsWithCompletionHandler ({
            (response: MKDirectionsResponse?, error: NSError?) in
            
            if error != nil {
                // Handle error
            } else {
                self.showRoute(response!)
            }
            
        })
    }
    
    func getDirectionFromPXGoogle(store: StoreEntity) {
        let s : StoreEntity = store;
        
        if (myLocation == nil) {
            return
        }
        
        let directionsAPI = PXGoogleDirections(apiKey: Settings.GOOGLE_API_KEY,
                                              from: PXLocation.CoordinateLocation(self.myLocation),
                                              to: PXLocation.CoordinateLocation(CLLocationCoordinate2DMake(s.lat!.doubleValue, s.lng!.doubleValue)))
        Util.sharedInstant().showHub(true)
        directionsAPI.calculateDirections({ response in
            Util.sharedInstant().showHub(false)
            switch response {
            case let .Error(_, error):
                // Oops, something bad happened, see the error object for more information
                NSLog("%@", error.description)
//                let alert = UIAlertView.init(title: nil, message: "Unable to calculate your route!", delegate: nil, cancelButtonTitle: "OK")
//                alert.show()
                Util.sharedInstant().showMessage(self, messageWith: "Unable to calculate your route!")
                break
            case let .Success(request, routes):
                // Do your work with the routes object array here
                NSLog("%@", request.description)
                //let path = GMSMutablePath()
                self.centerMapOnLocation(CLLocation(latitude: self.myLocation.latitude, longitude: self.myLocation.longitude))
                for route in routes {
                    let polyline = GMSPolyline(path: route.path)
                    polyline.map = self.gMapView
                    polyline.strokeWidth = 5.0

                }
                break
            }
        })
        
    }
    
    
    func mapView(mapView: MKMapView, rendererForOverlay overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(polyline: overlay as! MKPolyline)
        renderer.strokeColor = UIColor.blueColor()
        renderer.lineWidth = 5.0
        return renderer
    }
    
    func showRoute(response: MKDirectionsResponse) {
        
        for route in response.routes {
            
            self.storeMap.addOverlay(route.polyline,
                                level: MKOverlayLevel.AboveRoads)
        }
    }

    
    
    @IBAction func gotoBack(sender: AnyObject) {
        //NSNotificationCenter.defaultCenter().postNotificationName("cafesUI", object: nil)
        self.navigationController?.popViewControllerAnimated(true);
    }

    @IBAction func onClickCall(sender: AnyObject) {
        var phone = String(format: NSLocalizedString("tel://%@", comment: ""), self.lbl_phone.text!)
        phone = phone.stringByReplacingOccurrencesOfString("(", withString: "", options: NSStringCompareOptions.LiteralSearch, range: nil)
        phone = phone.stringByReplacingOccurrencesOfString(")", withString: "", options: NSStringCompareOptions.LiteralSearch, range: nil)
        phone = phone.stringByReplacingOccurrencesOfString("-", withString: "", options: NSStringCompareOptions.LiteralSearch, range: nil)
        phone = phone.stringByReplacingOccurrencesOfString(" ", withString: "", options: NSStringCompareOptions.LiteralSearch, range: nil)
        let url:NSURL = NSURL(string:phone)!;
        UIApplication.sharedApplication().openURL(url);
    }
    @IBAction func onClickFoodMenu(sender: AnyObject) {
        let vc = self.storyboard?.instantiateViewControllerWithIdentifier("MenuDetailsViewController") as! MenuDetailsViewController
        vc.modalPresentationStyle = .OverFullScreen
        vc.modalTransitionStyle = .CrossDissolve
        if (currentStore.name!.isEqualToString("Third Ward")) {
            vc.menuImageName = "Menus_Food_ThirdWard"
        }
        else if (currentStore.name!.isEqualToString("Monroe St")) {
            vc.menuImageName = "Menus_Food_Monroe"
        }
        else if (currentStore.name!.isEqualToString("State St")) {
            vc.menuImageName = "Menus_Food_State"
        }
        else if (currentStore.name!.isEqualToString("US Bank")) {
            vc.menuImageName = "Menus_Food_USBank"
        }
        else {
            vc.menuImageName = "Menus_Food_General"
        }
        presentViewController(vc, animated: true, completion:nil)
    }
    
    @IBAction func onClickDrinkMenu(sender: AnyObject) {
        let vc = self.storyboard?.instantiateViewControllerWithIdentifier("MenuDetailsViewController") as! MenuDetailsViewController
        vc.modalPresentationStyle = .OverFullScreen
        vc.modalTransitionStyle = .CrossDissolve
        vc.menuImageName = "Menus_Drink"
        presentViewController(vc, animated: true, completion:nil)

    }
    
    
    @IBAction func onClickCateringMenu(sender: AnyObject) {
        let vc = self.storyboard?.instantiateViewControllerWithIdentifier("MenuDetailsViewController") as! MenuDetailsViewController
        vc.modalPresentationStyle = .OverFullScreen
        vc.modalTransitionStyle = .CrossDissolve
        vc.menuImageName = "Menus_Catering";
        presentViewController(vc, animated: true, completion:nil)

    }
    
    @IBAction func onClickDirections(sender: AnyObject) {
        if (UIApplication.sharedApplication().canOpenURL(NSURL(string:"com.google.maps://")!)) {
            UIApplication.sharedApplication().openURL(NSURL(string:"com.google.maps://?saddr=\(myLocation.latitude),\(myLocation.longitude)&daddr=\(currentStore.lat as! String),\(currentStore.lng as! String)&directionsmode=driving")!)
            //UIApplication.sharedApplication().openURL(NSURL(string:"comgooglemaps://?center\(currentStore.lat!.doubleValue),\(currentStore.lng!.doubleValue)&zoom=\(Settings.GOOGLE_MAP_DEAULT_ZOOM_LEVEL)&views=traffic")!)
            
            
        } else {
            let url = "https://maps.google.com/maps?saddr=\(myLocation.latitude),\(myLocation.longitude)&daddr=\(currentStore.lat as! String),\(currentStore.lng as! String)"
            
            print("url = \(url)")
            UIApplication.sharedApplication().openURL(NSURL(string: url)!)
            NSLog("Can't use comgooglemaps://");
        }
    
       //self.getDirectionFromPXGoogle(currentStore)
    }
    
}
