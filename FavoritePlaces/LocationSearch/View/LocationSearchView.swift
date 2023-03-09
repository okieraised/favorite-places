//
//  LocationSearchVIew.swift
//  FavoritePlaces
//
//  Created by Tri Pham on 3/6/23.
//

import SwiftUI

struct LocationSearchView: View {
    @State private var startLocationText = ""
    @EnvironmentObject var viewModel: HomeViewModel
    @StateObject private var placeListVM = PlaceListViewModel()
    
    var body: some View {
        VStack {
            // header view
            HStack {
                VStack {
                    Circle()
                        .fill(Color(.systemGray3))
                        .frame(width: 6, height: 6)
                    
                    Rectangle()
                        .fill(Color(.systemGray3))
                        .frame(width: 1, height: 24)
                    
                    Rectangle()
                        .fill(Color.theme.primaryTextColor)
                        .frame(width: 6, height: 6)
                }
                
                VStack {
                    TextField("Current location", text: $startLocationText)
                        .frame(height: 32)
                        .padding(EdgeInsets(top: 0, leading: 6, bottom: 0, trailing: 6))
                        .background(Color(.systemGroupedBackground))
                        .cornerRadius(20)
                        .disabled(true)
                    
//                    TextField("Where to?", text: $viewModel.queryFragment,
//                              onEditingChanged: { _ in},
//                              onCommit: {
//                                  placeListVM.searchLandmarks(searchTerm: viewModel.queryFragment)
//                              })
//                        .frame(height: 32)
//                        .padding(EdgeInsets(top: 0, leading: 6, bottom: 0, trailing: 6))
//                        .background(Color(.systemGray4))
//                        .cornerRadius(20)
                    
                    
                    TextField("Where to?", text: $viewModel.queryFragment)
                        .frame(height: 32)
                        .padding(EdgeInsets(top: 0, leading: 6, bottom: 0, trailing: 6))
                        .background(Color(.systemGray4))
                        .cornerRadius(20)
                    
                }
            }
            .padding(.horizontal)
            .padding(.top, 64)
            
            Divider()
                .padding(.vertical)
            
            // list view
            LocationSearchResultsView(viewModel: viewModel, config: .ride)
        }
        .background(Color.theme.backgroundColor)
        .background(.white)
    }
}

struct LocationSearchView_Previews: PreviewProvider {
    static var previews: some View {
        LocationSearchView()
            .environmentObject(HomeViewModel())
    }
}
