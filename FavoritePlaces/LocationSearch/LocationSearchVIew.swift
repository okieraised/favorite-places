//
//  LocationSearchVIew.swift
//  FavoritePlaces
//
//  Created by Tri Pham on 3/6/23.
//

import SwiftUI

struct LocationSearchVIew: View {
    
    @State private var search: String = ""
    var body: some View {
        VStack {
            List(1..<20, id: \.self) { index in
                Text("search \(index)")
                
            }
        }
        .searchable(text: $search, placement: .navigationBarDrawer(displayMode: .always), prompt: "Search of location")
    }
}

struct LocationSearchVIew_Previews: PreviewProvider {
    static var previews: some View {
        LocationSearchVIew()
    }
}
