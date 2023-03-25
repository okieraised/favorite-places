//
//  HomeViewModel.swift
//  FavoritePlaces
//
//  Created by Tri Pham on 3/6/23.
//

import SwiftUI
import Combine
import MapKit

enum LocationResultsViewConfig {
    case picked
    case saveLocation(SavedLocationViewModel)
}

class HomeViewModel: NSObject, ObservableObject {
    
    // MARK: - Properties
    
    @Published var results = [MKLocalSearchCompletion]()
    @Published var selectedLocation: Location?
    @Published var landmarks: [LandmarkViewModel] = []
    private let searchCompleter = MKLocalSearchCompleter()
    var userLocation: CLLocationCoordinate2D?
    var directionSteps: [String]?
        
    var queryFragment: String = "" {
        didSet {
            searchCompleter.queryFragment = queryFragment
        }
    }
    
    // MARK: - Lifecycle
    
    override init() {
        super.init()
        searchCompleter.delegate = self
        searchCompleter.queryFragment = queryFragment
    }
}

// MARK: - Location Search Helpers

extension HomeViewModel {
    
    func getPlacemark(forLocation location: CLLocation, completion: @escaping(CLPlacemark?, Error?) -> Void) {
        CLGeocoder().reverseGeocodeLocation(location) { placemarks, error in
            if let error = error {
                completion(nil, error)
                return
            }
            
            guard let placemark = placemarks?.first else { return }
            completion(placemark, nil)
        }
    }
    
    func selectLocation(_ localSearch: MKLocalSearchCompletion, config: LocationResultsViewConfig) {
        locationSearch(forLocalSearchCompletion: localSearch) { response, error in
            if let error = error {
                print("DEBUG: Location search failed with error \(error.localizedDescription)")
                return
            }

            guard let item = response?.mapItems.first else { return }
            let coordinate = item.placemark.coordinate

            switch config {
            case .picked:
                self.selectedLocation = Location(title: localSearch.title, coordinate: coordinate)
            case .saveLocation(let viewModel):
                break
            }
        }
    }
    
    func selectLocations(location: CLLocation, searchTerm: String) {
        landmarkSearch(location: location, searchTerm: searchTerm)
    }

    func locationSearch(forLocalSearchCompletion localSearch: MKLocalSearchCompletion,
                        completion: @escaping MKLocalSearch.CompletionHandler) {
        let searchRequest = MKLocalSearch.Request()
        searchRequest.naturalLanguageQuery = localSearch.title.appending(localSearch.subtitle)
        let search = MKLocalSearch(request: searchRequest)
        
        search.start(completionHandler: completion)
    }
    
    func poiSearch(annotation: MKMapFeatureAnnotation, completion: @escaping (CustomAnnotation) -> ()) {
        let request = MKMapItemRequest(mapFeatureAnnotation: annotation)
        request.getMapItem { mapItem, error in
            if let error = error {
                print("DEBUG: Feature location search failed with error \(error.localizedDescription)")
                return
            }

            if let mapItem {
                let anno = CustomAnnotation(coordinate: annotation.coordinate)
                anno.name = mapItem.name ?? ""
                anno.title = mapItem.name ?? ""
                anno.subtitle = mapItem.placemark.title ?? ""
                anno.phoneNumber = mapItem.phoneNumber ?? ""
                completion(anno)
            }
        }
    }
    
    func landmarkSearch(location: CLLocation, searchTerm: String) {
       
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
                let mapItems = response.mapItems
                self.landmarks = mapItems.map {
                    return LandmarkViewModel(placemark: $0)
                }
            }
        }
    }
    
    
    func getDestinationRoute(from userLocation: CLLocationCoordinate2D,
                             to destination: CLLocationCoordinate2D, completion: @escaping(MKRoute) -> Void) {
        let userPlacemark = MKPlacemark(coordinate: userLocation)
        let destPlacemark = MKPlacemark(coordinate: destination)
        let request = MKDirections.Request()
        request.source = MKMapItem(placemark: userPlacemark)
        request.destination = MKMapItem(placemark: destPlacemark)
        
        let userLocation = CLLocation(latitude: userPlacemark.coordinate.latitude,
                                      longitude: userPlacemark.coordinate.longitude)
        let destination = CLLocation(latitude: destPlacemark.coordinate.latitude,
                                     longitude: destPlacemark.coordinate.longitude)
        
        
        let tripDistanceInMeters = userLocation.distance(from: destination)
        if tripDistanceInMeters > 500 {
            request.transportType = .walking
        } else {
            request.transportType = .automobile
        }
        
        let directions = MKDirections(request: request)
        
        directions.calculate { response, error in
            if let error = error {
                print("DEBUG: Failed to get directions with error \(error.localizedDescription)")
                return
            }
            
            guard let route = response?.routes.first else { return }
            completion(route)
        }
    }
}

// MARK: - MKLocalSearchCompleterDelegate

extension HomeViewModel: MKLocalSearchCompleterDelegate {
    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        self.results = completer.results
    }
}

