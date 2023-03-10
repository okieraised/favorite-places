//
//  Annotation.swift
//  FavoritePlaces
//
//  Created by Tri Pham on 3/10/23.
//

import Foundation
import MapKit

class CustomAnnotation: NSObject, MKAnnotation {
    var coordinate: CLLocationCoordinate2D
    var name: String?
    var title: String?
    var subtitle: String?
    var phoneNumber: String?
    var url: URL?
    var desc: String?
    var location: CLLocation?
    var countryCode: String?

    init(coordinate: CLLocationCoordinate2D) {
        self.coordinate = coordinate
    }
}
