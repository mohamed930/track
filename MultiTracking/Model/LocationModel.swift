//
//  LocationModel.swift
//  MultiTracking
//
//  Created by Mohamed Ali on 26/11/2022.
//

import Foundation

struct responseModel: Codable {
    var name: String
    var location: locationModel
}

struct locationModel: Codable {
    var lati: Double
    var long: Double
}
