//
//  PlaceListViewModel.swift
//  FavoritePlaces
//
//  Created by Tri Pham on 3/7/23.
//

import Foundation
import Combine
import MapKit
import SwiftUI

class PlaceListViewModel: ObservableObject {
    
    private let locationManager: LocationManager
    var cancellable: AnyCancellable?
    @Published var currentLocation: CLLocationCoordinate2D?
    @Published var landmarks: [LandmarkViewModel] = []
    
    init() {
        
        locationManager = LocationManager()
        cancellable = locationManager.$location.sink { (location) in
            if let location = location {
                DispatchQueue.main.async {
                    self.currentLocation = location.coordinate
                    self.locationManager.stopUpdates()
                }
            }
            
        }
    }
    
    func startUpdatingLocation() {
        locationManager.startUpdates()
    }
    
    func searchLandmarks(searchTerm: String) {
        guard let location = self.locationManager.location else {
            return
        }
        
        
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = searchTerm
        request.region = MKCoordinateRegion(
            center: location.coordinate,
            latitudinalMeters: 100000,
            longitudinalMeters: 100000
        )
        
        
        
        
        let search = MKLocalSearch(request: request)
        search.start { (response, error) in
            if let error = error {
                print(error)
            } else if let response = response {
                print(response)
                let mapItems = response.mapItems
                self.landmarks = mapItems.map {
                    return LandmarkViewModel(placemark: $0.placemark)
                }
            }
        }
    }
}
