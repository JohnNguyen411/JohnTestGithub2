//
//  MapViewController.swift
//  voluxe-customer
//
//  Created by Giroux, Johan on 11/15/17.
//  Copyright © 2017 Luxe - Volvo Cars. All rights reserved.
//

import Foundation
import GoogleMaps

class MapViewController: UIViewController {
    
    private let mapView = GMSMapView()
    private let flagMarker = GMSMarker()
    private let driverMarker = GMSMarker()
    
    convenience init(requestLocation: CLLocationCoordinate2D) {
        self.init()
        updateRequestLocation(location: requestLocation)
    }
    
    init() {
        mapView.setMinZoom(6, maxZoom: 18)
        mapView.isMyLocationEnabled = false
        mapView.isBuildingsEnabled = false
        mapView.settings.indoorPicker = false
        mapView.settings.scrollGestures = false
        mapView.settings.rotateGestures = false
        mapView.settings.tiltGestures = false
        mapView.settings.zoomGestures = false
        
        flagMarker.icon = UIImage(named: "pin_location")
        driverMarker.icon = UIImage(named: "driver_location")
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(mapView)
        mapView.snp.makeConstraints { (make) -> Void in
            make.edges.equalTo(self.view)
        }
    }
    
    func updateRequestLocation(location: CLLocationCoordinate2D) {
        flagMarker.map = mapView
        flagMarker.position = location
        moveCamera()
    }
    
    func updateDriverLocation(location: CLLocationCoordinate2D) {
        driverMarker.map = mapView
        driverMarker.position = location
        moveCamera()
    }
    
    func moveCamera() {
        
        if flagMarker.map != nil && driverMarker.map != nil {
            var bounds = GMSCoordinateBounds()
            bounds = bounds.includingCoordinate(flagMarker.position)
            bounds = bounds.includingCoordinate(driverMarker.position)
            let update = GMSCameraUpdate.fit(bounds, with: UIEdgeInsets(top: 60, left: 30, bottom: 20, right: 30))
            mapView.animate(with: update)
        } else if flagMarker.map != nil {
            mapView.animate(toLocation: flagMarker.position)
            mapView.animate(toZoom: 13)
        }
    }
    
}
