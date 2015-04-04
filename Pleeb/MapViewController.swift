// MapViewController.swift
// L I V V


import UIKit
import MapKit
import CoreLocation
import Alamofire
import Realm
import QuartzCore
//import AddressBook


enum CenterViewControllerSection: Int {
    case LeftViewState
    case LeftDrawerAnimation
    case RightViewState
    case RightDrawerAnimation
}

class MapViewController: ExampleViewController, MKMapViewDelegate, CLLocationManagerDelegate, UIGestureRecognizerDelegate   {
    var tableView: TagSelectorTableView!
    var mapView: MKMapView!
    var manager:CLLocationManager!
    var address: String!
    var coordinateQuadTree: TBCoordinateQuadTree!
    var button: UIButton!
    var connection: Bool! = true
    
    var accuracy: CLLocationAccuracy!
    var lastLocation: CLLocation!
    
    var intialLocationLoad = false
    
    //search bar
    
    var searchBar: SearchBarView!
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        
        self.restorationIdentifier = "MapViewControllerRestorationKey"
    }
    
    override init() {
        super.init()
        
        self.restorationIdentifier = "MapViewControllerRestorationKey"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        lastLocation = CLLocation(latitude: 45, longitude: -45)
        
        

        //var attributionLabel: UILabel = mapView.subviews.
        
        // INITILIZE LOCATION MANAGER
        
        manager = nil
        manager = CLLocationManager()
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.requestWhenInUseAuthorization()
        manager.startUpdatingLocation()
        
        
        // INITIALIZE MAPVIEW
        
        //mapView = MKMapView(frame: super.view.bounds)
        mapView = MKMapView(frame: CGRectMake(0,0, self.view.frame.width, self.view.frame.height))
        mapView.delegate = self
        //show user location on map
        mapView.showsUserLocation = true
        view.addSubview(self.mapView)
        mapView.autoresizingMask = .FlexibleWidth | .FlexibleHeight
        
        self.setupLeftMenuButton()
        self.setupRightMenuButton()
        
        //let barColor = UIColor(red: 240/255, green: 240/255, blue: 240/255, alpha: 1.0)
        let barColor = UIColor.clearColor()
        self.navigationController?.navigationBar.barTintColor = barColor
        self.navigationController?.navigationBar.backgroundColor = barColor
        self.navigationController?.navigationBar.translucent = true
        self.navigationController?.view.backgroundColor = barColor
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), forBarMetrics: UIBarMetrics.Default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        
        button =  UIButton.buttonWithType(UIButtonType.Custom) as UIButton
        button.frame = CGRectMake(0, 0, 100, 40) as CGRect
        button.backgroundColor = UIColor.clearColor()
        button.titleLabel?.font = UIFont(name: "HelveticaNeue-UltraLight", size: 30)
        button.setTitle("L I V V", forState: UIControlState.Normal)
        button.setTitleColor(UIColor(red: 26/255, green: 26/255, blue: 26/255, alpha: 1.0), forState: UIControlState.Normal)
        
        self.searchBar = SearchBarView(frame: CGRectMake(50, 5, self.view.frame.width - 100, 35))
        self.navigationController?.navigationBar.addSubview(self.searchBar)
        //button.hidden = true
        searchBar.hidden = true
        
        button.addTarget(self, action: Selector("clickOnButton:"), forControlEvents: UIControlEvents.TouchUpInside)
        self.navigationItem.titleView = button
        
    }
    
    func clickOnButton(sender: UIButton!)
    {
        if tableView != nil {

            button.enabled = false
            tableView.endEditing(true)
            //tableView.userInteractionEnabled = false
            tableView.closeWindow(tableView)
            setUpVotes()
        }else {
            currentLocation()
            setUpVotes()
        }
    }
    
    
    
    func setUpVotes(){
        
        var region: MKCoordinateRegion! = mapView.region
        var center: CLLocationCoordinate2D! = mapView.region.center
        var userCenter = mapView.userLocation.coordinate
        
        println("setupvotes called")
        
        
        
        //build the amount of area we want to call
        var lat = region.span.latitudeDelta
        var lon = region.span.longitudeDelta
        
        var location1 = (center.latitude - (lat/2))
        var location2 = (center.latitude + (lat/2))
        var location3 = (center.longitude - (lon/2))
        var location4 = (center.longitude + (lon/2))
        
        let users = User.allObjects()
        let user = users[UInt(0)] as User
        
        println("The user is: \(user.username)")
        println("The token is: \(user.token)")
        println("The phone is: \(user.phone)")
        println("The lastTag is: \(user.lastTag)")
        
        
        //set up string for alamo
        var newCoords = "?x1=\(location3)&x2=\(location4)&y1=\(location1)&y2=\(location2)"
        
        let URL: NSURL! = NSURL(string:"\(globalURL)/api/posts\(newCoords)")
        
        let mutableURLRequest = NSMutableURLRequest(URL: URL!)
        mutableURLRequest.HTTPMethod = "GET"
        mutableURLRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        mutableURLRequest.setValue("Bearer \(user.token)", forHTTPHeaderField: "Authorization")
        
        //var JSONSerializationError: NSError? = nil
        
        //call alamo
        Alamofire.request(mutableURLRequest).responseJSON { (req, res, json, error) in
            if(error != nil) {
                NSLog("Error: \(error)")
                println("Request: \(req)")
                println("Response: \(res)")
                println("JSON Data: \(json)")
                println("Error: \(error)")
                
                var alert: UIAlertView = UIAlertView(title: "Network Error", message: "You seem to have a bad connection.", delegate: self, cancelButtonTitle: "Close")
                
                
                let realm = RLMRealm.defaultRealm()
                realm.beginWriteTransaction()
                realm.deleteObjects(SizeofPoints.allObjects())
                let size = SizeofPoints()
                size.length = "0"
                realm.addObject(size)
                realm.commitWriteTransaction()
                
                alert.dismissWithClickedButtonIndex(0, animated: true)
                alert.show()
                
                self.connection = false
                
            }
            else {
                
                let priority = DISPATCH_QUEUE_PRIORITY_DEFAULT
                dispatch_async(dispatch_get_global_queue(priority, 0)) {
                    
                    self.connection = true
                    
                    println("The JSON Data: \(JSON(json!))")
                    NSLog("Success: \(globalURL)/api/posts\(newCoords)")
                    
                    var myJSON = JSON(json!)
                    
                    var x = 0
                    
                    
                    var count = myJSON.count
                    println("the count is: \(count)")
                    
                    let realm = RLMRealm.defaultRealm()
                    
                    //clear the db
                    realm.beginWriteTransaction()
                    realm.deleteObjects(Vote.allObjects())
                    realm.deleteObjects(Tag.allObjects())
                    realm.deleteObjects(Event.allObjects())
                    realm.deleteObjects(SizeofPoints.allObjects())
                    realm.commitWriteTransaction()
                    
                    var newVote = [Vote](count: count, repeatedValue: Vote())
                    
                    
                    realm.beginWriteTransaction()
                    
                    let size = SizeofPoints()
                    //count is minus 1 to account for default tag
                    size.length = "\(count - 1)"
                    realm.addObject(size)
                    
                    while x < count {
                        
                        let newVote = Vote()
                        
                        var lon: Double = myJSON[x]["loc"]["coordinates"][0].doubleValue
                        var lat: Double = myJSON[x]["loc"]["coordinates"][1].doubleValue
                        var address: String = myJSON[x]["address"].stringValue
                        
                        let newEvent = Event()
                        
                        for (key, value) in myJSON[x]["tags"] {
                            
                            var tag = Tag()
                            tag.name = key
                            tag.weight = value.intValue
                            tag.userSelectedTag = 0
                            
                            newEvent.tags.addObject(tag)
                            
                        }
                        var topTag: String = myJSON[x]["toptag"].stringValue
                        var weight: String = myJSON[x]["topweight"].stringValue
                        
                        newEvent.address = address
                        realm.addObject(newEvent)
                        
                        if (x != count - 1) {
                            newVote.bump = "\(lon)^.#/\(lat)^.#/\(address)^.#/\(topTag)/#.^\(weight)"
                            println("\(lon)^.#/\(lat)^.#/\(address)^.#/\(topTag)/#.^\(weight)")
                            realm.addObject(newVote)
                        }
                        
                        x++
                        
                    }
                    
                    realm.commitWriteTransaction()
                    
                    self.coordinateQuadTree  = TBCoordinateQuadTree()
                    self.coordinateQuadTree.mapView = self.mapView
                    self.coordinateQuadTree.buildTree()
                    
                    dispatch_async(dispatch_get_main_queue()) {
                        
                        var scale: Double = Double((self.mapView.bounds.size.width / CGFloat(self.mapView.visibleMapRect.size.width)))
                        let annotations: NSArray = self.coordinateQuadTree.clusteredAnnotationsWithinMapRect(self.mapView.visibleMapRect, withZoomScale: scale)
                        //self.requestUpdate()
                        self.updateMapViewAnnotationsWithAnnotations(annotations)
                        
                    }
                }
                
            }
            
            
            
        }
        
        
        
        
        
        
        
    }
    
    
    func getSelectedTags(){
        
        let users = User.allObjects()
        let user = users[UInt(0)] as User
        
        let URL: NSURL! = NSURL(string:"\(globalURL)/api/posts/tags")
        
        let mutableURLRequest = NSMutableURLRequest(URL: URL!)
        mutableURLRequest.HTTPMethod = "GET"
        mutableURLRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        mutableURLRequest.setValue("Bearer \(user.token)", forHTTPHeaderField: "Authorization")
        mutableURLRequest.setValue("\(self.address)", forHTTPHeaderField: "address")
        var JSONSerializationError: NSError? = nil
        
        //call alamo
        Alamofire.request(mutableURLRequest).responseJSON { (req, res, json, error) in
            if(error != nil) {
                NSLog("Error: \(error)")
                println("Request: \(req)")
                println("Response: \(res)")
                println("JSON Data: \(json)")
                println("Error: \(error)")
                
                
                self.tableView = TagSelectorTableView(mapClass: self)
                self.mapView.showsUserLocation = false
            }
            else {
                let priority = DISPATCH_QUEUE_PRIORITY_DEFAULT
                dispatch_async(dispatch_get_global_queue(priority, 0)) {
                    
                    NSLog("Error: \(error)")
                    println("Request: \(req)")
                    println("Response: \(res)")
                    println("JSON Data: \(json)")
                    println("Error: \(error)")
                    
                    println("selecting a tag")
                    
                    if json != nil {
                        var myJSON = JSON(json!)
                        if JSON(json!)["list"] != nil {
                            println(myJSON["list"])
                        }
                        var eventt: RLMResults = Event.objectsWhere("address = %@", self.address)
                        if ((Event.objectsWhere("address = %@", self.address).count != 0) &&  eventt[0] != nil ){
                            //var eventt: RLMResults = Event.objectsWhere("address = %@", self.address)
                            var event = eventt[0] as Event
                            
                            for (index: String, subJson: JSON) in JSON(json!)["list"] {
                                println("the key value is: \(subJson.stringValue)")
                                
                                for var i = 0; i < Int(event.tags.count); i++ {
                                    
                                    if event.tags[UInt(i)].name == subJson.stringValue{
                                        
                                        let realm = RLMRealm.defaultRealm()
                                        realm.beginWriteTransaction()
                                        var newTag = Tag()
                                        newTag = event.tags[UInt(i)] as Tag
                                        newTag.userSelectedTag = 1
                                        realm.commitWriteTransaction()
                                        
                                    }
                                    
                                }
                                
                                
                            }
                            
                        }
                        
                        
                    }
                    
                    dispatch_async(dispatch_get_main_queue()) {
                        
                        
                        
                        //self.tableView = TagSelectorTableView(mapClass: self)
                        self.view.addSubview(TagSelectorView(frame: CGRectMake(0, 72, self.view.frame.width, self.view.frame.height - 72)))
                        self.mapView.showsUserLocation = false
                        
                    }
                }
            }
        }
    }
    
    
    
    
    
    //POST
    
    func post(tag: String!)->Void {
        
        let users = User.allObjects()
        let user = users[UInt(0)] as User
        
        
        let parameters = [
            "loc": [
                "type": "Point",
                "coordinates": [
                    mapView.userLocation.coordinate.longitude,
                    mapView.userLocation.coordinate.latitude
                ]
            ],
            "accuracy": accuracy,
            "address": address,
            "tag": tag
        ]
        
        let URL = NSURL(string: "\(globalURL)/api/posts")!
        let mutableURLRequest = NSMutableURLRequest(URL: URL)
        mutableURLRequest.HTTPMethod = "POST"
        
        var JSONSerializationError: NSError? = nil
        mutableURLRequest.HTTPBody = NSJSONSerialization.dataWithJSONObject(parameters, options: nil, error: &JSONSerializationError)
        mutableURLRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        mutableURLRequest.setValue("Bearer \(user.token)", forHTTPHeaderField: "Authorization")
        
        print(parameters)
        
        Alamofire.request(mutableURLRequest).response {
            
            (request, response, data, error) -> Void in
            
            println("Requesttttt: \(request)")
            println("Responseeeee: \(response)")
            println("Dataaaa: \(data)")
            println("Erroreeee: \(error)")
            
            if error == nil {
                
                let realm = RLMRealm.defaultRealm()
                realm.beginWriteTransaction()
                user.lastTag = tag
                realm.commitWriteTransaction()
                
                println("the last tag was \(user.lastTag)")
                
                self.tableView.closeWindow(self.tableView)
                
                self.setUpVotes()
                
                
                
            }else {
                
                var alert: UIAlertView = UIAlertView(title: "Network Error", message: "You seem to have a bad connection.", delegate: self, cancelButtonTitle: "Close")
                self.tableView.closeWindow(self.tableView)
                alert.dismissWithClickedButtonIndex(0, animated: true)
                alert.show()
                
                
            }
            
        }
        
    }
    
    func mapView(mapView: MKMapView!, didUpdateUserLocation userLocation: MKUserLocation!) {
        
        if intialLocationLoad == false{
            
            currentLocation()
            
            //TODO: Make it so when you go so far it atomatically reloads
            intialLocationLoad = true
        }
        
        //if userLoca
        
    }
    
    
    
    //function that ask for currentLocation and loads the map at user location
    func currentLocation() -> Void {
        let spanX = 0.01
        let spanY = 0.01
        var newRegion = MKCoordinateRegion(center: mapView.userLocation.coordinate, span: MKCoordinateSpanMake(spanX, spanY))
        
        mapView.setRegion(newRegion, animated: false)
        //mapView.removeAnnotations(mapView.annotations)
        
        //printinln(manager.h)
        
        
        setUpVotes()
        
    }
    
    func mapView(mapView: MKMapView!, regionDidChangeAnimated animated: Bool) {
        
        if connection == true{
            println(mapView.region.span.latitudeDelta)
            println(mapView.region.span.longitudeDelta)
            if intialLocationLoad == true {
                if (mapView.region.span.latitudeDelta > 44.0 || mapView.region.span.longitudeDelta > 44.0){
                    
                } else {
                    
                    // isGreaterThanDeltaOfTwo = false
                    setUpVotes()
                    var scale: Double = Double((self.mapView.bounds.size.width / CGFloat(self.mapView.visibleMapRect.size.width)))
                    let annotations: NSArray = self.coordinateQuadTree.clusteredAnnotationsWithinMapRect(self.mapView.visibleMapRect, withZoomScale: scale)
                    self.updateMapViewAnnotationsWithAnnotations(annotations)
                    
                }
            }
        } else {
            
            setUpVotes()
        }
    }
    
    
    
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        println("Center will appear")
        
        setUpVotes()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        println("Center did appear")
        
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        println("Center will disappear")
        
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        println("Center did disappear")
    }
    
    func setupLeftMenuAgain() {
        
        
        
        var button: UIButton! = UIButton(frame: CGRectMake(0,0,69/2,30))
        button.setImage(UIImage(named: "future.png"), forState: .Normal)
        button.addTarget(self, action: "leftDrawerButtonPress:", forControlEvents: .TouchUpInside)
        
        var item = UIBarButtonItem(customView: button)
        
        //let leftDrawerButton = DrawerBarButtonItem(target: self, action: "leftDrawerButtonPress:")
        self.navigationItem.setLeftBarButtonItem(item, animated: true)
        
        
    }
    
    func setupLeftMenuButton() {
        

        
        var button: UIButton! = UIButton(frame: CGRectMake(0,0,20,20))
        button.setImage(UIImage(named: "left.png"), forState: .Normal)
        button.addTarget(self, action: "leftDrawerButtonPress:", forControlEvents: .TouchUpInside)
        
        var item = UIBarButtonItem(customView: button)
        
        
//        var button2: UIButton! = UIButton(frame: CGRectMake(30,0,20,20))
//        button2.setImage(UIImage(named: "searchIcon.png"), forState: .Normal)
//        //button2.addTarget(self, action: "leftDrawerButtonPress:", forControlEvents: .TouchUpInside)
//        var item2 = UIBarButtonItem(customView: button2)
        
        //let leftDrawerButton = DrawerBarButtonItem(target: self, action: "leftDrawerButtonPress:")
        self.navigationItem.setLeftBarButtonItem(item, animated: true)
        

    }
    
    
    func setupRightMenuAgain(){
        
        println("here at least")
        var button1: UIButton! = UIButton(frame: CGRectMake(0,0,30,30))
        button1.setImage(UIImage(named: "accept.png"), forState: .Normal)
        button1.addTarget(self, action: "leftDrawerButtonPress:", forControlEvents: .TouchUpInside)
        var item1 = UIBarButtonItem(customView: button1)
        var button2: UIButton! = UIButton(frame: CGRectMake(0,0,30,30))
        button2.setImage(UIImage(named: "deny.png"), forState: .Normal)
        button2.addTarget(self, action: "leftDrawerButtonPress:", forControlEvents: .TouchUpInside)
        var item2 = UIBarButtonItem(customView: button2)
        
        //let leftDrawerButton = DrawerBarButtonItem(target: self, action: "leftDrawerButtonPress:")
        //self.navigationItem.setLeftBarButtonItem(item, animated: true)
        self.navigationItem.setRightBarButtonItems([item1, item2], animated: true)
        
    }
    
    func setupRightMenuButton() {
        var button: UIButton! = UIButton(frame: CGRectMake(0,0,20,20))
        button.setImage(UIImage(named: "right.png"), forState: .Normal)
        button.addTarget(self, action: "rightDrawerButtonPress:", forControlEvents: .TouchUpInside)
        
        var item = UIBarButtonItem(customView: button)
        self.navigationItem.setRightBarButtonItem(item, animated: true)
    }
    
    
    func mapView(mapView: MKMapView!, viewForAnnotation annotation: MKAnnotation!) -> MKAnnotationView! {
        
        if annotation is MKUserLocation {
            //return nil so map view draws "blue dot" for standard user location
            
            let reuseId = "me"
            var pinView = mapView.dequeueReusableAnnotationViewWithIdentifier(reuseId)
            if pinView == nil {
                pinView = MKAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            }
            pinView!.draggable = false
            pinView!.canShowCallout = false
            pinView!.annotation = annotation
            pinView!.selected = false
            pinView!.image = UIImage(named: "location_button.png")
            pinView.layer.zPosition = 1
            return pinView
            
        }
        var annotation_count: TBClusterAnnotation! = annotation as TBClusterAnnotation
        
        let TBAnnotationViewReuseID:String! = "\(annotation_count.title)\(annotation_count.coordinate.latitude)\(annotation_count.coordinate.longitude)\(annotation_count.count)\(annotation_count.weight)"
        println("The annoation resuse id is \(TBAnnotationViewReuseID)")
        
        //iffy here
        var annotationView:TBClusterAnnotationView! = mapView.dequeueReusableAnnotationViewWithIdentifier(TBAnnotationViewReuseID) as TBClusterAnnotationView!
        
        
        
        if ((annotationView) == nil) {
            
            annotationView = TBClusterAnnotationView(annotation: annotation, reuseIdentifier: TBAnnotationViewReuseID)
        }
        
        annotationView.canShowCallout = true
        
        annotationView.count = UInt(annotation_count.count)
        annotationView.weight = UInt(annotation_count.weight)
        
        if (annotation_count.count == 1) {
            annotationView.isParty = true
        } else {
            annotationView.isParty = false
        }
        
        
        return annotationView
        
    }
    
    
    func updateMapViewAnnotationsWithAnnotations(annotations: NSArray) {
        
        let priority = DISPATCH_QUEUE_PRIORITY_DEFAULT
        dispatch_async(dispatch_get_global_queue(priority, 0)) {
            
            var before: NSMutableSet! = NSMutableSet(array: self.mapView.annotations)
            before.removeObject(self.mapView.userLocation)
            var after: NSSet! = NSSet(array: annotations)
            
            var toKeep: NSMutableSet! = NSMutableSet(set: before)
            toKeep.intersectSet(after)
            
            var toAdd: NSMutableSet! = NSMutableSet(set: after)
            toAdd.minusSet(toKeep)
            
            var toRemove: NSMutableSet! = NSMutableSet(set: before)
            toRemove.minusSet(after)
            
            dispatch_async(dispatch_get_main_queue()) {
                
                self.mapView.addAnnotations(toAdd.allObjects)
                self.mapView.removeAnnotations(toRemove.allObjects)
            }
            
        }
        
    }
    
    func locationManager(manager: CLLocationManager!, didUpdateToLocation newLocation: CLLocation!, fromLocation oldLocation: CLLocation!) {
        println("The location from the last coordinate was: \(newLocation.distanceFromLocation(oldLocation))")
        
    }
    
    
    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
        
        if lastLocation.distanceFromLocation(locations[0] as CLLocation) > 50 {
            
            println("we made it!")
            
        }
        
        var userLocation:CLLocation! = locations[0] as CLLocation
        
        CLGeocoder().reverseGeocodeLocation(userLocation, completionHandler: { (placemarks, error) -> Void in
            
            if (error != nil) {
                
                println(error)
                
            } else {
                
                if let p = CLPlacemark(placemark: placemarks?[0] as CLPlacemark) {
                    
                    var subThoroughfare:String = ""
                    
                    if (p.subThoroughfare != nil) {
                        
                        subThoroughfare = p.subThoroughfare
                        
                    }
                    self.accuracy = locations[0].horizontalAccuracy
                    self.address = "\(subThoroughfare) \(p.thoroughfare)^.#/\(p.subLocality)^.#/\(p.subAdministrativeArea)^.#/\(p.postalCode)^.#/\(p.country)"
                    
                }
                
                
            }
            
        })
        
        lastLocation = locations[0] as CLLocation
        
    }
    
    func mapView(mapView: MKMapView!, didSelectAnnotationView view: MKAnnotationView!) {
        
        if (view.reuseIdentifier == "me"){
            
            self.getSelectedTags()
            
        }
        
        println(view.reuseIdentifier)
        
    }
    
    // MARK: - Bounce Animations
    
    func addBounceAnimatonToView(view: UIView) {
        
        var bounceAnimation: CAKeyframeAnimation = CAKeyframeAnimation(keyPath: "transform.scale")
        
        bounceAnimation.values = [0.05, 1.1, 0.9, 1]
        
        bounceAnimation.duration = 0.6
        
        var timingFunctions: NSMutableArray = NSMutableArray(capacity: bounceAnimation.values.count)
        
        for var i = 0; i < 3; i++ {
            timingFunctions.addObject(CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut))
        }
        
        //bounceAnimation.timingFunctions(timingFunctions.copy())
        bounceAnimation.timingFunctions = timingFunctions
        
        bounceAnimation.removedOnCompletion = false
        
        view.layer.addAnimation(bounceAnimation, forKey: "bounce")
        
    }
    
    func mapView(mapView: MKMapView!, didAddAnnotationViews views: [AnyObject]!) {
        var vieww: MKAnnotation!
        for vieww in views {
            
            if (vieww.annotation) is MKUserLocation {
                
                view.superview?.bringSubviewToFront(vieww as UIView)
                self.addBounceAnimatonToView(vieww as UIView)
            } else {
                view.superview?.sendSubviewToBack(vieww as UIView)
                self.addBounceAnimatonToView(vieww as UIView)
                
            }
            
            
        }
        
        
    }
    
    //ADDRESS BOOK ACCESS FOR FRIENDS
    
    
    
    
    // MARK: - Button Handlers
    
    func leftDrawerButtonPress(sender: AnyObject?) {
        self.evo_drawerController?.toggleDrawerSide(.Left, animated: true, completion: nil)
    }
    
    func rightDrawerButtonPress(sender: AnyObject?) {
        self.evo_drawerController?.toggleDrawerSide(.Right, animated: true, completion: nil)
    }
    
    //HELPS WITH MEMORY OF THE MAP
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        mapView.mapType = MKMapType.Standard
//        mapView.removeFromSuperview()
//        mapView = nil
    }
    
}
