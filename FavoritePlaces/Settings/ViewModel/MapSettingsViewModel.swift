//
//  MapSettingsViewModel.swift
//  FavoritePlaces
//
//  Created by Tri Pham on 3/15/23.
//

import SwiftUI

final class MapSettings: ObservableObject {
    @Published var mapType = 0
    @Published var showElevation = 0
    @Published var showEmphasisStyle = 0
    @Published var showTraffic = 0
}
