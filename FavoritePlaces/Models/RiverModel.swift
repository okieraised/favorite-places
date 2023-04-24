//
//  RiverModel.swift
//  FavoritePlaces
//
//  Created by Tri Pham on 4/21/23.
//

import Foundation
import MapKit

struct RiverInfo: Codable {
    let name: String
    let length: Float
    let strahler: Int
    

    enum CodingKeys: String, CodingKey {
        case name = "Name"
        case length = "Length"
        case strahler = "Strahler"
    }
}

struct RiverOverlayer {
    var overlay: MKOverlay
    var polygonInfo: RiverInfo
}


class RiverOverlays {
    private var overlayList = [RiverOverlayer]()
    static var shared = RiverOverlays()
    
    func addOverlay(riverOverlayer: RiverOverlayer) {
        RiverOverlays.shared.overlayList.append(riverOverlayer)
    }
    
    func returnOverlayList() -> [RiverOverlayer] {
        return RiverOverlays.shared.overlayList
    }
}
