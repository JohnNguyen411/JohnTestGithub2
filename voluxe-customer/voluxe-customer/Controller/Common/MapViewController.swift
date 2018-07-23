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

    public var screen = AnalyticsEnums.Name.Screen.pickupActive
    private let mapView = GMSMapView()
    private let flagMarker = GMSMarker()
    private let driverMarker = GMSMarker()
    private let etaMarker = ETAMarker(frame: CGRect(x: 0, y: 0, width: 41, height: 62))
    
    private var requestLocation: CLLocationCoordinate2D?
    
    convenience init(requestLocation: CLLocationCoordinate2D) {
        self.init()
        updateRequestLocation(location: requestLocation)
    }
    
    init() {
        mapView.setMinZoom(6, maxZoom: 18)
        mapView.isMyLocationEnabled = false
        mapView.isBuildingsEnabled = false
        mapView.isUserInteractionEnabled = false
        mapView.settings.indoorPicker = false
        mapView.settings.scrollGestures = false
        mapView.settings.rotateGestures = false
        mapView.settings.tiltGestures = false
        mapView.settings.zoomGestures = false
        
        driverMarker.appearAnimation = GMSMarkerAnimation.pop
        driverMarker.groundAnchor = CGPoint(x: 0.5, y: 0.5)
        
        flagMarker.tracksViewChanges = true
        flagMarker.iconView = etaMarker
        flagMarker.tracksViewChanges = false
        
        driverMarker.tracksViewChanges = false
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
    
    func updateRequestLocation(location: CLLocationCoordinate2D, withZoom: Float? = nil) {
        flagMarker.tracksViewChanges = true
        flagMarker.map = mapView
        flagMarker.position = location
        moveCamera(withZoom)
        flagMarker.tracksViewChanges = false
        self.requestLocation = location
    }
    
    // refreshTime is the current time between 2 refresh depending on the state of reservation and how close is the driver from origin or destination
    func updateDriverLocation(location: CLLocationCoordinate2D, refreshTime: Int) {
        
        let prevLocation = self.driverMarker.position
        let noPreviousLocation = prevLocation.latitude == -180 && prevLocation.longitude == -180
        // proceed if location update is worthy
        if !noPreviousLocation && Location.distanceBetweenLocations(from: prevLocation, to: location) < 5 {
            return
        }
        
        let animationDuration = Double(refreshTime)
        weak var weakSelf = self
        
        if noPreviousLocation || !RemoteConfigManager.sharedInstance.getBoolValue(key: RemoteConfigManager.snappedPointsKey) {
            weakSelf?.updateLocation(location: location, prevLocation: prevLocation, animationDuration: animationDuration, updateCamera: true)
            return
        }

        GoogleSnappedPointsAPI().getSnappedPoints(from: GoogleDistanceMatrixAPI.coordinatesToString(coordinate: prevLocation), to: GoogleDistanceMatrixAPI.coordinatesToString(coordinate: location)).onSuccess { results in

            Analytics.trackCallGoogle(endpoint: .roads)

            guard let weakSelf = weakSelf else { return }
            
            if let results = results, let snappedPoints = results.snappedPoints {
                // animate points
                let pointsAnimationDuration = animationDuration / Double(snappedPoints.count)
                var delay = 0.0
                for (index, point) in snappedPoints.enumerated() {
                    DispatchQueue.main.asyncAfter(deadline: .now() + delay, execute: {
                        if let location = point.location, let coordinates = location.getLocation() {
                            weakSelf.updateLocation(location: coordinates, prevLocation: prevLocation , animationDuration: pointsAnimationDuration, updateCamera: index % 2 == 0)
                        }
                    })
                    delay = delay + pointsAnimationDuration
                }
                weak var weakSelf = self
                DispatchQueue.main.asyncAfter(deadline: .now() + delay + 0.5, execute: {
                    weakSelf?.moveCamera()
                })
            } else {
                weakSelf.updateLocation(location: location, prevLocation: prevLocation, animationDuration: animationDuration, updateCamera: true)
            }
            }.onFailure { error in
                Analytics.trackCallGoogle(endpoint: .roads, error: error)
                guard let weakSelf = weakSelf else { return }
                weakSelf.updateLocation(location: location, prevLocation: prevLocation, animationDuration: animationDuration, updateCamera: true)
        }
    }
    
    
    private func updateLocation(location: CLLocationCoordinate2D, prevLocation: CLLocationCoordinate2D, animationDuration: Double, updateCamera: Bool) {
        CATransaction.begin()
        CATransaction.setValue(animationDuration, forKey: kCATransactionAnimationDuration)

        driverMarker.position = location
        driverMarker.map = mapView
        let noPreviousLocation = prevLocation.latitude == -180 && prevLocation.longitude == -180
        if !noPreviousLocation && (prevLocation.latitude != location.latitude || prevLocation.longitude != location.longitude) {
            let degreeBearing = self.degreeBearing(from: prevLocation, to: location)
            driverMarker.rotation = degreeBearing
        }
        CATransaction.commit()
        
        if updateCamera {
            weak var weakSelf = self
            var delay = DispatchTime.now() + animationDuration + 0.1
            if noPreviousLocation {
                delay = DispatchTime.now() + 0.2
            }
            DispatchQueue.main.asyncAfter(deadline: delay, execute: {
                weakSelf?.moveCamera()
            })
        }
    }
    
    func updateETA(eta: GMTextValueObject?) {
        flagMarker.tracksViewChanges = true
        etaMarker.setETA(eta: eta)
        flagMarker.tracksViewChanges = false
    }
    
    func updateServiceState(state: ServiceState) {
        if state == .arrivedForPickup || state == .arrivedForDropoff {
            flagMarker.tracksViewChanges = true
            etaMarker.hideEta()
            flagMarker.tracksViewChanges = false
        } else if state == .pickupScheduled || state == .dropoffScheduled {
            flagMarker.tracksViewChanges = true
            etaMarker.hideEta()
            driverMarker.map = nil
            flagMarker.tracksViewChanges = false
            if let requestLocation = self.requestLocation {
                updateRequestLocation(location: requestLocation)
            }
        }
    }
    
    private func moveCamera(flagPosition: CLLocationCoordinate2D, futureDriverPosition: CLLocationCoordinate2D) {
        Logger.print("***** moveCamera BEFORE ***** \(flagPosition),\(futureDriverPosition)")
        var bounds = GMSCoordinateBounds()
        bounds = bounds.includingCoordinate(flagPosition)
        bounds = bounds.includingCoordinate(futureDriverPosition)
        let update = GMSCameraUpdate.fit(bounds, with: UIEdgeInsets(top: 60, left: 30, bottom: 20, right: 30))
        
        mapView.animate(with: update)
    }
    
    func moveCamera(_ withZoom: Float? = nil) {
        
        if flagMarker.map != nil && driverMarker.map != nil {
            Logger.print("***** moveCamera AFTER ***** \(flagMarker.position),\(driverMarker.position)")

            var bounds = GMSCoordinateBounds()
            bounds = bounds.includingCoordinate(flagMarker.position)
            bounds = bounds.includingCoordinate(driverMarker.position)
            let update = GMSCameraUpdate.fit(bounds, with: UIEdgeInsets(top: 60, left: 30, bottom: 20, right: 30))
            mapView.animate(with: update)
        } else if flagMarker.map != nil {
            mapView.animate(toLocation: flagMarker.position)
            if let withZoom = withZoom {
                mapView.animate(toZoom: withZoom)
            } else {
                mapView.animate(toZoom: 13)
            }
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
