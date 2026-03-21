//
//  LocationManager.swift
//  CampusApp
//
//  Created by Haley Parker on 3/20/26.
//

import SwiftUI
import MapKit
import CoreLocation
import Observation


@Observable
class LocationManager: NSObject, CLLocationManagerDelegate{
    
    let manager = CLLocationManager()


var userLoc: CLLocationCoordinate2D?

    var UserActiveLoc: MKCoordinateRegion =
    MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 40.7982, longitude: -77.8599),
        span: MKCoordinateSpan(latitudeDelta: 0.02, longitudeDelta: 0.02)
      
    )

override init(){
    super.init()
    manager.delegate = self
    
    manager.desiredAccuracy = kCLLocationAccuracyBest


}
    
    func requestLocation(){
        manager.requestWhenInUseAuthorization( )
        manager.startUpdatingLocation( )
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        userLoc = location.coordinate
        
        
        UserActiveLoc =
        MKCoordinateRegion(
            center: location.coordinate,
            span: MKCoordinateSpan(latitudeDelta: 0.02, longitudeDelta: 0.02)
          
        )
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        
        print("Failed to find user's location: \(error.localizedDescription)")
    }
    
}
