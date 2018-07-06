//
//  Global.swift
//  CarentoSDK
//
//  Created by Tuan Anh Vu on 6/29/18.
//  Copyright © 2018 Carento. All rights reserved.
//

import Foundation
import MapKit
import GoogleMaps
import GooglePlaces

class Global: NSObject {
    static let shared = Global()
    
    var serviceApiKey: String?
    var enterpriseToken: String?
    
    var hotline = "0989668247"
    var currentLanguageCode = "vi-VN"
    
    var currentTripName = ""
    var userMobile = ""
    var userFullName = ""
    var flightCode = ""
    var flightTime = 0
    
    var locationManager = CLLocationManager()
    var currentMarkerLoc: LocationObject?
    let defaultLocation = CLLocationCoordinate2D(latitude: 20.962685, longitude: 105.825968)
    var zoomLevel: Float = 15.0
    var currentLocation: CLLocationCoordinate2D?
    var enablePickLocation = false
    var gmsGeoCoder: GMSGeocoder = GMSGeocoder.init()
    var mapMoving: Bool = false
    var showedCurrentLocation = false
    
    lazy var map: GMSMapView? = {
        return setupMap()
    }()
    
    
    
    func setupMap() -> GMSMapView? {
        // Create a GMSCameraPosition that tells the map to display the
        // default coordinate
        let camera = GMSCameraPosition.camera(withLatitude: defaultLocation.latitude, longitude: defaultLocation.longitude, zoom: zoomLevel)
        let mapView = GMSMapView.map(withFrame: CGRect.zero, camera: camera)
        mapView.isMyLocationEnabled = true
        //        mapView.settings.myLocationButton = true
        //        mapView.delegate = self
        
        // enable location tracker
        if (CLLocationManager.locationServicesEnabled()) {
            locationManager = CLLocationManager()
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.requestWhenInUseAuthorization()
            locationManager.distanceFilter = 50
            locationManager.startUpdatingLocation()
            locationManager.delegate = self
        }
        
        return mapView
    }
    
    func reverseGeocoderFrom(coordinate: CLLocationCoordinate2D, detectedAddress: GeoCoderCallBack?) {
        if (!enablePickLocation && (detectedAddress==nil)) {
            return
        }
        gmsGeoCoder.reverseGeocodeCoordinate(coordinate, completionHandler: { (geoCoderResponse, error) in
            let address = geoCoderResponse?.firstResult()
            if let detectedAddress = detectedAddress {
                detectedAddress(address?.lines)
            }
            if let address = address {
                if let name = address.lines?.first {
                    self.createMarker(loc: LocationObject(lat: address.coordinate.latitude, long: address.coordinate.longitude, name: name))
                }
            }
            
        })
    }
    
    func createMarker(loc: LocationObject) {
        focusTo(location: loc.getLocObject())
        currentMarkerLoc = loc
        NotificationCenter.default.post(name: Notification.Name.pickUpLocationChanged, object: nil)
    }
    
    func changeMapDelegate(enable: Bool) {
        self.map?.delegate = enable ? self : nil
    }
    
    func focusTo(location: CLLocationCoordinate2D) {
        print("tracker X - focus to location: I'm here")
        let camera = GMSCameraPosition.camera(withLatitude: location.latitude,
                                              longitude: location.longitude,
                                              zoom: self.zoomLevel)
        map?.animate(to: camera)
    }
}

extension Global: GMSMapViewDelegate {
    
    func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D) {
        self.reverseGeocoderFrom(coordinate: coordinate, detectedAddress: nil)
    }
    
    func mapView(_ mapView: GMSMapView, didChange position: GMSCameraPosition) {
        self.zoomLevel = mapView.camera.zoom
    }
    
    func mapView(_ mapView: GMSMapView, idleAt position: GMSCameraPosition) {
        print("idled at location: \(position.target)")
        self.mapMoving = false
        self.reverseGeocoderFrom(coordinate: position.target, detectedAddress: nil)
    }
    
    func mapView(_ mapView: GMSMapView, willMove gesture: Bool) {
        if (self.mapMoving == false) {
            NotificationCenter.default.post(name: Notification.Name.googleMapIsMoving, object: nil)
        }
        self.mapMoving = true
    }
}

extension Global: CLLocationManagerDelegate {
    private func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        print("tracker X - did change author status: I'm here")
        switch status {
        case .restricted:
            print("Location access was restricted.")
        case .denied:
            print("User denied access to location.")
            // Display the map using the default location.
            map?.isMyLocationEnabled = false
        case .notDetermined:
            print("Location status not determined.")
        case .authorizedAlways: fallthrough
        case .authorizedWhenInUse:
            print("Location status is OK.")
            locationManager.startUpdatingLocation()
        }
    }
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if showedCurrentLocation {
            return
        }
        showedCurrentLocation = true
        print("tracker X - did update location: I'm here")
        // get out ra the current location
        guard let location: CLLocation = locations.last else {return}
        currentLocation = location.coordinate
        focusTo(location: location.coordinate)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("tracker X - update location failed: I'm here")
        print("error: \(error.localizedDescription)")
        locationManager.stopUpdatingLocation()
    }
    
}
