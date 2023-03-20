//
//  LocationSearchResultsView.swift
//  FavoritePlaces
//
//  Created by Tri Pham on 3/6/23.
//

import SwiftUI
import MapKit

struct LocationSearchResultsView: View {
    @StateObject var viewModel: HomeViewModel
    @Binding var mapState: MapViewState
    let config: LocationResultsViewConfig
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                ForEach(viewModel.results, id: \.self) { result in
                    LocationSearchResultCell(title: result.title, subtitle: result.subtitle)
                        .onTapGesture {
                            withAnimation(.spring()) {
                                if result.subtitle.lowercased().contains("tìm gần đây") || result.subtitle.lowercased().contains("search nearby")  {
                                    mapState = .categorySelected
                                    viewModel.selectLocations(
                                        location: LocationManager.shared.location ?? CLLocation(latitude: 21.030, longitude: 105.847),
                                        searchTerm: result.title
                                    )
                                } else {
                                    viewModel.selectLocation(result, config: config)
                                }
                            }
                        }
                }
            }
        }
    }
}
