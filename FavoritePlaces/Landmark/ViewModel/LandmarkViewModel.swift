//
//  LandmarkViewModel.swift
//  FavoritePlaces
//
//  Created by Tri Pham on 3/7/23.
//

import Foundation
import MapKit
import Contacts


struct LandmarkViewModel: Identifiable {
    
    let placemark: MKPlacemark
    
    let id = UUID()
    
    var name: String {
        placemark.name ?? ""
    }
    
    var title: String {
        placemark.title ?? ""
    }
    
    
    var coordinate: CLLocationCoordinate2D {
        placemark.coordinate
    }
}
