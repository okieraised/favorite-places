//
//  GeoJSONModel.swift
//  FavoritePlaces
//
//  Created by Tri Pham on 4/13/23.
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
        case name = "Ten"
        case status = "Trang_Thai"
        case proposed = "Nam_Dexuat"
        case level = "Cap_BT"
        case owner = "So_huu"
        case manager = "Quan_Ly"
    }
}

struct ProtectedAreaOverlayer {
    var overlay: MKOverlay
    var polygonInfo: ProtectedAreaInfo
}
