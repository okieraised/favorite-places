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

//

struct SoilTypeInfo: Codable {
    let gid: Int
    let domSoil, faoSoil, type: String
    

    enum CodingKeys: String, CodingKey {
        case gid = "gid"
        case domSoil = "domsoil"
        case faoSoil = "faosoil"
        case type = "Type"
    }
}

struct SoilTypeOverlayer {
    var overlay: MKOverlay
    var polygonInfo: SoilTypeInfo
    var type: String
}

class SoilTypeOverlays {
    private var overlayList = [SoilTypeOverlayer]()
    static var shared = SoilTypeOverlays()
    
    func addOverlay(soilTypeOverlayer: SoilTypeOverlayer) {
        SoilTypeOverlays.shared.overlayList.append(soilTypeOverlayer)
    }
    
    func returnOverlayList() -> [SoilTypeOverlayer] {
        return SoilTypeOverlays.shared.overlayList
    }
}

class overlayer {
    static var shared = overlayer(polygonInfo: SoilTypeInfo(gid: 1, domSoil: "Ao", faoSoil: "Ao90-2/3c", type: "Orthic Acrisols within 90cm, medium and fine textured, steeply dissected to mountainous"))
    var polygonInfo : SoilTypeInfo
    
    init(polygonInfo: SoilTypeInfo){
        self.polygonInfo = polygonInfo
    }
    
    func changePolygon(newPolygon: SoilTypeInfo){
        self.polygonInfo = newPolygon
    }
}



//

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

struct HarborInfo: Codable {
    let name: String
    let type: String
    

    enum CodingKeys: String, CodingKey {
        case name = "Name"
        case type = "Type"
    }
}

struct HarborOverlayer {
    var overlay: MKOverlay
    var polygonInfo: HarborInfo
}

struct HydropowerInfo: Codable {
    let name: String
    let wattage: Float
    let operation: Int
    

    enum CodingKeys: String, CodingKey {
        case name = "Vietnamese"
        case wattage = "Wattage_PL"
        case operation = "Year_of_op"
    }
}

struct HydropowerOverlayer {
    var overlay: MKOverlay
    var polygonInfo: HydropowerInfo
}

