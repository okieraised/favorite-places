//
//  TransportationModel.swift
//  FavoritePlaces
//
//  Created by Tri Pham on 4/21/23.
//

import Foundation
import MapKit

struct TransportationInfo: Codable {
    let name: String
    let type: String
    let length: Float
    let level: String
    

    enum CodingKeys: String, CodingKey {
        case name = "Name"
        case type = "Type"
        case length = "Length"
        case level = "Level"
    }
}

struct TransportationOverlayer {
    var overlay: MKOverlay
    var polygonInfo: TransportationInfo
}

class TransportationOverlays {
    private var overlayList = [TransportationOverlayer]()
    static var shared = TransportationOverlays()
    
    func addOverlay(transportationOverlayer: TransportationOverlayer) {
        TransportationOverlays.shared.overlayList.append(transportationOverlayer)
    }
    
    func returnOverlayList() -> [TransportationOverlayer] {
        return TransportationOverlays.shared.overlayList
    }
}
