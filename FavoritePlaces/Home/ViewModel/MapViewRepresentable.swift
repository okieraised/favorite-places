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
    let configuration = MKStandardMapConfiguration()
    @Binding var mapState: MapViewState
    @EnvironmentObject var homeViewModel: HomeViewModel
    @EnvironmentObject var mapSettings: MapSettings
    
    private enum AnnotationReuseID: String {
        case featureAnnotation
    }
    
    func makeUIView(context: Context) -> some UIView {
        mapView.delegate = context.coordinator
        mapView.showsUserLocation = true
        mapView.userTrackingMode = .follow
        mapView.showsScale = true
        mapView.showsCompass = true
        mapView.isZoomEnabled = true
        mapView.isScrollEnabled = true
        mapView.isRotateEnabled = true
        mapView.selectableMapFeatures = [.pointsOfInterest, .physicalFeatures, .territories]
        mapView.isPitchEnabled = true
        
        let scale = MKScaleView(mapView: mapView)
        scale.scaleVisibility = .adaptive
        scale.frame.origin = CGPoint(x: scale.frame.maxX + 80, y: scale.frame.maxY + 700)
        mapView.addSubview(scale)
    
        let compass = MKCompassButton(mapView: mapView)
        compass.compassVisibility = .adaptive
        compass.frame.origin = CGPoint(x: compass.frame.maxX + 290, y: compass.frame.maxY + 400)
        mapView.addSubview(compass)
        
//        let userTrackingButton = MKUserTrackingButton(mapView: mapView)
//        userTrackingButton.frame.origin = CGPoint(x: userTrackingButton.frame.maxX + 300, y: userTrackingButton.frame.maxY + 470)
//        userTrackingButton.layer.backgroundColor = UIColor(white: 1, alpha: 0.8).cgColor
//        userTrackingButton.layer.borderColor = UIColor.white.cgColor
//        userTrackingButton.layer.borderWidth = 1
//        userTrackingButton.layer.cornerRadius = 5
//        userTrackingButton.translatesAutoresizingMaskIntoConstraints = false
//        mapView.addSubview(userTrackingButton)
        
        mapView.register(MKMarkerAnnotationView.self, forAnnotationViewWithReuseIdentifier: AnnotationReuseID.featureAnnotation.rawValue)
        
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
            let config = MKStandardMapConfiguration(elevationStyle: elevationStyle(), emphasisStyle: emphasisStyle())
            config.showsTraffic = showTraffic()
            uiView.preferredConfiguration = config
        case 1:
            let config = MKHybridMapConfiguration(elevationStyle: elevationStyle())
            config.showsTraffic = showTraffic()
            uiView.preferredConfiguration = config
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
    
    private func showTraffic() -> Bool {
        if mapSettings.showTraffic == 0 {
            return false
        } else {
            return true
        }
    }
    
    func makeCoordinator() -> MapCoordinator {
        return MapCoordinator(parent: self)
    }
}

extension MapViewRepresentable {
    
    class MapCoordinator: NSObject, MKMapViewDelegate, UIGestureRecognizerDelegate {
        
        // MARK: - Properties
        let parent: MapViewRepresentable
        var userLocationCoordinate: CLLocationCoordinate2D?
        var currentRegion: MKCoordinateRegion?
        var directions: [String]?
        var feature: CustomAnnotation
        
        
        // MARK: - Lifecycle
        init(parent: MapViewRepresentable) {
            self.parent = parent
            self.feature = CustomAnnotation(coordinate: CLLocationCoordinate2D(latitude: 0, longitude: 0))
            let region = MKCoordinateRegion(
                center: CLLocationCoordinate2D(latitude: self.parent.mapView.userLocation.coordinate.latitude,
                                               longitude: self.parent.mapView.userLocation.coordinate.longitude),
                span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
            )
            self.currentRegion = region
            super.init()
            
        }
        
        // MARK: - MKMapViewDelegate
        func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
            
            guard let annotation = annotation as? MKMapFeatureAnnotation else {
                return nil
            }
            
            let markerAnnotationView = mapView.dequeueReusableAnnotationView(withIdentifier: AnnotationReuseID.featureAnnotation.rawValue,
                                                                             for: annotation)
            
            self.parent.homeViewModel.poiSearch(annotation: annotation, completion: { customAnnotation in
                self.feature = customAnnotation
                markerAnnotationView.displayPriority = MKFeatureDisplayPriority.required
                markerAnnotationView.canShowCallout = true
                
                let vc = UIHostingController(rootView: PlaceCalloutView(annotation: self.feature))
                let detailView = vc.view!
                detailView.translatesAutoresizingMaskIntoConstraints = false
                detailView.backgroundColor = markerAnnotationView.backgroundColor
                
                mapView.inputViewController?.addChild(vc)
                mapView.removeOverlays(mapView.overlays)
                markerAnnotationView.detailCalloutAccessoryView = detailView
                self.configurePolyline(withDestinationCoordinate: annotation.coordinate)
            })
            return markerAnnotationView
        }
        
        func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
            self.userLocationCoordinate = userLocation.coordinate
            let region = MKCoordinateRegion(
                center: CLLocationCoordinate2D(latitude: userLocation.coordinate.latitude,
                                               longitude: userLocation.coordinate.longitude),
                span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
            )
            self.currentRegion = region
//            parent.mapView.setRegion(region, animated: true)
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
            self.parent.mapState = .locationSelected
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
                
                self.parent.homeViewModel.directionSteps = self.directions
                
//                print(route.steps.map { $0.instructions }.filter { !$0.isEmpty })
//                print(route.distance, route.expectedTravelTime, route.advisoryNotices, route.hasHighways)
            }
        }
        
        func addStepView(withDirections directions: [String]?) {
            
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

