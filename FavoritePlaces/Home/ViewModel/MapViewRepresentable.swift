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
    @Binding var featureState: FeatureViewState
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
            // these are your two lat/long coordinates
            let coordinate1 = CLLocationCoordinate2DMake(8.59975962975, 102.170435826)
            let coordinate2 = CLLocationCoordinate2DMake(23.3520633001, 109.33526981)

            // convert them to MKMapPoint
            let p1 = MKMapPoint(coordinate1)
            let p2 = MKMapPoint(coordinate2)

            // and make a MKMapRect using mins and spans
            let mapRect = MKMapRect(x: fmin(p1.x,p2.x), y: fmin(p1.y,p2.y), width: fabs(p1.x-p2.x), height: fabs(p1.y-p2.y));
            if let view = uiView as? MKMapView {
                view.setVisibleMapRect(mapRect, animated: true)
            }
            
            switch featureState {
            case .soilType, .protectedArea:
                context.coordinator.loadMultiPolygonFeature(geoFeature: featureState)
            case .river, .transportation:
                context.coordinator.loadMultiLineFeature(geoFeature: featureState)
            case .harbor, .airport, .hydropowerPlant:
                context.coordinator.loadPointFeature(geoFeature: featureState)
            default:
                break
            }
            
            
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
                var renderer = MKMultiPolygonRenderer(multiPolygon: multiPolygon)
                print(multiPolygon, multiPolygon.color)
                
                renderer.fillColor = multiPolygon.color
//                if overlayer.shared.polygonInfo is SoilTypeInfo {
//
//                }
                
                
//                print("polygonInfo 2", overlayer.shared.polygonInfo)
                
//                print("overlayer.shared.polygonInfo", overlayer.shared.polygonInfo)
                
    
//                if let soilInfo = overlayer.shared.polygonInfo as? SoilTypeInfo {
////                    print(soilInfo)
//                    let faoSoil = soilInfo.faoSoil
//
//                    if faoSoil == "Ao90-2/3c" || faoSoil == "Ao107-2bc" {
//                        renderer.fillColor = .brown
//                        //UIColor(red: 222/255, green: 181/255, blue: 16/255, alpha: 0.8)
//                    } else if faoSoil == "Ge56-3a" || faoSoil == "Jt13-3a" || faoSoil == "Ge55-3a" {
//                        renderer.fillColor = .green
//                    } else if faoSoil == "Je72-2a" || faoSoil == "Je73-3a" {
//                        renderer.fillColor = .blue
//                    } else if faoSoil == "Fr33-3ab" {
//                        renderer.fillColor = .magenta
//                    } else if faoSoil == "I-Af-3c" {
//                        renderer.fillColor = .darkGray
//                    } else if faoSoil == "I-Af-3c" {
//                        renderer.fillColor = .red
//                    } else if faoSoil == "I-Af-3c" {
//                        renderer.fillColor = .darkGray
//                    } else if faoSoil == "I-Af-3c" {
//                        renderer.fillColor = .darkGray
//                    } else if faoSoil == "I-Af-3c" {
//                        renderer.fillColor = .darkGray
//                    }
////                    else {
////                        renderer.fillColor = UIColor.red
////                    }
//                }
                
