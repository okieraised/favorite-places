//
//  MapViewRepresentable.swift
//  FavoritePlaces
//
//  Created by Tri Pham on 3/1/23.
//

import SwiftUI
import MapKit

struct MapViewRepresentable: UIViewRepresentable {
    
    let mapView = MKMapView()
    @Binding var mapState: MapViewState
    @EnvironmentObject var homeViewModel: HomeViewModel
    @EnvironmentObject var mapSettings: MapSettings
    
    func makeUIView(context: Context) -> some UIView {
        mapView.delegate = context.coordinator
        mapView.showsUserLocation = true
        mapView.userTrackingMode = .follow
        mapView.showsScale = true
        mapView.showsCompass = true
        mapView.isZoomEnabled = true
        mapView.isScrollEnabled = true
        mapView.isRotateEnabled = true
        
        let scale = MKScaleView(mapView: mapView)
        scale.scaleVisibility = .visible // always visible
        scale.frame = CGRect(x: UIScreen.main.bounds.width -  100, y: 0, width: 100, height: UIScreen.main.bounds.height - UIScreen.main.bounds.height * 1/15)
        mapView.addSubview(scale)
        
        let compass = MKCompassButton(mapView: mapView)
        compass.compassVisibility = .visible
        compass.frame.origin = CGPoint(x: UIScreen.main.bounds.width / 2 + 140, y: UIScreen.main.bounds.height / 2)
        mapView.addSubview(compass)
        
        return mapView
    }
    
    func updateUIView(_ uiView: UIViewType, context: Context) {
        updateMapType(uiView as! MKMapView)
        
        switch mapState {
        case .noInput:
            context.coordinator.clearMapViewAndRecenterOnUserLocation()
            break
        case .searchingForLocation:
            break
        case .categorySelected:
            let landmarks = homeViewModel.landmarks
            context.coordinator.addAndSelectAnnotations(withLandmarks: landmarks)
            break
        case .locationSelected:
            if let coordinate = homeViewModel.selectedLocation?.coordinate {
                context.coordinator.addAndSelectAnnotation(withCoordinate: coordinate)
                context.coordinator.configurePolyline(withDestinationCoordinate: coordinate)
            }
            break
        case .polylineAdded:
            break
        default:
            break
        }
    }
    
    private func updateMapType(_ uiView: MKMapView) {
        switch mapSettings.mapType {
        case 0:
            uiView.preferredConfiguration = MKStandardMapConfiguration(elevationStyle: elevationStyle(), emphasisStyle: emphasisStyle())
        case 1:
            uiView.preferredConfiguration = MKHybridMapConfiguration(elevationStyle: elevationStyle())
        case 2:
            uiView.preferredConfiguration = MKImageryMapConfiguration(elevationStyle: elevationStyle())
        default:
            break
        }
    }
        
    private func elevationStyle() -> MKMapConfiguration.ElevationStyle {
        if mapSettings.showElevation == 0 {
            return MKMapConfiguration.ElevationStyle.realistic
        } else {
            return MKMapConfiguration.ElevationStyle.flat
        }
    }
    
    private func emphasisStyle() -> MKStandardMapConfiguration.EmphasisStyle {
        if mapSettings.showEmphasisStyle == 0 {
            return MKStandardMapConfiguration.EmphasisStyle.default
        } else {
            return MKStandardMapConfiguration.EmphasisStyle.muted
        }
    }
    
    
    
    func makeCoordinator() -> MapCoordinator {
        return MapCoordinator(parent: self)
    }
}

extension MapViewRepresentable {
    
    class MapCoordinator: NSObject, MKMapViewDelegate {
        
