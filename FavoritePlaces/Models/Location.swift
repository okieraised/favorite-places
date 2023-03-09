//
//  Location.swift
//  FavoritePlaces
//
//  Created by Tri Pham on 3/6/23.
//

import CoreLocation

struct Location: Identifiable {
    let id = NSUUID().uuidString
    let title: String
    let coordinate: CLLocationCoordinate2D
}