//                if let protectedAreaInfo = overlayer.shared.polygonInfo as? ProtectedAreaInfo {
//                    let areaCategory: String = protectedAreaInfo.category
//
//                    if areaCategory == "Habitat/Species Management Area" {
//                        renderer.fillColor = .orange
//                    } else if areaCategory == "Protected landscape/seascape" {
//                        renderer.fillColor = .blue
//                    } else if areaCategory == "National Park" {
//                        renderer.fillColor = .green
//                    } else {
//                        renderer.fillColor = .gray
//                    }
//                }
                renderer.strokeColor = UIColor.black
                renderer.lineWidth = 1
                return renderer
            }
            
            if let multiPolyline = overlay as? MKMultiPolyline {
                let renderer = MKMultiPolylineRenderer(multiPolyline: multiPolyline)
                
                if let transportationInfo = overlayer.shared.polygonInfo as? TransportationInfo {
                    print(overlayer.shared.polygonInfo)
                    let roadType = transportationInfo.type
                    if roadType == "Principal road" {
                        if transportationInfo.name == "National highway 1A" || transportationInfo.name == "National highway 1" {
                            renderer.strokeColor = .blue
                        } else if transportationInfo.name == "2" {
                            renderer.strokeColor = UIColor(red: 222/255, green: 181/255, blue: 16/255, alpha: 1)
                        } else {
                            renderer.strokeColor = .green
                        }
                    } else if roadType == "Secondary road" {
                        renderer.strokeColor = .gray
                    } else if roadType == "Railway" {
                        renderer.strokeColor = .magenta
                    } else {
                        renderer.strokeColor = .red
                    }
                }
                renderer.lineWidth = 3
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
        func renderPolygonFeatureAndAnnotation(overlay: MKOverlay, info: Any?) {
            
            let annot = CustomAnnotation(coordinate: CLLocationCoordinate2D(latitude: overlay.coordinate.latitude, longitude: overlay.coordinate.longitude))
            annot.isGeoJSON = true
            
            if info is SoilTypeInfo {
                if let polygonInfo = info as? SoilTypeInfo {
//                    overlayer.shared.changePolygon(newPolygon: polygonInfo)
//                    let newMapOverlay = SoilTypeOverlayer(overlay: overlay, polygonInfo: polygonInfo)
//                    SoilTypeOverlays.shared.addOverlay(soilTypeOverlayer: newMapOverlay)
                    annot.name = polygonInfo.domSoil
                    annot.title = "Soil Type " + polygonInfo.faoSoil
                    annot.subtitle = polygonInfo.type
//                    print("polygonInfo 1", overlayer.shared.polygonInfo)
//                    parent.mapView.addAnnotation(annot)
//                    parent.mapView.addOverlay(overlay)
                }
                
                
                
//                let polygonInfo = info as! SoilTypeInfo
//                overlayer.shared.changePolygon(newPolygon: polygonInfo)
//                let newMapOverlay = SoilTypeOverlayer(overlay: overlay, polygonInfo: overlayer.shared.polygonInfo as! SoilTypeInfo)
//                SoilTypeOverlays.shared.addOverlay(soilTypeOverlayer: newMapOverlay)
//                annot.name = polygonInfo.domSoil
//                annot.title = "Soil Type " + polygonInfo.faoSoil
//                annot.subtitle = polygonInfo.type
//                print("polygonInfo 1", overlayer.shared.polygonInfo)
                
                
            } else if info is ProtectedAreaInfo {
                let polygonInfo = info as! ProtectedAreaInfo
                overlayer.shared.changePolygon(newPolygon: polygonInfo)
                let newMapOverlay = ProtectedAreaOverlayer(overlay: overlay, polygonInfo: overlayer.shared.polygonInfo as! ProtectedAreaInfo) // overlayer.shared.polygonInfo overlayer.shared.polygonInfo as! SoilTypeInfo
                ProtectedAreaOverlays.shared.addOverlay(protectedAreaOverlayer: newMapOverlay)
                annot.name = polygonInfo.name
                annot.title = polygonInfo.name
                annot.subtitle = "Category: \(polygonInfo.category) | Level: \(polygonInfo.level) | Status Year: \(polygonInfo.proposed) | Managed By: \(polygonInfo.manager)"
            } else if info is TransportationInfo {
                let polygonInfo = info as! TransportationInfo
                overlayer.shared.changePolygon(newPolygon: polygonInfo)
                let newMapOverlay = TransportationOverlayer(overlay: overlay, polygonInfo: overlayer.shared.polygonInfo as! TransportationInfo)
                TransportationOverlays.shared.addOverlay(transportationOverlayer: newMapOverlay)
                annot.name = polygonInfo.name
                annot.title = polygonInfo.name
                annot.subtitle = "Type: \(polygonInfo.type) | Length: \(polygonInfo.length) m | level: \(polygonInfo.level)"
            }
            parent.mapView.addOverlay(overlay)
            parent.mapView.addAnnotation(annot)
            
        }
        
        func loadMultiPolygonFeature(geoFeature: FeatureViewState) {
            var resource: String
            
            
            switch geoFeature {
            case .soilType:
                resource = "soil"
            case .protectedArea:
                resource = "protected_area"
            default:
                return
            }
            
            guard let url = Bundle.main.url(forResource: resource, withExtension: "json") else {
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
                        var polygonInfo: Any
                        switch geoFeature {
                        case .soilType:
                            polygonInfo = try? JSONDecoder.init().decode(SoilTypeInfo.self, from: propData)
                            
                            if let info = polygonInfo as? SoilTypeInfo {
                                let faoSoil = info.faoSoil
                                
                                print("faoSoil", faoSoil)
                                
//                                if faoSoil == "Ao90-2/3c" {
//                                    polygon.color = .systemTeal
//                                }
                                    
//                                if faoSoil == "Ao107-2bc" {
//                                    polygon.color = .black
//                                    //UIColor(red: 222/255, green: 181/255, blue: 16/255, alpha: 0.8)
//                                }
                                
                                if faoSoil == "Ge56-3a" || faoSoil == "Jt13-3a" || faoSoil == "Ge55-3a" {
                                    polygon.color = .green
                                }
                                if faoSoil == "Je72-2a" || faoSoil == "Je73-3a" {
                                    polygon.color = .blue
                                }
                                if faoSoil == "Fr33-3ab" {
                                    polygon.color = .magenta
                                }
                                
                                if faoSoil == "I-Af-3c" {
                                    polygon.color = .darkGray
                                } else if faoSoil == "I-Af-3c" {
                                    polygon.color = .red
                                } else if faoSoil == "I-Af-3c" {
                                    polygon.color = .darkGray
                                } else if faoSoil == "I-Af-3c" {
                                    polygon.color = .darkGray
                                } else if faoSoil == "I-Af-3c" {
                                    polygon.color = .darkGray
                                }
                                
                                print("polygon", polygon.color)
                                
                                let annot = CustomAnnotation(coordinate: CLLocationCoordinate2D(latitude: polygon.coordinate.latitude, longitude: polygon.coordinate.longitude))
                                annot.isGeoJSON = true
                                annot.name = info.domSoil
                                annot.title = "Soil Type " + info.faoSoil
                                annot.subtitle = info.type
                                
                                parent.mapView.addAnnotation(annot)
                                overlays.append(polygon)
                            }
//                            parent.mapView.addOverlay(polygon)
                            
//                            self.renderPolygonFeatureAndAnnotation(overlay: polygon, info: polygonInfo)
                            
                            
                            
                        case .protectedArea:
                            polygonInfo = try? JSONDecoder.init().decode(ProtectedAreaInfo.self, from: propData)
                        default:
                            return
                        }
                        
                        
                        
//                        self.renderPolygonFeatureAndAnnotation(overlay: polygon, info: polygonInfo)
                        
                    }
                    
                }
            }
            parent.mapView.addOverlays(overlays, level: .aboveRoads)
        }
        
        func loadMultiLineFeature(geoFeature: FeatureViewState) {
            var resource: String
            
            
            switch geoFeature {
            case .river:
                resource = "river"
            case .transportation:
                resource = "transportation"
            default:
                return
            }
            
            guard let url = Bundle.main.url(forResource: resource, withExtension: "json") else {
                fatalError("unable to get geojson")
            }
            
            var geoJson = [MKGeoJSONObject]()
            
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
                    
                    if let polygon = geometry as? MKMultiPolyline {
                        var polygonInfo: Any
                        switch geoFeature {
                        case .river:
                            polygonInfo = try? JSONDecoder.init().decode(RiverInfo.self, from: propData)
                        case .transportation:
                            polygonInfo = try? JSONDecoder.init().decode(TransportationInfo.self, from: propData)
                            
                        default:
                            return
                        }
                        self.renderPolygonFeatureAndAnnotation(overlay: polygon, info: polygonInfo)
                    }
                }
            }
        }
        
        func loadPointFeature(geoFeature: FeatureViewState) {
            var resource: String
            
            
            switch geoFeature {
            case .harbor:
                resource = "harbor"
            case .airport:
                resource = "airport"
            case .hydropowerPlant:
                resource = "hydropower"
            default:
                return
            }
            
            guard let url = Bundle.main.url(forResource: resource, withExtension: "json") else {
                fatalError("unable to get geojson")
            }
            
            var geoJson = [MKGeoJSONObject]()
            
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

                    if let annotation = geometry as? MKPointAnnotation {
                        let annot = CustomAnnotation(coordinate: CLLocationCoordinate2D(latitude: annotation.coordinate.latitude, longitude: annotation.coordinate.longitude))
                        annot.isGeoJSON = true
                        var polygonInfo: Any
                        switch geoFeature {
                        case .harbor:
                            polygonInfo = try? JSONDecoder.init().decode(HarborInfo.self, from: propData)
                            let info = polygonInfo as! HarborInfo
                            annot.name = info.name
                            annot.title = "\(info.name) \(info.type)"
                            annot.subtitle = "Code: \(info.code) | Type: \(info.type)"
                        case .airport:
                            polygonInfo = try? JSONDecoder.init().decode(AirportInfo.self, from: propData)
                            let info = polygonInfo as! AirportInfo
                            annot.name = info.name
                            annot.title = "\(info.name) \(info.type) Airport"
                            annot.subtitle = "ICAO: \(info.icao) | IATA: \(info.iata) | Runways: \(info.length) m | Location: \(info.city)"
                        case .hydropowerPlant:
                            polygonInfo = try? JSONDecoder.init().decode(HydropowerInfo.self, from: propData)
                            let info = polygonInfo as! HydropowerInfo
                            annot.name = info.name
                            annot.title = "\(info.name) HPP"
                            annot.subtitle = "Wattage: \(info.wattage) MW | Quantity: \(info.quantity ?? -1) MKWh | Laidown: \(info.laidDown ?? "Unknown") | Operation: \(info.operation ?? "Unknown")"
                        default:
                            return
                        }
                        parent.mapView.addAnnotation(annot)
                        
                    }
                }
            }
            // these are your two lat/long coordinates
            let coordinate1 = CLLocationCoordinate2DMake(8.59975962975, 102.170435826)
            let coordinate2 = CLLocationCoordinate2DMake(23.3520633001, 109.33526981)

            // convert them to MKMapPoint
            let p1 = MKMapPoint(coordinate1)
            let p2 = MKMapPoint(coordinate2)

            // and make a MKMapRect using mins and spans
            let mapRect = MKMapRect(x: fmin(p1.x,p2.x), y: fmin(p1.y,p2.y), width: fabs(p1.x-p2.x), height: fabs(p1.y-p2.y));
            parent.mapView.setVisibleMapRect(mapRect, animated: true)
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

