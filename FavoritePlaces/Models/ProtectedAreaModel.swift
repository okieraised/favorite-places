//
//  ProtectedAreaModel.swift
//  FavoritePlaces
//
//  Created by Tri Pham on 4/21/23.
//

import Foundation
import MapKit

struct ProtectedAreaInfo: Codable {
    let category: String
    let name, status: String
    let proposed: String
    let level: String
    let owner, manager: String
    

    enum CodingKeys: String, CodingKey {
        case category = "IUCN_CAT"
        case name = "Name"
        case status = "Status"
        case proposed = "Status_yr"
        case level = "Design_typ"
        case owner = "Own_type"
        case manager = "Gov_Type"
    }
}

struct ProtectedAreaOverlayer {
    var overlay: MKOverlay
    var polygonInfo: ProtectedAreaInfo
}

class ProtectedAreaOverlays {
    private var overlayList = [ProtectedAreaOverlayer]()
    static var shared = ProtectedAreaOverlays()
    
    func addOverlay(protectedAreaOverlayer: ProtectedAreaOverlayer) {
        ProtectedAreaOverlays.shared.overlayList.append(protectedAreaOverlayer)
    }
    
    func returnOverlayList() -> [ProtectedAreaOverlayer] {
        return ProtectedAreaOverlays.shared.overlayList
    }
}
