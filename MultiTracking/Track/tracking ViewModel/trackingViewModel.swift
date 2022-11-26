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

class trackingViewModel {
    
    var firebase = Firebase()
    
    private var pointsBehaviour = BehaviorRelay<[responseModel]>(value: [])
    var pointsBehaviourObserval: Observable<[responseModel]> {
        return pointsBehaviour.asObservable()
    }
    
    func SetPointOperation() {
        firebase.SetRefernce(ref: Database.database().reference().child("points").child("points").child("target"))
        firebase.observerDataWithoutListner { [weak self] snapshot in
            guard let self = self else {return}
            
            guard snapshot.exists() else {return}
            
            guard let value = snapshot.value else {return}
            
            guard let jsonData = try? JSONSerialization.data(withJSONObject: value, options: []) else {return}
            
            guard let responseObj = try? JSONDecoder().decode(responseModel.self, from: jsonData) else {return}
            
            self.pointsBehaviour.accept([responseObj])
        }
    }
    
    func ShowMap(view: UIView) {
        let googleMap = GoogleMap(gmapView: view)
        
        if (!pointsBehaviour.value.isEmpty) {
            googleMap.CreateAnnotations(long: pointsBehaviour.value[0].location.long, latit: pointsBehaviour.value[0].location.lati, zoom: 18, Arr: pointsBehaviour.value)
        }
    }
}
