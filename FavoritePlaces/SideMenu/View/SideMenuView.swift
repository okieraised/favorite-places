//
//  SideMenuView.swift
//  FavoritePlaces
//
//  Created by Tri Pham on 3/6/23.
//

import SwiftUI

struct SideMenuView: View {
    
    var body: some View {
            VStack(spacing: 40) {
                // header view
                VStack(alignment: .leading, spacing: 32) {
                    
                    Section("Map Settings") {
                        ForEach(SavedLocationViewModel.allCases) { viewModel in
                            NavigationLink {
                            } label: {
                                SavedLocationRowView(viewModel: viewModel)
                            }
                        }
                    }
                    .font(.system(size: 24, weight: .bold))
                    .foregroundColor(Color.theme.primaryTextColor)
                    
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
                        .font(.system(size: 16, weight: .semibold))
                        .accentColor(Color.theme.primaryTextColor)
                        .foregroundColor(Color.theme.primaryTextColor)
                    
                    
                }
                .frame(maxWidth: .infinity, alignment: .leading)
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
            .padding(.top, 32)
//            .navigationTitle("Settings")
            .navigationBarTitleDisplayMode(.large)
    }
}

struct SideMenuView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            SideMenuView()
        }
    }
}

