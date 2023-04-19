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
        
//        let scale = MKScaleView(mapView: mapView)
//        scale.scaleVisibility = .adaptive
//        scale.frame.origin = CGPoint(x: scale.frame.maxX + 80, y: scale.frame.maxY + 700)
//        mapView.addSubview(scale)
//
//        let compass = MKCompassButton(mapView: mapView)
//        compass.compassVisibility = .adaptive
//        compass.frame.origin = CGPoint(x: compass.frame.maxX + 290, y: compass.frame.maxY + 400)
//        mapView.addSubview(compass)
//        mapView.register(MKMarkerAnnotationView.self, forAnnotationViewWithReuseIdentifier: AnnotationReuseID.featureAnnotation.rawValue)
        
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
        case .featureSelected:
            context.coordinator.addSoilTypeLayer()
//            if let view = uiView as? MKMapView {
//
//            }
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
                
                if !customAnnotation.isGeoJSON {
                    mapView.removeOverlays(mapView.overlays)
                    markerAnnotationView.detailCalloutAccessoryView = detailView
                    self.configurePolyline(withDestinationCoordinate: annotation.coordinate)
                }
                
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
            if let multiPolygon = overlay as? MKMultiPolygon {
                let renderer = MKMultiPolygonRenderer(multiPolygon: multiPolygon)
                
                if overlayer.shared.polygonInfo.faoSoil == "Ao90-2/3c" {
                    renderer.fillColor = UIColor(red: 222/255, green: 181/255, blue: 16/255, alpha: 0.8)
                }
                
                else if overlayer.shared.polygonInfo.faoSoil == "Ao107-2bc" {
                    renderer.fillColor = UIColor(red: 2/255, green: 250/255, blue: 91/255, alpha: 0.8)
                }
                
                else if overlayer.shared.polygonInfo.faoSoil == "Je73-3a" {
                    renderer.fillColor = UIColor(red: 2/255, green: 42/255, blue: 2/255, alpha: 0.8)
                }
                
                else if overlayer.shared.polygonInfo.faoSoil == "Ge56-3a" {
                    renderer.fillColor = UIColor(red: 16/255, green: 222/255, blue: 40/255, alpha: 0.8)
                }
                
                else if overlayer.shared.polygonInfo.faoSoil == "Vp64-3a" {
                    renderer.fillColor = UIColor(red: 2/255, green: 60/255, blue: 91/255, alpha: 0.8)
                }

                else if overlayer.shared.polygonInfo.faoSoil == "Gd29-3a" {
                    renderer.fillColor = UIColor(red: 2/255, green: 90/255, blue: 88/255, alpha: 0.8)
                }
                
                else if overlayer.shared.polygonInfo.faoSoil == "I-Af-3c" {
                    renderer.fillColor = UIColor(red: 120/255, green: 116/255, blue: 116/255, alpha: 0.8)
                }
                
                else if overlayer.shared.polygonInfo.faoSoil == "Af60-1/2ab" {
                    renderer.fillColor = UIColor(red: 78/255, green: 2/255, blue: 1/255, alpha: 0.8)
                }
                
                else if overlayer.shared.polygonInfo.faoSoil == "Af61-1/2ab" {
                    renderer.fillColor = UIColor(red: 78/255, green: 15/255, blue: 1/255, alpha: 0.8)
                }
                
                else if overlayer.shared.polygonInfo.faoSoil == "Af63-3c" {
                    renderer.fillColor = UIColor(red: 225/255, green: 66/255, blue: 250/255, alpha: 0.8)
                }
                
                else if overlayer.shared.polygonInfo.faoSoil == "Ag17-1/2ab" {
                    renderer.fillColor = UIColor(red: 200/255, green: 80/255, blue: 91/255, alpha: 0.8)
                }
                
                else if overlayer.shared.polygonInfo.faoSoil == "Je72-2a" {
                    renderer.fillColor = UIColor(red: 25/255, green: 230/255, blue: 226/255, alpha: 0.8)
                }
                
                else if overlayer.shared.polygonInfo.faoSoil == "Ge55-3a" {
                    renderer.fillColor = UIColor(red: 2/255, green: 255/255, blue: 2/255, alpha: 0.8)
                }
                
                else if overlayer.shared.polygonInfo.faoSoil == "I-Lc-Bk-c" {
                    renderer.fillColor = UIColor(red: 211/255, green: 90/255, blue: 2/255, alpha: 0.8)
                }
                
                else if overlayer.shared.polygonInfo.faoSoil == "Re83-1ab" {
                    renderer.fillColor = UIColor(red: 211/255, green: 142/255, blue: 191/255, alpha: 0.8)
                }
                
                else if overlayer.shared.polygonInfo.faoSoil == "Fr33-3ab" {
                    renderer.fillColor = UIColor(red: 250/255, green: 97/255, blue: 2/255, alpha: 0.8)
                }
                
                else if overlayer.shared.polygonInfo.faoSoil == "Fa14-3ab" {
                    renderer.fillColor = UIColor(red: 70/255, green: 70/255, blue: 255/255, alpha: 0.8)
                }
                
                else if overlayer.shared.polygonInfo.faoSoil == "Vp64-3a" {
                    renderer.fillColor = UIColor(red: 2/255, green: 230/255, blue: 10/255, alpha: 0.8)
                }
                
                else if overlayer.shared.polygonInfo.faoSoil == "Lc99-2b" {
                    renderer.fillColor = UIColor(red: 78/255, green: 32/255, blue: 153/255, alpha: 0.8)
                }
                
                else if overlayer.shared.polygonInfo.faoSoil == "Fo102-3ab" {
                    renderer.fillColor = UIColor(red: 66/255, green: 24/255, blue: 190/255, alpha: 0.8)
                }
                
                else if overlayer.shared.polygonInfo.faoSoil == "Ag16-2a" {
                    renderer.fillColor = UIColor(red: 80/255, green: 80/255, blue: 250/255, alpha: 0.8)
                }
                
                else if overlayer.shared.polygonInfo.faoSoil == "Jt13-3a" {
                    renderer.fillColor = UIColor(red: 12/255, green: 65/255, blue: 5/255, alpha: 0.8)
                }
                
                else if overlayer.shared.polygonInfo.faoSoil == "Jt14-3a" {
                    renderer.fillColor = UIColor(red: 255/255, green: 0/255, blue: 50/255, alpha: 0.8)
                }
                
                else if overlayer.shared.polygonInfo.faoSoil == "Od21-a" {
                    renderer.fillColor = UIColor(red: 29/255, green: 9/255, blue: 9/255, alpha: 0.8)
                }
                
                
                else if overlayer.shared.polygonInfo.faoSoil == "Re83-1ab" {
                    renderer.fillColor = UIColor(red: 199/255, green: 60/255, blue: 80/255, alpha: 0.8)
                }
                
                else {
                    renderer.fillColor = UIColor.red
                }
                
                renderer.multiPolygon.title = overlayer.shared.polygonInfo.faoSoil
                renderer.multiPolygon.subtitle = "\(overlayer.shared.polygonInfo.domSoil)"
                
                
                renderer.strokeColor = UIColor.black
                return renderer
            }
            
            if overlay is MKPolyline {
                let polyline = MKPolylineRenderer(overlay: overlay)
                polyline.strokeColor = .systemBlue
                polyline.lineWidth = 6
                return polyline
            }
            
            if overlay is MKPolygon {
                let polyline = MKPolygonRenderer(overlay: overlay)
                polyline.strokeColor = .systemBlue
                polyline.lineWidth = 2
                return polyline
            }
        
            return MKOverlayRenderer(overlay: overlay)
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
            view.detailCalloutAccessoryView = detailView
            
            if !annotation.isGeoJSON {
                parent.mapView.removeOverlays(parent.mapView.overlays)
                configurePolyline(withDestinationCoordinate: annotation.coordinate)
            }
       }
        
        // MARK: - Helpers
        func render(overlay: MKOverlay, info: Any?) {
            let polygonInfo = info as! SoilTypeInfo
            overlayer.shared.changePolygon(newPolygon: polygonInfo)
            
            let newMapOverlay = SoilTypeOverlayer(overlay: overlay, polygonInfo: overlayer.shared.polygonInfo, type: "soil")
            SoilTypeOverlays.shared.addOverlay(soilTypeOverlayer: newMapOverlay)
            parent.mapView.addOverlay(overlay)
            let annot = CustomAnnotation(coordinate: CLLocationCoordinate2D(latitude: overlay.coordinate.latitude, longitude: overlay.coordinate.longitude))
            annot.name = polygonInfo.domSoil
            annot.title = "Soil Type " + polygonInfo.faoSoil
            annot.subtitle = polygonInfo.type
            annot.isGeoJSON = true
            parent.mapView.addAnnotation(annot)
            
            parent.mapView.setVisibleMapRect(overlay.boundingMapRect, animated: true)
        }
        
        func loadGeoJson() {
            guard let url = Bundle.main.url(forResource: "soil", withExtension: "json") else {
                fatalError("unable to get geojson")
            }
            
            var geoJson = [MKGeoJSONObject]()
            var overlays = [MKOverlay]()
            
            do {
                let data = try Data(contentsOf: url)
                geoJson = try MKGeoJSONDecoder().decode(data)
            } catch {
                fatalError("Unable to decode JSON")
            }

            for item in geoJson {
                if let feature = item as? MKGeoJSONFeature {
                    let geometry = feature.geometry.first
                    let propData = feature.properties!
                    
                    if let polygon = geometry as? MKMultiPolygon {
                        let polygonInfo = try? JSONDecoder.init().decode(SoilTypeInfo.self, from: propData)
                        self.render(overlay: polygon, info: polygonInfo)
                    }
                    
                    for geo in feature.geometry {
                        if let polygon = geo as? MKMultiPolygon {
                            overlays.append(polygon)
                        }
                    }
                    
                }
            }
        }
        
        
        func addSoilTypeLayer() {
            loadGeoJson()
        }
        
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
            self.userLocationCoordinate = parent.mapView.userLocation.coordinate
            let region = MKCoordinateRegion(
                center: CLLocationCoordinate2D(latitude: parent.mapView.userLocation.coordinate.latitude,
                                               longitude: parent.mapView.userLocation.coordinate.longitude),
                span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
            )
            self.currentRegion = region
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
//                print(route.distance, route.expectedTravelTime, route.advisoryNotices, route.hasHighways)
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

