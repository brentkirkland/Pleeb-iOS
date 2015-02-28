// Copyright (c) 2014 evolved.io (http://evolved.io)
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

import UIKit
import MapKit
import CoreLocation
import Alamofire
import Realm
import QuartzCore

enum CenterViewControllerSection: Int {
    case LeftViewState
    case LeftDrawerAnimation
    case RightViewState
    case RightDrawerAnimation
}

class ExampleCenterTableViewController: ExampleViewController, UITableViewDataSource, UITableViewDelegate, MKMapViewDelegate, CLLocationManagerDelegate, UIGestureRecognizerDelegate   {
    var tableView: UITableView!
    var mapView: MKMapView!
    var manager:CLLocationManager!
    var myAnnotationView: MKAnnotationView!
    var restore: MKAnnotationView!
    var x: Int = 0
    var timer: NSTimer!
    var coordinateQuadTree: TBCoordinateQuadTree!
    
    //the following variables help make the map load on the location more easily
    var intialLocationLoad = false
    var coordinatesDidAlign = false
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        
        self.restorationIdentifier = "ExampleCenterControllerRestorationKey"
    }
    
    override init() {
        super.init()
        
        self.restorationIdentifier = "ExampleCenterControllerRestorationKey"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // INITILIZE LOCATION MANAGER
        
        updateMe()
        
        
        // INITIALIZE MAPVIEW
        
        mapView = MKMapView(frame: super.view.bounds)
        mapView.delegate = self
        //show user location on map
        mapView.showsUserLocation = true
        view.addSubview(self.mapView)
        mapView.autoresizingMask = .FlexibleWidth | .FlexibleHeight
        
        //add some gesture recognizers
        
        
        var singletap: UITapGestureRecognizer  = UITapGestureRecognizer(target: self, action: "singleTap")
        singletap.numberOfTapsRequired = 1
        mapView.addGestureRecognizer(singletap)
        
        
        //REQUEST POINTS
        //TODO REQUEST REALM AND CHECK WITH UPDATES
        
        
        let doubleTap = UITapGestureRecognizer(target: self, action: "doubleTap:")
        doubleTap.numberOfTapsRequired = 2
        self.view.addGestureRecognizer(doubleTap)
        
        
        self.setupLeftMenuButton()
        self.setupRightMenuButton()
        
        let barColor = UIColor(red: 247/255, green: 249/255, blue: 250/255, alpha: 1.0)
        self.navigationController?.navigationBar.barTintColor = barColor
        
        self.navigationController?.view.layer.cornerRadius = 10.0
        
        let backView = UIView()
        backView.backgroundColor = UIColor(red: 208/255, green: 208/255, blue: 208/255, alpha: 1.0)
        //self.tableView.backgroundView = backView
        
        
    }
    
    func singleTap(){
        
        if (mapView.showsUserLocation){
            mapView.showsUserLocation = false
        }else{
            mapView.showsUserLocation = true
            
        }
        
        
    }
    
    func doubleTap(){
        
        currentLocation()
        
        
    }
    
    func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldReceiveTouch touch: UITouch) -> Bool {
        if touch.view.isKindOfClass(MKAnnotationView) {
            return false
        }
        return true
    }
    
    func setUpVotes(){
        
        var region: MKCoordinateRegion! = mapView.region
        var center: CLLocationCoordinate2D! = mapView.region.center
        var userCenter = mapView.userLocation.coordinate
        
        
        //ensures we aren't asking for coordinates when the map is too zoomed out
        if Int(region.center.latitude) == Int(userCenter.latitude) && Int(region.center.longitude) == Int(userCenter.longitude){
            
            //build the amount of area we want to call
            var lat = region.span.latitudeDelta
            var lon = region.span.longitudeDelta
            
            var location1 = (center.latitude - (lat*2.5))
            var location2 = (center.latitude + (lat*2.5))
            var location3 = (center.longitude - (lon*2.5))
            var location4 = (center.longitude + (lon*2.5))
            
            //set up string for alamo
            var newCoords = "?x1=\(location3)&x2=\(location4)&y1=\(location1)&y2=\(location2)"
            
            //call alamo
            Alamofire.request(.GET, "http://198.199.118.177:9000/api/ratings\(newCoords)").responseJSON { (req, res, json, error) in
                if(error != nil) {
                    NSLog("Error: \(error)")
                    println(req)
                    println(res)
                }
                else {
                    
                    
                    NSLog("Success: http://198.199.118.177:9000/api/ratings\(newCoords)")
                    
                    var myJSON = JSON(json!)
                    
                    var x = 0
                    var count = myJSON.count
                    
                    let realm = RLMRealm.defaultRealm()
                    
                    //clear the db
                    realm.beginWriteTransaction()
                    realm.deleteAllObjects()
                    realm.commitWriteTransaction()
                    
                    var newVote = [Vote](count: count, repeatedValue: Vote())
                    
                    
                    realm.beginWriteTransaction()
                    
                    let size = SizeofPoints()
                    size.length = "\(count)"
                    realm.addObject(size)
                    
                    
                    
                    while x < count {
                        
                        //for now this works... but in the future it would be best to compare if a vote already exists or if it were deleted
                        
                        
                        let newVote = Vote()
                        
                        var lon: Double = myJSON[x]["loc"]["coordinates"][0].doubleValue
                        var lat: Double = myJSON[x]["loc"]["coordinates"][1].doubleValue
                        
                        newVote.bump = "\(lon), \(lat), Isla Vista, California, +1 949 292 6284"
                        
                        println("\(lon), \(lat), Isla Vista, California, +1 949 292 6284")
                        
                        realm.addObject(newVote)
                        
                        
                        x++
                        
                    }
                    
                    
                    realm.commitWriteTransaction()
                    
                    self.coordinateQuadTree  = TBCoordinateQuadTree()
                    self.coordinateQuadTree.mapView = self.mapView
                    self.coordinateQuadTree.buildTree()
                    
                    var scale: Double = Double((self.mapView.bounds.size.width / CGFloat(self.mapView.visibleMapRect.size.width)))
                    let annotations: NSArray = self.coordinateQuadTree.clusteredAnnotationsWithinMapRect(self.mapView.visibleMapRect, withZoomScale: scale)
                    //self.requestUpdate()
                    self.updateMapViewAnnotationsWithAnnotations(annotations)
                    
                }
                
                
                
            }
            
            
            
        }
        
        
        
    }
    
    
    func updateMe(){
        manager = nil
        manager = CLLocationManager()
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.requestWhenInUseAuthorization()
        manager.startUpdatingLocation()
        
    }
    
    //POST
    
    func post()->Void {
        
        let parameters = [
            "owner": "Cop",
            "up": true,
            "loc": [
                "type": "Point",
                "coordinates": [
                    mapView.userLocation.coordinate.longitude,
                    mapView.userLocation.coordinate.latitude
                ]
            ]
        ]
        
        print(parameters)
        
        Alamofire.request(.POST, "http://198.199.118.177:9000/api/ratings", parameters: parameters, encoding: .JSON)
        
        //mapView.removeAnnotations(mapView.annotations)
        //requestUpdate()
        
    }
    
    func mapView(mapView: MKMapView!, didUpdateUserLocation userLocation: MKUserLocation!) {
        
        if intialLocationLoad == false{
            
            currentLocation()
            
            //TODO: Make it so when you go so far it atomatically reloads
            intialLocationLoad = true
        }
        
    }
    
    //function that ask for currentLocation and loads the map at user location
    func currentLocation() -> Void {
        let spanX = 0.01
        let spanY = 0.01
        var newRegion = MKCoordinateRegion(center: mapView.userLocation.coordinate, span: MKCoordinateSpanMake(spanX, spanY))
        mapView.setRegion(newRegion, animated: false)
        //mapView.removeAnnotations(mapView.annotations)
        
        
        setUpVotes()
        //requestUpdate()
    }
    
    func mapView(mapView: MKMapView!, regionDidChangeAnimated animated: Bool) {
        
        println(mapView.region.span.latitudeDelta)
        println(mapView.region.span.longitudeDelta)
        if intialLocationLoad == true {
            if (mapView.region.span.latitudeDelta > 0.6 || mapView.region.span.longitudeDelta > 0.6){
                
                let spanX = 0.40
                let spanY = 0.40
                var newRegion = MKCoordinateRegion(center: mapView.userLocation.coordinate, span: MKCoordinateSpanMake(spanX, spanY))
                mapView.setRegion(newRegion, animated: false)
                //mapView.removeAnnotations(mapView.annotations)
                
                //TODO MAKE IT NOT CENTER ON  HOME AND WARN THE USER//
                //IF THIS HAPPEN IT CRASHES THE APP BTW
            }
            
            //        NSOperationQueue().addOperationWithBlock({
            var scale: Double = Double((self.mapView.bounds.size.width / CGFloat(self.mapView.visibleMapRect.size.width)))
            let annotations: NSArray = self.coordinateQuadTree.clusteredAnnotationsWithinMapRect(self.mapView.visibleMapRect, withZoomScale: scale)
            //self.requestUpdate()
            self.updateMapViewAnnotationsWithAnnotations(annotations)
            //        })
            //requestUpdate()
        }
    }
    
    
    
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        println("Center will appear")
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
    
    func setupLeftMenuButton() {
        let leftDrawerButton = DrawerBarButtonItem(target: self, action: "leftDrawerButtonPress:")
        self.navigationItem.setLeftBarButtonItem(leftDrawerButton, animated: true)
    }
    
    func setupRightMenuButton() {
        let rightDrawerButton = DrawerBarButtonItem(target: self, action: "rightDrawerButtonPress:")
        self.navigationItem.setRightBarButtonItem(rightDrawerButton, animated: true)
    }
    
    override func contentSizeDidChange(size: String) {
        self.tableView.reloadData()
    }
    
    // MARK: - UITableViewDataSource
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 4
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case CenterViewControllerSection.LeftDrawerAnimation.rawValue, CenterViewControllerSection.RightDrawerAnimation.rawValue:
            return 6
        case CenterViewControllerSection.LeftViewState.rawValue, CenterViewControllerSection.RightViewState.rawValue:
            return 1
        default:
            return 0
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let CellIdentifier = "Cell"
        
        var cell: UITableViewCell! = tableView.dequeueReusableCellWithIdentifier(CellIdentifier) as? UITableViewCell
        
        if cell == nil {
            cell = CenterTableViewCell(style: .Default, reuseIdentifier: CellIdentifier)
            cell.selectionStyle = .Gray
        }
        
        let selectedColor = UIColor(red: 1 / 255, green: 15 / 255, blue: 25 / 255, alpha: 1.0)
        let unselectedColor = UIColor(red: 79 / 255, green: 93 / 255, blue: 102 / 255, alpha: 1.0)
        
        switch indexPath.section {
        case CenterViewControllerSection.LeftDrawerAnimation.rawValue, CenterViewControllerSection.RightDrawerAnimation.rawValue:
            var animationTypeForSection: DrawerAnimationType
            
            if indexPath.section == CenterViewControllerSection.LeftDrawerAnimation.rawValue {
                animationTypeForSection = ExampleDrawerVisualStateManager.sharedManager.leftDrawerAnimationType
            } else {
                animationTypeForSection = ExampleDrawerVisualStateManager.sharedManager.rightDrawerAnimationType
            }
            
            if animationTypeForSection.rawValue == indexPath.row {
                cell.accessoryType = .Checkmark
                cell.textLabel?.textColor = selectedColor
            } else {
                cell.accessoryType = .None
                cell.textLabel?.textColor = unselectedColor
            }
            
            switch indexPath.row {
            case DrawerAnimationType.None.rawValue:
                cell.textLabel?.text = "None"
            case DrawerAnimationType.Slide.rawValue:
                cell.textLabel?.text = "Slide"
            case DrawerAnimationType.SlideAndScale.rawValue:
                cell.textLabel?.text = "Slide and Scale"
            case DrawerAnimationType.SwingingDoor.rawValue:
                cell.textLabel?.text = "Swinging Door"
            case DrawerAnimationType.Parallax.rawValue:
                cell.textLabel?.text = "Parallax"
            case DrawerAnimationType.AnimatedBarButton.rawValue:
                cell.textLabel?.text = "Animated Menu Button"
            default:
                break
            }
        case CenterViewControllerSection.LeftViewState.rawValue:
            cell.textLabel?.text = "Enabled"
            
            if self.evo_drawerController?.leftDrawerViewController != nil {
                cell.accessoryType = .Checkmark
                cell.textLabel?.textColor = selectedColor
            } else {
                cell.accessoryType = .None
                cell.textLabel?.textColor = unselectedColor
            }
        case CenterViewControllerSection.RightViewState.rawValue:
            cell.textLabel?.text = "Enabled"
            
            if self.evo_drawerController?.rightDrawerViewController != nil {
                cell.accessoryType = .Checkmark
                cell.textLabel?.textColor = selectedColor
            } else {
                cell.accessoryType = .None
                cell.textLabel?.textColor = unselectedColor
            }
        default:
            break
        }
        
        return cell
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case CenterViewControllerSection.LeftDrawerAnimation.rawValue:
            return "Left Drawer Animation";
        case CenterViewControllerSection.RightDrawerAnimation.rawValue:
            return "Right Drawer Animation";
        case CenterViewControllerSection.LeftViewState.rawValue:
            return "Left Drawer";
        case CenterViewControllerSection.RightViewState.rawValue:
            return "Right Drawer";
        default:
            return nil
        }
    }
    
    // MARK: - UITableViewDelegate
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        switch indexPath.section {
        case CenterViewControllerSection.LeftDrawerAnimation.rawValue, CenterViewControllerSection.RightDrawerAnimation.rawValue:
            if indexPath.section == CenterViewControllerSection.LeftDrawerAnimation.rawValue {
                ExampleDrawerVisualStateManager.sharedManager.leftDrawerAnimationType = DrawerAnimationType(rawValue: indexPath.row)!
            } else {
                ExampleDrawerVisualStateManager.sharedManager.rightDrawerAnimationType = DrawerAnimationType(rawValue: indexPath.row)!
            }
            
            tableView.reloadSections(NSIndexSet(index: indexPath.section), withRowAnimation: .None)
            tableView.selectRowAtIndexPath(indexPath, animated: false, scrollPosition: .None)
            tableView.deselectRowAtIndexPath(indexPath, animated: true)
        case CenterViewControllerSection.LeftViewState.rawValue, CenterViewControllerSection.RightViewState.rawValue:
            var sideDrawerViewController: UIViewController?
            var drawerSide = DrawerSide.None
            
            if indexPath.section == CenterViewControllerSection.LeftViewState.rawValue {
                sideDrawerViewController = self.evo_drawerController?.leftDrawerViewController
                drawerSide = .Left
            } else if indexPath.section == CenterViewControllerSection.RightViewState.rawValue {
                sideDrawerViewController = self.evo_drawerController?.rightDrawerViewController
                drawerSide = .Right
            }
            
            if sideDrawerViewController != nil {
                self.evo_drawerController?.closeDrawerAnimated(true, completion: { (finished) -> Void in
                    if drawerSide == DrawerSide.Left {
                        self.evo_drawerController?.leftDrawerViewController = nil
                        self.navigationItem.setLeftBarButtonItems(nil, animated: true)
                    } else if drawerSide == .Right {
                        self.evo_drawerController?.rightDrawerViewController = nil
                        self.navigationItem.setRightBarButtonItems(nil, animated: true)
                    }
                    
                    tableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: .None)
                    tableView.selectRowAtIndexPath(indexPath, animated: false, scrollPosition: .None)
                    tableView.deselectRowAtIndexPath(indexPath, animated: true)
                })
            } else {
                if drawerSide == .Left {
                    let vc = ExampleLeftSideDrawerViewController()
                    let navC = UINavigationController(rootViewController: vc)
                    self.evo_drawerController?.leftDrawerViewController = navC
                    self.setupLeftMenuButton()
                } else if drawerSide == .Right {
                    let vc = ExampleRightSideDrawerViewController()
                    let navC = UINavigationController(rootViewController: vc)
                    self.evo_drawerController?.rightDrawerViewController = navC
                    self.setupRightMenuButton()
                }
                
                tableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: .None)
                tableView.selectRowAtIndexPath(indexPath, animated: false, scrollPosition: .None)
                tableView.deselectRowAtIndexPath(indexPath, animated: true)
            }
        default:
            break
        }
    }
    
    func mapView(mapView: MKMapView!, viewForAnnotation annotation: MKAnnotation!) -> MKAnnotationView! {
        
        if annotation is MKUserLocation {
            //return nil so map view draws "blue dot" for standard user location
            
            let reuseId = "me"
            var pinView = mapView.dequeueReusableAnnotationViewWithIdentifier(reuseId)
            pinView = MKAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            //pinView!.annotation = annotation
            pinView!.draggable = true
            pinView!.canShowCallout = false
            pinView!.annotation = annotation
            pinView!.selected = true
            pinView!.image = UIImage(named: "location_button.png")
            pinView.layer.zPosition = 1
            return pinView
            
        }
        
        let TBAnnotationViewReuseID:String! = "TBAnnotatioViewReuseID"
        
        //iffy here
        var annotationView:TBClusterAnnotationView! = mapView.dequeueReusableAnnotationViewWithIdentifier(TBAnnotationViewReuseID) as TBClusterAnnotationView!
        if ((annotationView) == nil) {
            annotationView = TBClusterAnnotationView(annotation: annotation, reuseIdentifier: TBAnnotationViewReuseID)
        }
        
        annotationView.canShowCallout = false
        var annotation_count: TBClusterAnnotation! = annotation as TBClusterAnnotation
        
        annotationView.count = UInt(annotation_count.count)
        return annotationView
        
    }
    
    
    func updateMapViewAnnotationsWithAnnotations(annotations: NSArray) {
        var before: NSMutableSet! = NSMutableSet(array: self.mapView.annotations)
        before.removeObject(self.mapView.userLocation)
        var after: NSSet! = NSSet(array: annotations)
        
        var toKeep: NSMutableSet! = NSMutableSet(set: before)
        toKeep.intersectSet(after)
        
        var toAdd: NSMutableSet! = NSMutableSet(set: after)
        toAdd.minusSet(toKeep)
        
        var toRemove: NSMutableSet! = NSMutableSet(set: before)
        toRemove.minusSet(after)
        
        //        NSOperationQueue.mainQueue().addOperationWithBlock({
        self.mapView.addAnnotations(toAdd.allObjects)
        self.mapView.removeAnnotations(toRemove.allObjects)
        //        })
        
        //        dispatch_async(dispatch_get_main_queue())  {
        //                self.mapView.addAnnotations([toAdd.allObjects])
        //                self.mapView.removeAnnotations([toRemove.allObjects])
        //            }
    }
    
    var images: NSMutableArray = [
        "Comp 4_00000.png",
        "Comp 4_00001.png",
        "Comp 4_00002.png",
        "Comp 4_00003.png",
        "Comp 4_00004.png",
        "Comp 4_00005.png",
        "Comp 4_00006.png",
        "Comp 4_00007.png",
        "Comp 4_00008.png",
        "Comp 4_00009.png",
        "Comp 4_00010.png",
        "Comp 4_00011.png",
        "Comp 4_00012.png",
        "Comp 4_00013.png",
        "Comp 4_00014.png",
        "Comp 4_00015.png",
        "Comp 4_00016.png",
        "Comp 4_00017.png",
        "Comp 4_00018.png",
        "Comp 4_00019.png",
        "Comp 4_00020.png",
        "Comp 4_00021.png",
        "Comp 4_00022.png",
        "Comp 4_00023.png",
        "Comp 4_00024.png",
        "Comp 4_00025.png",
        "Comp 4_00026.png",
        "Comp 4_00027.png",
        "Comp 4_00028.png",
        "Comp 4_00029.png",
        "Comp 4_00030.png",
        "Comp 4_00031.png",
        "Comp 4_00032.png",
        "Comp 4_00033.png",
        "Comp 4_00034.png",
        "Comp 4_00035.png",
        "Comp 4_00036.png",
        "Comp 4_00037.png",
        "Comp 4_00038.png",
        "Comp 4_00039.png",
        "Comp 4_00040.png",
        "Comp 4_00041.png",
        "Comp 4_00042.png",
        "Comp 4_00043.png",
        "Comp 4_00044.png",
        "Comp 4_00045.png",
        "Comp 4_00046.png",
        "Comp 4_00047.png",
        "Comp 4_00048.png",
        "Comp 4_00049.png",
        "Comp 4_00050.png",
        "Comp 4_00051.png",
        "Comp 4_00052.png",
        "Comp 4_00053.png",
        "Comp 4_00054.png",
        "Comp 4_00055.png",
        "Comp 4_00056.png",
        "Comp 4_00057.png",
        "Comp 4_00058.png",
        "Comp 4_00059.png",
        "Comp 4_00060.png",
        "Comp 4_00061.png",
        "Comp 4_00062.png",
        "Comp 4_00063.png",
        "Comp 4_00064.png",
        "Comp 4_00065.png",
        "Comp 4_00066.png",
        "Comp 4_00067.png",
        "Comp 4_00068.png",
        "Comp 4_00069.png",
        "Comp 4_00070.png",
        "Comp 4_00071.png",
        "Comp 4_00072.png",
        "Comp 4_00073.png",
        "Comp 4_00074.png",
        "Comp 4_00075.png",
        "Comp 4_00076.png",
        "Comp 4_00077.png",
        "Comp 4_00078.png",
        "Comp 4_00079.png",
        "Comp 4_00080.png",
        "Comp 4_00081.png",
        "Comp 4_00082.png",
        "Comp 4_00083.png",
        "Comp 4_00084.png",
        "Comp 4_00085.png",
        "Comp 4_00086.png",
        "Comp 4_00087.png",
        "Comp 4_00088.png",
        "Comp 4_00089.png"
    ]
    
    
    func mapView(mapView: MKMapView!, annotationView view: MKAnnotationView!, didChangeDragState newState: MKAnnotationViewDragState, fromOldState oldState: MKAnnotationViewDragState) {
        
        //        enum MKAnnotationViewDragState : UInt {
        //            case None
        //            case Starting
        //            case Dragging
        //            case Canceling
        //            case Ending
        //        }'
        
        //        var animationFrames:UIImage = UIImage()
        //        animationFrames.animationImages = images
        //        animationFrames.startAnimating()
        
        //        var animatedImagesWithImages
        
        //restore = view
        
        if oldState == MKAnnotationViewDragState.None {
            println("sup")
        }
        if newState == MKAnnotationViewDragState.Starting {
            println("button come to mamma")
            //view!.image = animationFrames as? UIImage
            
            myAnnotationView = view
            
            timer = NSTimer.scheduledTimerWithTimeInterval(1/60, target: self, selector: Selector("update"), userInfo: nil, repeats: true)
            
            view.dragState = MKAnnotationViewDragState.Dragging
            
            
            //view.image = UIImage(named: "location_button.png")
            //            var i: Int = 0
            //            while i < 90{
            //                view.image = UIImage(named: images[i] as String)
            //                i = i + 1
            //            }
        }
        if newState == MKAnnotationViewDragState.Dragging {
            println("omg it'ssssssssssssss working")
        }
        if newState == MKAnnotationViewDragState.Ending {
            timer.invalidate()
            x = 0
            myAnnotationView.image = UIImage(named: "location_button.png")
            //myAnnotationView = restore
            println("omg it's working")
            
            view.dragState = MKAnnotationViewDragState.None
            
            //view.draggable = false
            //mapView.removeAnnotation(view.annotation)
            //requestUpdate()
        }
        
        if newState == MKAnnotationViewDragState.Canceling {
            timer.invalidate()
            x = 0
            myAnnotationView.image = UIImage(named: "location_button.png")
            
            view.dragState = MKAnnotationViewDragState.None
        }
        
        
    }
    
    func update(){
        if x < 62 {
            myAnnotationView.image = UIImage(named: images[x] as String)
            x = x + 1
        }else {
            x = 0
            post(true)
            setUpVotes()
            
            timer.invalidate()
            
            
            
        }
        
        println(x)
        
        
    }
    
    func post(vote: Bool)->Void {
        
        let parameters = [
            "owner": "Cop",
            "up": vote,
            "loc": [
                "type": "Point",
                "coordinates": [
                    mapView.userLocation.coordinate.longitude,
                    mapView.userLocation.coordinate.latitude
                ]
            ]
        ]
        
        print(parameters)
        
        Alamofire.request(.POST, "http://198.199.118.177:9000/api/ratings", parameters: parameters, encoding: .JSON)
        
        
    }
    
    // MARK: - Bounce Animations
    
    func addBounceAnimatonToView(view: UIView) {
        
        var bounceAnimation: CAKeyframeAnimation = CAKeyframeAnimation(keyPath: "transform.scale")
        bounceAnimation.values = [0.05, 1.1, 0.9, 1]
        
        bounceAnimation.duration = 0.6
        
        var timingFunctions: NSMutableArray = NSMutableArray(capacity: bounceAnimation.values.count)
        
        for var i = 0; i < 3; i++ {
            timingFunctions.addObject(kCAMediaTimingFunctionEaseInEaseOut)
        }
        
        //bounceAnimation.timingFunctions(timingFunctions.copy())
        
        bounceAnimation.removedOnCompletion = false
        
        view.layer.addAnimation(bounceAnimation, forKey: "bounce")
        
    }
    
    //var bounceAnimation: CAKeyframeAnimation = keyPathsForValuesAffectingValueForKey("transform.scale")
    
    
    // MARK: - Button Handlers
    
    func leftDrawerButtonPress(sender: AnyObject?) {
        self.evo_drawerController?.toggleDrawerSide(.Left, animated: true, completion: nil)
    }
    
    func rightDrawerButtonPress(sender: AnyObject?) {
        self.evo_drawerController?.toggleDrawerSide(.Right, animated: true, completion: nil)
    }
    
    func doubleTap(gesture: UITapGestureRecognizer) {
        //self.evo_drawerController?.bouncePreviewForDrawerSide(.Left, completion: nil)
        ///////////currentLocation()
    }
    
    func twoFingerDoubleTap(gesture: UITapGestureRecognizer) {
        self.evo_drawerController?.bouncePreviewForDrawerSide(.Right, completion: nil)
        
        //currentLocation()
    }
    
    //HELPS WITH MEMORY OF THE MAP
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        mapView.mapType = MKMapType.Standard
        mapView.removeFromSuperview()
        mapView = nil
    }
    
}