        // MARK: - Properties
        let parent: MapViewRepresentable
        var userLocationCoordinate: CLLocationCoordinate2D?
        var currentRegion: MKCoordinateRegion?
        var directions: [String]?
        
        
        // MARK: - Lifecycle
        init(parent: MapViewRepresentable) {
            self.parent = parent
            super.init()
        }
        
        
        // MARK: - MKMapViewDelegate
        func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
            self.userLocationCoordinate = userLocation.coordinate
            let region = MKCoordinateRegion(
                center: CLLocationCoordinate2D(latitude: userLocation.coordinate.latitude,
                                               longitude: userLocation.coordinate.longitude),
                span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
            )
            self.currentRegion = region
            parent.mapView.setRegion(region, animated: true)
            
//            let scale = MKScaleView(mapView: mapView)
//            scale.scaleVisibility = .visible // always visible
//            parent.mapView.addSubview(scale)
        }
        
        func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
            let polyline = MKPolylineRenderer(overlay: overlay)
            polyline.strokeColor = .systemBlue
            polyline.lineWidth = 6
            return polyline
        }
        
        func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
              print("calloutAccessoryControlTapped")
           }
        
        func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
            view.displayPriority = MKFeatureDisplayPriority.required
            view.canShowCallout = true
            guard let annotation = view.annotation as? CustomAnnotation else {
                return
            }
            
            let vc = UIHostingController(rootView: PlaceCalloutView(annotation: annotation))
            let detailView = vc.view!
            detailView.translatesAutoresizingMaskIntoConstraints = false
            detailView.backgroundColor = view.backgroundColor
            
            parent.mapView.inputViewController?.addChild(vc)
            parent.mapView.removeOverlays(parent.mapView.overlays)
            view.detailCalloutAccessoryView = detailView
            configurePolyline(withDestinationCoordinate: annotation.coordinate)
       }

        
        
        // MARK: - Helpers
        
        func addAndSelectAnnotations(withLandmarks landmarks: [LandmarkViewModel]) {
            parent.mapView.removeAnnotations(parent.mapView.annotations)
            
            var annos = [CustomAnnotation]()
            
            for landmark in landmarks {
                let anno = CustomAnnotation(coordinate: landmark.coordinate)
                anno.name = landmark.name
                anno.title = landmark.name
                anno.subtitle = landmark.title
                anno.phoneNumber = landmark.phoneNumber
                annos.append(anno)
            }
            parent.mapView.addAnnotations(annos)
        }
        
        func addAndSelectAnnotation(withCoordinate coordinate: CLLocationCoordinate2D) {
            parent.mapView.removeAnnotations(parent.mapView.annotations)
            
            let anno = MKPointAnnotation()
            anno.coordinate = coordinate
            parent.mapView.addAnnotation(anno)
            parent.mapView.selectAnnotation(anno, animated: true)
        }
        
        func configurePolyline(withDestinationCoordinate coordinate: CLLocationCoordinate2D) {
            guard let userLocationCoordinate = self.userLocationCoordinate else {
                return
            }

            parent.homeViewModel.getDestinationRoute(from: userLocationCoordinate,
                                                         to: coordinate) { route in
                self.parent.mapView.addOverlay(route.polyline)
                self.parent.mapState = .polylineAdded
                let rect = self.parent.mapView.mapRectThatFits(route.polyline.boundingMapRect,
                                                               edgePadding: .init(top: 64, left: 32, bottom: 500, right: 32))
                self.parent.mapView.setRegion(MKCoordinateRegion(rect), animated: true)
                self.directions = route.steps.map { $0.instructions }.filter { !$0.isEmpty }
                
                print(route.steps.map { $0.instructions }.filter { !$0.isEmpty })
                print(route.distance, route.expectedTravelTime, route.advisoryNotices, route.hasHighways)
                
                
            }
        }
        
        func clearMapViewAndRecenterOnUserLocation() {
            parent.mapView.removeAnnotations(parent.mapView.annotations)
            parent.mapView.removeOverlays(parent.mapView.overlays)
            
            if let currentRegion = currentRegion {
                parent.mapView.setRegion(currentRegion, animated: true)
            }
        }
        
        
    }
}

