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
            center: CLLocationCoordinate2D(latitude: 29.726819,longitude: -95.393692),
            span: MKCoordinateSpan(latitudeDelta: 0.1,longitudeDelta: 0.1))
    }
}
