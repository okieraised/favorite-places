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
    
    func makeUIView(context: Context) -> some UIView {
        mapView.delegate = context.coordinator
        mapView.isRotateEnabled = false
        mapView.showsUserLocation = true
        mapView.userTrackingMode = .follow
        mapView.showsCompass = true
        mapView.showsScale = true
//        mapView.mapType = .satellite
        
        return mapView
    }
    
    func updateUIView(_ uiView: UIViewType, context: Context) {
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
           print("didSelectAnnotationTapped")
           guard let annotation = view.annotation as? AnnotationViewModel else {
               return
           }
           
           print("didSelectAnnotationTapped 2")
           
           
           view.canShowCallout = true
//           var mapAnnoView = MapAnnotation(coordinate: annotation.coordinate) {
//               HStack {
//                   Image(systemName: "mappin.circle.fill")
//                       .font(.system(size: 12))
//                       .foregroundColor(.red)
//                   Text(annotation.address)
//                       .minimumScaleFactor(0.1)
//                       .font(.system(size: 12))
//               }
//               .padding(10)
//               .background(.white.opacity(0.5))
//               .clipShape(RoundedRectangle(cornerRadius: 25, style: .continuous))
//           }
           
//           var child = UIHostingController(rootView: PlaceCalloutView())
//
//           var parent = UIViewController()
//           child.view.translatesAutoresizingMaskIntoConstraints = false
//           child.view.frame = parent.view.bounds
           
           
           
//           view.detailCalloutAccessoryView = PlaceCalloutView(annotation: annotation, selectShowDirections: { [weak self] place in
//
//               let start = MKMapItem.forCurrentLocation()
//               let destination = MKMapItem(placemark: MKPlacemark(coordinate: place.coordinate))
//
//               self?.calculateRoute(start: start, destination: destination) { route in
//                   if let route = route {
//
//                       view.detailCalloutAccessoryView = nil
//
//                       let controller = RouteContentViewController(route: route)
//                       let routePopover = RoutePopover(controller: controller)
//
//                       let positioningView = NSView(frame: NSRect(x: mapView.frame.width/2.6, y: 0, width: mapView.frame.width/2, height: 30.0))
//
//                       mapView.addSubview(positioningView)
//
//                       // clear all overlays
//                       mapView.removeOverlays(mapView.overlays)
//
//                       // add overlay on the map
//                       mapView.addOverlay(route.polyline, level: .aboveRoads)
//
//                       routePopover.show(relativeTo: positioningView.frame, of: positioningView, preferredEdge: .minY)
//
//                   }
//               }
//
//           })
           
//           print("didSelectAnnotationTapped")
       }

        
        
        // MARK: - Helpers
        
        func configurePolyineToPickupLocation(withRoute route: MKRoute) {
            self.parent.mapView.addOverlay(route.polyline)
            let rect = self.parent.mapView.mapRectThatFits(route.polyline.boundingMapRect,
                                                           edgePadding: .init(top: 88, left: 32, bottom: 360, right: 32))
            self.parent.mapView.setRegion(MKCoordinateRegion(rect), animated: true)
        }
        
        func addAndSelectAnnotations(withLandmarks landmarks: [LandmarkViewModel]) {
            parent.mapView.removeAnnotations(parent.mapView.annotations)
            
            var annos = [MKPointAnnotation]()
            
            for landmark in landmarks {
                let anno = MKPointAnnotation()

//                print("title", landmark.title)
//                print("countryCode", landmark.countryCode)
//                print("description", landmark.description)
//                print("name", landmark.name)
                
                
                anno.title = landmark.name
                anno.subtitle = landmark.title
                anno.coordinate = landmark.coordinate
                annos.append(anno)
            }
//            parent.mapView.
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
            guard let userLocationCoordinate = self.userLocationCoordinate else { return }

            parent.homeViewModel.getDestinationRoute(from: userLocationCoordinate,
                                                         to: coordinate) { route in
                self.parent.mapView.addOverlay(route.polyline)
                self.parent.mapState = .polylineAdded
                let rect = self.parent.mapView.mapRectThatFits(route.polyline.boundingMapRect,
                                                               edgePadding: .init(top: 64, left: 32, bottom: 500, right: 32))
                self.parent.mapView.setRegion(MKCoordinateRegion(rect), animated: true)
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

