//
//  SideMenuView.swift
//  FavoritePlaces
//
//  Created by Tri Pham on 3/6/23.
//

import SwiftUI

struct SideMenuView: View {
    @EnvironmentObject var mapSettings: MapSettings

    var body: some View {
        VStack(spacing: 40) {
            VStack(alignment: .leading, spacing: 32) {
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
                        Image(systemName: "star.fill")
                            .imageScale(.small)
                            .font(.title2)
                            .foregroundColor(.yellow)
                        
                        Text("Favorite Places")
                            .font(.system(size: 16, weight: .semibold))
                            .accentColor(Color.theme.primaryTextColor)
                        .opacity(0.77)
                    }
                    
                    ForEach(SavedLocationViewModel.allCases) { viewModel in
                        NavigationLink {
                        } label: {
                            SavedLocationRowView(viewModel: viewModel)
                        }
                    }
                    .padding(.trailing)
                    .padding(.top, 1)
                }
                
                Rectangle()
                    .frame(width: 250, height: 0.75)
                    .opacity(0.7)
                    .foregroundColor(Color(.separator))
                    .shadow(color: .black.opacity(0.7), radius: 4)
                
                Spacer()
                
                Text("For the person I love the most, \n my girlfriend, Luong. \n You're the most beautiful, and\n most wonderful person I've ever met.")
                    .multilineTextAlignment(.center)
                    .font(.system(size: 14, weight: .light))
                    .accentColor(Color.theme.primaryTextColor)
                    .foregroundColor(Color.theme.primaryTextColor)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.leading, 16)
        }
        .padding(.top, 24)
    }
}

struct SideMenuView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            SideMenuView()
                .environmentObject(MapSettings())
        }
    }
}

