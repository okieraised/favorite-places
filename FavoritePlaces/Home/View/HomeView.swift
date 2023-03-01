//
//  HomeView.swift
//  FavoritePlaces
//
//  Created by Tri Pham on 3/1/23.
//

import SwiftUI

struct HomeView: View {
    var body: some View {
//        MapViewRepresentable(mapState: $mapState)
        ZStack(alignment: .top) {
            MapViewRepresentable()
                .ignoresSafeArea()
            
            
            MapViewActionButton()
                .padding(.leading)
                .padding(.top, 4)
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
