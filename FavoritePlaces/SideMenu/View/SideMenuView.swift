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
                    VStack(alignment: .leading) {
                        HStack {
                            Text("Map Types")
                                .font(.system(size: 16, weight: .semibold))
                                .accentColor(Color.theme.primaryTextColor)
                            .opacity(0.77)
                            
                            Image(systemName: "map")
                                .imageScale(.small)
                                .font(.title2)
                                .foregroundColor(.gray)
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
                        }

                
                // option list
//                    VStack {
//                        ForEach(SideMenuOptionViewModel.allCases) { viewModel in
//                            NavigationLink(value: viewModel) {
//                                SideMenuOptionView(viewModel: viewModel)
//                                    .padding()
//                            }
//                        }
//                    }
//                    .navigationDestination(for: SideMenuOptionViewModel.self) { viewModel in
//                        switch viewModel {
//                        case .mapSetting:
//                            Text("Trips")
//                        case .wallet:
//                            Text("Wallet")
//                        case .messages:
//                            Text("Messages")
//                        default:
//                            Text("ahha")
//                        }
//                    }
                
//                    Section("Map Settings") {
//                        ForEach(SavedLocationViewModel.allCases) { viewModel in
//                            NavigationLink {
//                            } label: {
//                                SavedLocationRowView(viewModel: viewModel)
//                            }
//                        }
//                    }
//                    .font(.system(size: 24, weight: .bold))
//                    .foregroundColor(Color.theme.primaryTextColor)
                
                Section("Favorites") {
                    ForEach(SavedLocationViewModel.allCases) { viewModel in
                        NavigationLink {
                        } label: {
                            SavedLocationRowView(viewModel: viewModel)
                        }
                    }
                }
                .font(.system(size: 24, weight: .bold))
                .foregroundColor(Color.theme.primaryTextColor)
                
                
                Rectangle()
                    .frame(width: 250, height: 0.75)
                    .opacity(0.7)
                    .foregroundColor(Color(.separator))
                    .shadow(color: .black.opacity(0.7), radius: 4)
                
                Spacer()
                
                Text("For my wonderful girlfriend,\nLuong Dao")
                    .multilineTextAlignment(.center)
                    .font(.system(size: 14, weight: .semibold))
                    .accentColor(Color.theme.primaryTextColor)
                    .foregroundColor(Color.theme.primaryTextColor)
                
                
            }
            .frame(maxWidth: .infinity, alignment: .leading)
//                .padding(.trailing)
            .padding(.leading, 16)
                  
            // option list
            
//                .navigationDestination(for: SideMenuOptionViewModel.self) { viewModel in
//                    switch viewModel {
//                    case .trips:
//                        Text("Trips")
//                    case .wallet:
//                        Text("Wallet")
//                    case .settings:
//                        SettingsView(user: user)
//                    case .messages:
//                        Text("Messages")
//                    }
//                }
            
//                Spacer()

            
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

