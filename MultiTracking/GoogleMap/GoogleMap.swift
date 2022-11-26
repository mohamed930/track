//
//  GoogleMap.swift
//  MultiTracking
//
//  Created by Mohamed Ali on 26/11/2022.
//

import UIKit
import GoogleMaps

class GoogleMap {
    
    private var gmapView: UIView!
    private var mapView:GMSMapView!
    private var apikey: String!
    private var camera:GMSCameraPosition?
    static var markers = Array<GMSMarker>()
    
    init(gmapView: UIView) {
        self.gmapView = gmapView
    }
    
    private func initialiseMapApiKey() {
        apikey = "AIzaSyC8sP7KP26PyVtTKSFjZaXab0_o9qMyoA8"
        GMSServices.provideAPIKey(apikey)
    }
    
    
    // MARK: TODO: This Method For Create Anotations on Map.
    func CreateAnnotations (long: Double, latit: Double,zoom: Float,Arr: [responseModel]) {
            
        initialiseMapApiKey()
        
        // Creates a marker in the center of the map.
        camera = GMSCameraPosition.camera(withLatitude: latit, longitude: long, zoom: zoom)
        mapView = GMSMapView.map(withFrame: gmapView.frame, camera: camera!)
        var bounds = GMSCoordinateBounds()
        GoogleMap.markers.removeAll()
        
        for i in Arr {
            let marker = GMSMarker()
            marker.position = CLLocationCoordinate2D(latitude: i.location.lati , longitude: i.location.long)
            marker.title = i.name
            
            // marker.snippet = i.shopDescribtion
            
            marker.map = mapView
            bounds = bounds.includingCoordinate(marker.position)
            GoogleMap.markers.append(marker)
        }
        
        let update = GMSCameraUpdate.fit(bounds, withPadding: 100)
        mapView!.animate(with: update)
        // mapView.animate(toZoom: zoom)
        
        mapView?.mapType = .satellite
        mapView?.frame = gmapView.bounds
        mapView!.autoresizingMask = [.flexibleWidth,.flexibleHeight]
        gmapView.addSubview(mapView!)
        
    }
    // ------------------------------------------------
    
    func updateMapLocation(lattitude:CLLocationDegrees,longitude:CLLocationDegrees, marker: GMSMarker){        
        let camera = GMSCameraPosition.camera(withLatitude: lattitude, longitude: longitude, zoom: 16)
        mapView?.camera = camera
        mapView?.animate(to: camera)
        
        CATransaction.begin()
        CATransaction.setAnimationDuration(2.0)
        marker.position = CLLocationCoordinate2D.init(latitude: lattitude, longitude: longitude) // CLLocationCoordinate2D coordinate
        CATransaction.commit()
        
        marker.map = self.mapView
        
    }
    
    
    func DrawLineBetweenTwoPoints() {
        
    }
    
    
    
}
