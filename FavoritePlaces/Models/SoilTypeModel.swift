//
//  SoilTypeModel.swift
//  FavoritePlaces
//
//  Created by Tri Pham on 4/21/23.
//

import Foundation
import MapKit

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

extension MKMultiPolygon {
    struct ColorHolder {
        static var _color: UIColor = .red
    }
    var color: UIColor? {
        get {
            return ColorHolder._color
        }
        set(newValue) {
            ColorHolder._color = newValue ?? .red
        }
    }
}
