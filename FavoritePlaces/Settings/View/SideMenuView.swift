//
//  SideMenuView.swift
//  FavoritePlaces
//
//  Created by Tri Pham on 3/6/23.
//

import SwiftUI
import MapKit

struct SideMenuView: View {
    @EnvironmentObject var mapSettings: MapSettings
    @EnvironmentObject var homeViewModel: HomeViewModel
    @Binding var mapState: MapViewState
    @Binding var showSideMenu: Bool
    
    let shoppingCategory = ["Mall", "Boutique", "Clothes", "Shoes"]

    var body: some View {
        if showSideMenu {
            VStack(spacing: 36) {
                VStack(alignment: .leading, spacing: 12) {
                    VStack(alignment: .leading, spacing: 15) {
                        HStack {
                            Image(systemName: "map")
                                .imageScale(.small)
                                .font(.title2)
                                .foregroundColor(.blue)
                            
                            Text("Map Settings")
                                .font(.system(size: 16, weight: .semibold))
                                .accentColor(Color.theme.primaryTextColor)
                            .opacity(0.77)
                        }
                        
                        Picker("Map Type", selection: $mapSettings.mapType) {
                            Text("Standard").tag(0)
                            Text("Hybrid").tag(1)
                            Text("Image").tag(2)
                        }.pickerStyle(SegmentedPickerStyle())
                            .onChange(of: mapSettings.mapType) { newValue in
                                mapSettings.mapType = newValue
                            }.frame(width: 250)

                        Picker("Map Elevation", selection: $mapSettings.showElevation) {
                            Text("Realistic").tag(0)
                            Text("Flat").tag(1)
                        }.pickerStyle(SegmentedPickerStyle())
                            .onChange(of: mapSettings.showElevation) { newValue in
                                mapSettings.showElevation = newValue
                            }.frame(width: 250)
                        
                        Picker("Map Elevation", selection: $mapSettings.showEmphasisStyle) {
                            Text("Default").tag(0)
                            Text("Muted").tag(1)
                        }.pickerStyle(SegmentedPickerStyle())
                            .onChange(of: mapSettings.showEmphasisStyle) { newValue in
                                mapSettings.showEmphasisStyle = newValue
                            }.frame(width: 250)
                        
                        Picker("Show Traffic", selection: $mapSettings.showTraffic) {
                            Text("Traffic Off").tag(0)
                            Text("Traffic On").tag(1)
                        }.pickerStyle(SegmentedPickerStyle())
                            .onChange(of: mapSettings.showTraffic) { newValue in
                                mapSettings.showTraffic = newValue
                            }.frame(width: 250)
                    }
                    
                    VStack(alignment: .leading) {
                        HStack {
                            Image(systemName: "heart.fill")
                                .imageScale(.small)
                                .font(.title2)
                                .foregroundColor(.red)
                            
                            Text("Beauty/Health")
                                .font(.system(size: 16, weight: .semibold))
                                .accentColor(Color.theme.primaryTextColor)
                            .opacity(0.77)
                        }
                        
                        HStack {
                            LandmarkButtonView(searchTerm: "Hair", mapState: $mapState, showSideMenu: $showSideMenu)
                            LandmarkButtonView(searchTerm: "Salon", mapState: $mapState, showSideMenu: $showSideMenu)
                            LandmarkButtonView(searchTerm: "Skincare", mapState: $mapState, showSideMenu: $showSideMenu)
                            LandmarkButtonView(searchTerm: "Spa", mapState: $mapState, showSideMenu: $showSideMenu)
                            Spacer()
                        }
                        .frame(width: 250)
                        
                        HStack {
                            LandmarkButtonView(searchTerm: "Clinic", mapState: $mapState, showSideMenu: $showSideMenu)
                            LandmarkButtonView(searchTerm: "Dental", mapState: $mapState, showSideMenu: $showSideMenu)
                            LandmarkButtonView(searchTerm: "Pharmacy", mapState: $mapState, showSideMenu: $showSideMenu)
                            Spacer()
                        }
                        .frame(width: 250)
                        
                    }
                    .onTapGesture {
                        mapState = .noInput
                    }
                    
                    VStack(alignment: .leading) {
                        HStack {
                            Image(systemName: "handbag.fill")
                                .imageScale(.small)
                                .font(.title2)
                                .foregroundColor(.green)
                            
                            Text("Shopping")
                                .font(.system(size: 16, weight: .semibold))
                                .accentColor(Color.theme.primaryTextColor)
                            .opacity(0.77)
                        }
                        
                        HStack {
                            LandmarkButtonView(searchTerm: "Boutique", mapState: $mapState, showSideMenu: $showSideMenu)
                            LandmarkButtonView(searchTerm: "Mall", mapState: $mapState, showSideMenu: $showSideMenu)
                            LandmarkButtonView(searchTerm: "Market", mapState: $mapState, showSideMenu: $showSideMenu)
                            LandmarkButtonView(searchTerm: "Plaza", mapState: $mapState, showSideMenu: $showSideMenu)
                            Spacer()
                        }
                        .frame(width: 250)
                        
                        HStack {
                            LandmarkButtonView(searchTerm: "Clothes", mapState: $mapState, showSideMenu: $showSideMenu)
                            LandmarkButtonView(searchTerm: "Cosmetics", mapState: $mapState, showSideMenu: $showSideMenu)
                            LandmarkButtonView(searchTerm: "Shoes", mapState: $mapState, showSideMenu: $showSideMenu)
                            Spacer()
                        }
                        .frame(width: 250)
                        
                    }
                    .onTapGesture {
                        mapState = .noInput
                    }
                    
                    VStack(alignment: .leading) {
                        HStack {
                            Image(systemName: "dollarsign.circle.fill")
                                .imageScale(.small)
                                .font(.title2)
                                .foregroundColor(.yellow)
                            
                            Text("Services")
                                .font(.system(size: 16, weight: .semibold))
                                .accentColor(Color.theme.primaryTextColor)
                            .opacity(0.77)
                        }
                        
                        HStack {
                            LandmarkButtonView(searchTerm: "ATM", mapState: $mapState, showSideMenu: $showSideMenu)
                            LandmarkButtonView(searchTerm: "Bank", mapState: $mapState, showSideMenu: $showSideMenu)
                            LandmarkButtonView(searchTerm: "Hotel", mapState: $mapState, showSideMenu: $showSideMenu)
                            LandmarkButtonView(searchTerm: "Post", mapState: $mapState, showSideMenu: $showSideMenu)
                            Spacer()
                        }
                        .frame(width: 250)
                        
                        HStack {
                            LandmarkButtonView(searchTerm: "Gas", mapState: $mapState, showSideMenu: $showSideMenu)
                            LandmarkButtonView(searchTerm: "Public Notary", mapState: $mapState, showSideMenu: $showSideMenu)
                            LandmarkButtonView(searchTerm: "Government", mapState: $mapState, showSideMenu: $showSideMenu)
                            Spacer()
                        }
                        .frame(width: 250)
                        
                    }
                    .onTapGesture {
                        mapState = .noInput
                    }
                    
                    VStack(alignment: .leading) {
                        HStack {
                            Image(systemName: "gamecontroller.fill")
                                .imageScale(.small)
                                .font(.title2)
                                .foregroundColor(.purple)
                            
                            Text("Entertainment")
                                .font(.system(size: 16, weight: .semibold))
                                .accentColor(Color.theme.primaryTextColor)
                            .opacity(0.77)
                        }
                        
                        HStack {
                            LandmarkButtonView(searchTerm: "Bar", mapState: $mapState, showSideMenu: $showSideMenu)
                            LandmarkButtonView(searchTerm: "Coffee", mapState: $mapState, showSideMenu: $showSideMenu)
                            LandmarkButtonView(searchTerm: "Movie", mapState: $mapState, showSideMenu: $showSideMenu)
                            LandmarkButtonView(searchTerm: "Restaurant", mapState: $mapState, showSideMenu: $showSideMenu)
                            Spacer()
                        }
                        .frame(width: 250)
                        
                    }
                    .onTapGesture {
                        mapState = .noInput
                    }
 
                    Rectangle()
                        .frame(width: 250, height: 0.75)
                        .opacity(0.7)
                        .foregroundColor(Color(.separator))
                        .shadow(color: .black.opacity(0.7), radius: 4)
                    
                    Text("For the person I love, my girlfriend, Luong. \n You're the most beautiful, and\n most wonderful person I've ever met.")
                        .multilineTextAlignment(.center)
                        .font(.system(size: 12, weight: .light))
                        .accentColor(Color.theme.primaryTextColor)
                        .foregroundColor(Color.theme.primaryTextColor)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.leading, 16)
            }
            .padding(.top, 8)
        }
        
//        VStack(spacing: 40) {
//            VStack(alignment: .leading, spacing: 32) {
//                VStack(alignment: .leading, spacing: 15) {
//                    HStack {
//                        Image(systemName: "map")
//                            .imageScale(.small)
//                            .font(.title2)
//                            .foregroundColor(.blue)
//
//                        Text("Map Settings")
//                            .font(.system(size: 16, weight: .semibold))
//                            .accentColor(Color.theme.primaryTextColor)
//                        .opacity(0.77)
//                    }
//
//                    Picker("Map Type", selection: $mapSettings.mapType) {
//                        Text("Standard").tag(0)
//                        Text("Hybrid").tag(1)
//                        Text("Image").tag(2)
//                    }.pickerStyle(SegmentedPickerStyle())
//                        .onChange(of: mapSettings.mapType) { newValue in
//                            mapSettings.mapType = newValue
//                        }.frame(width: 250)
//
//                    Picker("Map Elevation", selection: $mapSettings.showElevation) {
//                        Text("Realistic").tag(0)
//                        Text("Flat").tag(1)
//                    }.pickerStyle(SegmentedPickerStyle())
//                        .onChange(of: mapSettings.showElevation) { newValue in
//                            mapSettings.showElevation = newValue
//                        }.frame(width: 250)
//
//                    Picker("Map Elevation", selection: $mapSettings.showEmphasisStyle) {
//                        Text("Default").tag(0)
//                        Text("Muted").tag(1)
//                    }.pickerStyle(SegmentedPickerStyle())
//                        .onChange(of: mapSettings.showEmphasisStyle) { newValue in
//                            mapSettings.showEmphasisStyle = newValue
//                        }.frame(width: 250)
//
//                    Picker("Show Traffic", selection: $mapSettings.showTraffic) {
//                        Text("Traffic Off").tag(0)
//                        Text("Traffic On").tag(1)
//                    }.pickerStyle(SegmentedPickerStyle())
//                        .onChange(of: mapSettings.showTraffic) { newValue in
//                            mapSettings.showTraffic = newValue
//                        }.frame(width: 250)
//                }
//
//
//                VStack(alignment: .leading) {
//                    HStack {
//                        Image(systemName: "star.fill")
//                            .imageScale(.small)
//                            .font(.title2)
//                            .foregroundColor(.yellow)
//
//                        Text("Favorite Places")
//                            .font(.system(size: 16, weight: .semibold))
//                            .accentColor(Color.theme.primaryTextColor)
//                        .opacity(0.77)
//                    }
//
//                    HStack {
//                        Button(
//                            action: {
//                                selectedCategory = "Hotel"
//                                mapState = .categorySelected
//                                homeViewModel.landmarkSearch(
//                                    location: LocationManager.shared.location ?? CLLocation(latitude: 21.030, longitude: 105.847),
//                                    searchTerm: "Hotel")
//                            },
//                            label: {
//                                Text("Hotel")
//                            }
//                        )
//                        .padding(10)
////                        .foregroundColor(Color.theme.primaryTextColor)
////                        .background(Color.gray)
//                        .foregroundColor(selectedCategory == "Hotel" ? Color.theme.primaryTextColor: Color.theme.secondaryBackgroundColor)
//                        .background(selectedCategory == "Hotel" ? Color.gray: Color.accentColor)
//                        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
//                    }
//                }
//                .onReceive(homeViewModel.$landmarks) { landmarks in
//                    if landmarks.count > 0 {
//                        self.mapState = .categorySelected
//                    }
//                }
//
//                Rectangle()
//                    .frame(width: 250, height: 0.75)
//                    .opacity(0.7)
//                    .foregroundColor(Color(.separator))
//                    .shadow(color: .black.opacity(0.7), radius: 4)
//
//                Spacer()
//
//                Text("For the person I love the most, \n my girlfriend, Luong. \n You're the most beautiful, and\n most wonderful person I've ever met.")
//                    .multilineTextAlignment(.center)
//                    .font(.system(size: 14, weight: .light))
//                    .accentColor(Color.theme.primaryTextColor)
//                    .foregroundColor(Color.theme.primaryTextColor)
//            }
//            .frame(maxWidth: .infinity, alignment: .leading)
//            .padding(.leading, 16)
//        }
//        .padding(.top, 24)
    }
}

struct SideMenuView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            SideMenuView(mapState: .constant(.categorySelected), showSideMenu: .constant(true))
                .environmentObject(HomeViewModel())
                .environmentObject(MapSettings())
        }
    }
}

