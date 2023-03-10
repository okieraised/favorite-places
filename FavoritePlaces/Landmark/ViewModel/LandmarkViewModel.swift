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

    let placemark: MKMapItem
//    let placemark: MKMapItem // MKPlacemark
    
    let id = UUID()

    var name: String {
        placemark.name ?? ""
    }

    var title: String {
        placemark.placemark.title ?? ""
    }
    
    var phoneNumber: String {
        placemark.phoneNumber ?? ""
    }
    
    var url: URL {
        placemark.url ?? URL(string: "")!
    }
    
    var description: String {
        placemark.description
    }
    
    var location: CLLocation {
        placemark.placemark.location ?? CLLocation(latitude: 0, longitude: 0)
    }
    
    var countryCode: String {
        placemark.placemark.countryCode ?? ""
    }

    var coordinate: CLLocationCoordinate2D {
        placemark.placemark.coordinate
    }
}
