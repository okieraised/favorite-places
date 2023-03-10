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
//    let placemark: MKAnnotation
    
    let id = UUID()
    
//    var title: String {
//        (placemark.title ?? "") ?? ""
//    }
//
//    var subtitle: String {
//        (placemark.subtitle ?? "") ?? ""
//    }
//
//    var description: String {
//        placemark.description
//    }
//
//    var coordinate: CLLocationCoordinate2D {
//        placemark.coordinate
//    }

    var name: String {
        placemark.name ?? ""
    }

    var title: String {
        placemark.title ?? ""
    }
    
    var description: String {
        placemark.description
    }
    
    var location: CLLocation {
        placemark.location ?? CLLocation(latitude: 0, longitude: 0)
    }
    
    var countryCode: String {
        placemark.countryCode ?? ""
    }
    
    
    
    


    var coordinate: CLLocationCoordinate2D {
        placemark.coordinate
    }
}
