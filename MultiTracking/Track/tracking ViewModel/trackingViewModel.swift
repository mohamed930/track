//
//  trackingViewModel.swift
//  MultiTracking
//
//  Created by Mohamed Ali on 26/11/2022.
//

import Foundation
import RxCocoa
import RxSwift
import FirebaseDatabase
import GoogleMaps

class trackingViewModel {
    
    var firebase = Firebase()
    
    private var pointsBehaviour = BehaviorRelay<([responseModel],String)>(value: ([],""))
    var pointsBehaviourObserval: Observable<([responseModel],String)> {
        return pointsBehaviour.asObservable()
    }
    
    var oldpoints = BehaviorRelay<[responseModel]>(value: [])
    
    func SetPointOperation() {
        firebase.SetRefernce(ref: Database.database().reference().child("points").child("points").child("target"))
        firebase.observerDataWithoutListner { [weak self] snapshot in
            guard let self = self else {return}
            
            guard snapshot.exists() else {return}
            
            guard let value = snapshot.value else {return}
            
            guard let jsonData = try? JSONSerialization.data(withJSONObject: value, options: []) else {return}
            
            guard let responseObj = try? JSONDecoder().decode(responseModel.self, from: jsonData) else {return}
            
            self.pointsBehaviour.accept(([responseObj],"new"))
            
            self.SetVehiclesPointsOperation()
        }
    }
    
    func SetVehiclesPointsOperation() {
        firebase.SetRefernce(ref: Database.database().reference().child("points").child("points").child("vehicals"))
        firebase.observeDataWithListner { [weak self] snapshot in
            guard let self = self else { return }
            
            guard snapshot.exists() else {
                print("not exisit")
                return}
            
            guard let value = snapshot.value else {
                print("there is no value")
                return}
            
            guard let jsonData = try? JSONSerialization.data(withJSONObject: value, options: []) else {
                print("can't serialization")
                return}
            
            guard var responseObj = try? JSONDecoder().decode([responseModel].self, from: jsonData) else {
                print("Can't parse")
                return}
            
            if (self.pointsBehaviour.value.0.count > 1) {
                let arr = self.pointsBehaviour.value
                
                responseObj.insert(arr.0[0], at: 0)
                
                self.pointsBehaviour.accept((responseObj,"old"))
            }
            else {
                let arr = self.pointsBehaviour.value
                
                responseObj.insert(arr.0[0], at: 0)
                
                self.pointsBehaviour.accept((responseObj,"new"))
                self.oldpoints.accept(responseObj)
            }
            
            
        }
    }
    
    func ShowMap(view: UIView) {
        let googleMap = GoogleMap(gmapView: view)
        
        if (!pointsBehaviour.value.0.isEmpty) {
            googleMap.CreateAnnotations(long: pointsBehaviour.value.0[0].location.long, latit: pointsBehaviour.value.0[0].location.lati, zoom: 5, Arr: pointsBehaviour.value.0)
        }
    }
    
    func updateMap(view: UIView) {
        let googleMap = GoogleMap(gmapView: view)
        
        if (!pointsBehaviour.value.0.isEmpty) {
            
            for i in 0..<self.pointsBehaviour.value.0.count {
                let marker = self.pointsBehaviour.value.0[i]
                if (GoogleMap.markers[i].position.latitude != marker.location.lati && GoogleMap.markers[i].position.latitude != marker.location.long) {
                    GoogleMap.markers[i] = GMSMarker(position: CLLocationCoordinate2D(latitude: marker.location.lati, longitude: marker.location.long))

                    googleMap.playAnimation(marker: GoogleMap.markers[i], oldposition: CLLocationCoordinate2D(latitude: self.oldpoints.value[i].location.lati, longitude: self.oldpoints.value[i].location.lati), position: CLLocationCoordinate2D(latitude: marker.location.lati, longitude: marker.location.long))
                }
                else
                {
                    continue;
                }

            }
            
            self.oldpoints.accept(self.pointsBehaviour.value.0)
        }
    }
}
