//
//  MKCoordinateRegion.swift
//  FavoritePlaces
//
//  Created by Tri Pham on 3/7/23.
//

import Foundation
import MapKit

extension MKCoordinateRegion {
    static var defaultRegion: MKCoordinateRegion {
        return MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: 21.030,longitude: 105.847),
            span: MKCoordinateSpan(latitudeDelta: 0.1,longitudeDelta: 0.1))
    }
}
