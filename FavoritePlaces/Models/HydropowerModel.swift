//
//  HydropowerModel.swift
//  FavoritePlaces
//
//  Created by Tri Pham on 4/21/23.
//

import Foundation
import MapKit

struct HydropowerInfo: Codable {
    let name: String
    let enName: String
    let wattage: Float
    let operation: String?
    let laidDown: String?
    let quantity: Float?
    

    enum CodingKeys: String, CodingKey {
        case name = "Vietnamese"
        case enName = "English_hy"
        case wattage = "Wattage_PL"
        case operation = "Year_of_op"
        case laidDown = "Year_of_la"
        case quantity = "Quantity"
    }
}

struct HydropowerOverlayer {
    var overlay: MKOverlay
    var polygonInfo: HydropowerInfo
}

class HydropowerOverlays {
    private var overlayList = [HydropowerOverlayer]()
    static var shared = HydropowerOverlays()
    
    func addOverlay(hydropowerOverlayer: HydropowerOverlayer) {
        HydropowerOverlays.shared.overlayList.append(hydropowerOverlayer)
    }
    
    func returnOverlayList() -> [HydropowerOverlayer] {
        return HydropowerOverlays.shared.overlayList
    }
}
