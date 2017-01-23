//
//  StoreListController.swift
//  Loyalty
//
//  Created by Alex on 02/10/15.
//  Copyright © 2015 Colectivo Coffee Roasters Inc. All rights reserved.
//

import UIKit
import GoogleMaps
import MapKit
//import ACFramework

class StoreListController: UIViewController, UITableViewDelegate, UITableViewDataSource, CLLocationManagerDelegate, MKMapViewDelegate, UIPickerViewDelegate, UIPickerViewDataSource{
    
    @IBOutlet var tblStores: UITableView!
    @IBOutlet var mapStores: MKMapView!
    @IBOutlet weak var btnSortBy: UIButton!
    @IBOutlet weak var btnCity: UIButton!    
    @IBOutlet weak var cityNamePicker: UIPickerView!
    var pickerDataSource = ["ALL"]
    var dataList: NSMutableArray!
    var sortByNearest:Bool = true
    
    let CELL_ID = "storeCell"
    let regionRadius: CLLocationDistance = 1000
    var locationManager = CLLocationManager()
    
    @IBOutlet weak var gMapView: GMSMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initialize()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)

    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated);
        setupUI()
        
    }
    
    // MARK: DELEGATE
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
         self.cityNamePicker.hidden = true;
        self.btnCity.selected = false;
        
        let store : StoreEntity = self.dataList!.objectAtIndex(indexPath.row) as! StoreEntity
        let initialLocation = CLLocation(latitude: store.lat!.doubleValue, longitude: store.lng!.doubleValue)
        centerMapOnLocation(initialLocation);
      
        let vc = self.storyboard?.instantiateViewControllerWithIdentifier("StoreDetailViewController") as! StoreDetailViewController
        vc.currentStore = store
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    // MARK: DATASOURCE
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.dataList != nil
        {
            return self.dataList!.count
        }
        return 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let row: Int = indexPath.row
        let store : StoreEntity = self.dataList!.objectAtIndex(row) as! StoreEntity
        
        let cell = tableView.dequeueReusableCellWithIdentifier(CELL_ID) as! StoreTableViewCell
        
        cell.name.text = store.name! as String
        cell.name.textColor = UIColor(hexString: store.clr! as String)
        cell.address.text = store.addr! as String + ", " + (store.city! as String) as String
        
       // NSLog("Bck color \(store.city)")
        //cell.backgroundColor = UIColor(hexString: store.clr! as String)
        
        return cell
    }
    
    
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        //cell.layer.transform = CATransform3DMakeScale(0.1,0.1,1)
       // UIView.animateWithDuration(0.25, animations: {
        //    cell.layer.transform = CATransform3DMakeScale(1,1,1)
       // })
    }
    
    
    
    // MARK: MAPKIT
    func checkLocationAuthorizationStatus() {
        if CLLocationManager.authorizationStatus() == .AuthorizedWhenInUse {
            mapStores.showsUserLocation = true
        } else {
            locationManager.requestWhenInUseAuthorization()
        }
    }

    /* Updates current user position over the map
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations.last
        
        NSLog("Location updated")
        
        let center = CLLocationCoordinate2D(latitude: location!.coordinate.latitude, longitude: location!.coordinate.longitude)
        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
        
        mapStores.setRegion(region, animated: true)
    }
    */
    
    func centerMapOnLocation(location: CLLocation) {
        //let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate, regionRadius * 2.0, regionRadius * 2.0)
        //mapStores.setRegion(coordinateRegion, animated: true)
        
        let camera = GMSCameraPosition.cameraWithLatitude(location.coordinate.latitude, longitude: location.coordinate.longitude, zoom: Settings.GOOGLE_MAP_DEAULT_ZOOM_LEVEL)
        gMapView.camera = camera
        gMapView.myLocationEnabled = true
    }
    
    private func drawStoresInMap() {
        if WEBSERVICE.storelist != nil{
            for i in 0  ..< WEBSERVICE.storelist!.count  {
                let s : StoreEntity = WEBSERVICE.storelist!.objectAtIndex(i) as! StoreEntity
                let location = CLLocationCoordinate2D(latitude : s.lat!.doubleValue,
                                                        longitude : s.lng!.doubleValue)
                //let annotation = MKPinLocation( title: s.name! as String, locationName: s.addr! as String, phone: s.phn! as String, coordinate: location)
                let marker = GMSMarker(position:location);
                marker.title = s.name! as String
                marker.snippet = s.addr! as String
                marker.map = gMapView
                //mapStores.addAnnotation(annotation)
            }
        }
    }
    
    func initialize (){
        self.cityNamePicker.hidden = true
        self.cityNamePicker.delegate = self
        self.cityNamePicker.dataSource = self
        btnCity.selected = false
        btnCity.hidden = true
       
        self.dataList = NSMutableArray()
        
       
        
        // get store list from server
            Util.sharedInstant().showHub(true)
            WEBSERVICE.getStoreListFromServer({
                dispatch_async(dispatch_get_main_queue()) {
                    Util.sharedInstant().showHub(false)
                    self.dataList = WEBSERVICE.storelist
                    self.tblStores.reloadData()
                    self.drawStoresInMap()
                    self.getCitylist()
                    self.sortBy(true)
                }
                }, fail: {
                    dispatch_async(dispatch_get_main_queue()) {
                        Util.sharedInstant().showHub(false)
//                        let alert = UIAlertView.init(title: nil, message: "Server connection error!", delegate: nil, cancelButtonTitle: "OK")
//                        alert.show()
                        Util.sharedInstant().showMessage(self, messageWith: "Server connection error!")
                    }
            })
            
        // MAP
        //mapStores.delegate = self // Use our own extension defined in ACFramework.MK*
        //mapStores.showsUserLocation = true
//        if #available(iOS 9.0, *) {
//            //mapStores.showsCompass = true
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
            } else {
                NSLog("Unable to retrieve current user GPS position")
            }
        } else {
            NSLog("USER DO NOT CONSENTS to retrieve current user GPS position")
        }

    }
    
    @IBAction func onSortBy(sender: AnyObject) {
        self.cityNamePicker.hidden = true;
        btnCity.selected = false
        
        sortByNearest = !sortByNearest
        self.sortBy(sortByNearest)
        tblStores.reloadData()
        setupUI()
    }
    
    func sortBy (isNearest : Bool){
        if isNearest {
            let newlist = NSMutableArray()
            while self.dataList!.count > 0 {
                var item = self.dataList!.objectAtIndex(0) as! StoreEntity
                var dis = calculateDistanceFromHere(item)
                for i in 1  ..< self.dataList!.count  {
                    let item1 = self.dataList!.objectAtIndex(i) as! StoreEntity
                    let dis1 = calculateDistanceFromHere(item1)
                    if dis1 < dis{
                        dis = dis1
                        item = item1
                    }
                }
                newlist.addObject(item)
                self.dataList!.removeObject(item)
                if self.dataList!.count == 0 {
                   self.dataList!.setArray(newlist as [AnyObject])
                   break
                }
            }

        }else{
            let sortDescriptor : NSSortDescriptor = NSSortDescriptor(key: "name", ascending: true)
            let sortDescriptors : NSArray = NSArray(objects: sortDescriptor)
            let sortedArray :[AnyObject] = (self.dataList?.sortedArrayUsingDescriptors(sortDescriptors as! [NSSortDescriptor]))! as [AnyObject]
            self.dataList?.setArray(sortedArray as [AnyObject])
            
        }
    }
    
    
    @IBAction func SortByCity(sender: AnyObject) {
        if(btnCity.selected == true)
        {
            self.cityNamePicker.hidden = true
            btnCity.selected = false
        }
        else
        {
            self.cityNamePicker.hidden = false
            btnCity.selected = true
        }
    }
    
    func getCitylist(){
        if WEBSERVICE.storelist != nil{
            for i in 0  ..< WEBSERVICE.storelist!.count  {
                let s : StoreEntity = WEBSERVICE.storelist!.objectAtIndex(i) as! StoreEntity
                let item : NSString = s.city!
                var flag : Bool = false
                for j in 0  ..< pickerDataSource.count  {
                    if item.isEqualToString(pickerDataSource[j] as String){
                        flag = true;
                    }
                }
                if(!flag){
                    pickerDataSource.append(item as String)
                }
            }
            
        }
        cityNamePicker.reloadAllComponents()
    }
    
    func sortByCityName( city : NSString){
        if WEBSERVICE.storelist != nil{
            self.dataList = NSMutableArray()
            for i in 0  ..< WEBSERVICE.storelist!.count  {
                let s : StoreEntity = WEBSERVICE.storelist!.objectAtIndex(i) as! StoreEntity
                let item : NSString = s.city!
                
                if item.isEqualToString(city as String)
                {
                    self.dataList!.addObject(s)
                }else if city.isEqualToString("ALL")
                {
                    self.dataList!.addObject(s)
                }
            }
            
            self.tblStores.reloadData()
        }
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
    
    func setupUI(){
        if sortByNearest {
            btnSortBy.setTitle("NEAREAST", forState: UIControlState.Normal)
        }else{
            btnSortBy.setTitle("NAME", forState: UIControlState.Normal)
        }
    }
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerDataSource.count;
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerDataSource[row]
    }
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int)
    {
       btnCity.setTitle(pickerDataSource[row], forState: UIControlState.Normal)
        self.sortByCityName(pickerDataSource[row])
    }
    
    func pickerView(pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        let attributedString = NSAttributedString(string: pickerDataSource[row], attributes: [NSForegroundColorAttributeName : UIColor.whiteColor()])
        return attributedString
    }
}
