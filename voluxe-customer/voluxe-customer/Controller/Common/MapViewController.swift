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
    private let etaMarker = ETAMarker(frame: CGRect(x: 0, y: 0, width: 44, height: 54))
    
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
        
        flagMarker.iconView = etaMarker
        driverMarker.icon = UIImage(named: "marker_car")
        
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
        // get ETA between location and flagMarker position
        driverMarker.map = mapView
        driverMarker.rotation = degreeBearing(from: self.driverMarker.position, to: location)
        driverMarker.position = location
        moveCamera()
    }
    
    func updateETA(eta: GMTextValueObject?) {
        etaMarker.setETA(eta: eta)
    }
    
    func updateServiceState(state: ServiceState) {
        if state == .pickupDriverArrived {
            etaMarker.hideEta()
        }
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
    
    func degreeBearing(from: CLLocationCoordinate2D, to: CLLocationCoordinate2D) -> Double {
        var dlon = self.toRad(to.longitude - from.longitude)
        let dPhi = log(tan(self.toRad(to.latitude) / 2 + .pi / 4) / tan(self.toRad(from.latitude) / 2 + .pi / 4))
        if  abs(dlon) > .pi{
            dlon = (dlon > 0) ? (dlon - 2 * .pi) : (2 * .pi + dlon)
        }
        return self.toBearing(atan2(dlon, dPhi))
    }
    
    func toRad(_ degrees: Double) -> Double{
        return degrees*(.pi / 180)
    }
    
    func toBearing(_ radians: Double) -> Double{
        return (toDegrees(radians) + 360).truncatingRemainder(dividingBy: 360)
    }
    
    func toDegrees(_ radians: Double) -> Double{
        return radians * 180 / .pi
    }
}
