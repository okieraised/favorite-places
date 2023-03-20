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
    
    // MARK: - Helpers
    
    func viewForState(_ state: MapViewState) -> some View {
        switch state {
        case .polylineAdded, .locationSelected, .searchingForLocation:
            break
        default:
            break
        }

        return AnyView(Text(""))
    }
    

}

// MARK: - Location Search Helpers

extension HomeViewModel {
    
    func addressFromPlacemark(_ placemark: CLPlacemark) -> String {
        var result = ""
        
        if let thoroughfare = placemark.thoroughfare {
            result += thoroughfare
        }
        
        if let subthoroughfare = placemark.subThoroughfare {
            result += " \(subthoroughfare)"
        }
        
        if let subadministrativeArea = placemark.subAdministrativeArea {
            result += ", \(subadministrativeArea)"
        }
        
        return result
    }
    
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

