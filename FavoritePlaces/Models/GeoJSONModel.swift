//
//  GeoJSONModel.swift
//  FavoritePlaces
//
//  Created by Tri Pham on 4/13/23.
//

import Foundation
import MapKit


class overlayer {
    static var shared = overlayer(polygonInfo: SoilTypeInfo(gid: 1, domSoil: "Ao", faoSoil: "Ao90-2/3c", type: "Orthic Acrisols within 90cm, medium and fine textured, steeply dissected to mountainous"))
    
    var polygonInfo : Any
    
    init(polygonInfo: Any){
        self.polygonInfo = polygonInfo
    }
    
    func changePolygon(newPolygon: Any) {
        self.polygonInfo = newPolygon
    }
}
