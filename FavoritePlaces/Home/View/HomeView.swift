//
//  HomeView.swift
//  FavoritePlaces
//
//  Created by Tri Pham on 3/1/23.
//

import SwiftUI
import MapKit

struct HomeView: View {
    @State private var mapState = MapViewState.noInput
    @State private var showSideMenu = false
    @EnvironmentObject var homeViewModel: HomeViewModel
    @State private var userTrackingMode: MapUserTrackingMode = .follow
    
    var body: some View {
        NavigationStack {
            ZStack {
                if showSideMenu {
                    SideMenuView()
                }
                
                mapView
                    .offset(x: showSideMenu ? 300 : 0)
                    .shadow(color: showSideMenu ? .black : .clear, radius: 10)
            }
            .onAppear {
                showSideMenu = false
            }
        }
    }
}


extension HomeView {
    var mapView: some View {
        ZStack(alignment: .bottom) {
            ZStack(alignment: .top) {
                MapViewRepresentable(mapState: $mapState)
                    .ignoresSafeArea()
                
                if mapState == .searchingForLocation {
                    LocationSearchView(mapState: $mapState)
                } else if mapState == .noInput {
                    VStack {
                        LocationSearchActivationView()
                            .padding(.top, 10)
                            .onTapGesture {
                                withAnimation(.spring()) {
                                    mapState = .searchingForLocation
                                }
                            }
                        
                        LandmarkCategoryView(
                            onSelectedCategory: { (category) in homeViewModel.landmarkSearch(
                                location: LocationManager.shared.location ?? CLLocation(latitude: 21.030, longitude: 105.847),
                                searchTerm: category)   
                            },
                            mapState: $mapState
                        )
                        .onTapGesture {
                            mapState = .noInput
                        }
                    }
                }
                MapViewActionButton(mapState: $mapState, showSideMenu: $showSideMenu)
                    .padding(.leading, 10)
                    .padding(.bottom, 30)
            }
        }
        .edgesIgnoringSafeArea(.bottom)
        .onReceive(LocationManager.shared.$userLocation) { location in
            if let location = location {
                homeViewModel.userLocation = location
            }
        }
        .onReceive(homeViewModel.$selectedLocation) { location in
            if location != nil {
                self.mapState = .locationSelected
            }
        }
        .onReceive(homeViewModel.$landmarks) { landmarks in
            if landmarks.count > 0 {
                self.mapState = .categorySelected
            }
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
            .environmentObject(HomeViewModel())
    }
}
