//
//  Firebase.swift
//  MultiTracking
//
//  Created by Mohamed Ali on 26/11/2022.
//

import Foundation
import FirebaseCore
import FirebaseDatabase

class Firebase {
    
    private var ref:DatabaseReference?
    
    
    func SetRefernce(ref: DatabaseReference) {
        self.ref = ref
    }
    
     func observeData(event: DataEventType = .value, completion: @escaping (DataSnapshot) -> Void) {
         
         ref?.observe(event, with: completion)
     }
}
