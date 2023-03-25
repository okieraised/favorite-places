//
//  LandmarkButtonView.swift
//  FavoritePlaces
//
//  Created by Tri Pham on 3/25/23.
//

import SwiftUI
import MapKit

struct LandmarkButtonView: View {
    var searchTerm: String
    @EnvironmentObject var homeViewModel: HomeViewModel
    @Binding var mapState: MapViewState
    @Binding var showSideMenu: Bool
    
    
    var body: some View {
        Button(
            action: {
                mapState = .categorySelected
                showSideMenu = false
                homeViewModel.landmarkSearch(
                    location: LocationManager.shared.location ?? CLLocation(latitude: 21.030, longitude: 105.847),
                    searchTerm: searchTerm)
            },
            label: {
                Text(searchTerm)
                    .font(.system(size: 11, weight: .medium))
            }
        )
        .padding(10)
        .foregroundColor(Color.theme.secondaryBackgroundColor)
        .background(Color.accentColor)
        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
        .onReceive(homeViewModel.$landmarks) { landmarks in
            if landmarks.count > 0 {
                self.mapState = .categorySelected
            }
        }
    }
}

struct LandmarkButtonView_Previews: PreviewProvider {
    static var previews: some View {
        LandmarkButtonView(searchTerm: "Hotel", mapState: .constant(.categorySelected), showSideMenu: .constant(true))
            .environmentObject(HomeViewModel())
    }
}
