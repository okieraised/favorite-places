//
//  HarborModel.swift
//  FavoritePlaces
//
//  Created by Tri Pham on 4/21/23.
//

import Foundation
import MapKit

struct HarborInfo: Codable {
    let name: String
    let type: String
    let code: String
    

    enum CodingKeys: String, CodingKey {
        case name = "Name"
        case type = "Type"
        case code = "f_code"
    }
}

struct HarborOverlayer {
    var overlay: MKOverlay
    var polygonInfo: HarborInfo
}

class HarborOverlays {
    private var overlayList = [HarborOverlayer]()
    static var shared = HarborOverlays()
    
    func addOverlay(harborOverlayer: HarborOverlayer) {
        HarborOverlays.shared.overlayList.append(harborOverlayer)
    }
    
    func returnOverlayList() -> [HarborOverlayer] {
        return HarborOverlays.shared.overlayList
    }
}

