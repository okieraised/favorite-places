//
//  AirportModel.swift
//  FavoritePlaces
//
//  Created by Tri Pham on 4/21/23.
//

import Foundation
import MapKit

struct AirportInfo: Codable {
    let name: String
    let type: String
    let iata: String
    let icao: String
    let city: String
    let length: Float

    enum CodingKeys: String, CodingKey {
        case name = "Name"
        case type = "Type"
        case iata = "IATA"
        case icao = "ICAO_"
        case city = "City"
        case length = "Length_m"
    }
}

struct AirportOverlayer {
    var overlay: MKOverlay
    var polygonInfo: HarborInfo
}

class AirportOverlays {
    private var overlayList = [AirportOverlayer]()
    static var shared = AirportOverlays()
    
    func addOverlay(airportOverlayer: AirportOverlayer) {
        AirportOverlays.shared.overlayList.append(airportOverlayer)
    }
    
    func returnOverlayList() -> [AirportOverlayer] {
        return AirportOverlays.shared.overlayList
    }
}


