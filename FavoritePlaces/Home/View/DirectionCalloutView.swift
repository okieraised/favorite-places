//
//  DirectionCalloutView.swift
//  FavoritePlaces
//
//  Created by Tri Pham on 3/22/23.
//

import SwiftUI
import MapKit

struct DirectionCalloutView: View {
    var route: [String]
    @EnvironmentObject var homeViewModel: HomeViewModel
    @State private var showSteps = true
    
    
    private func directionsIcon(_ instruction: String) -> String {
        
        if instruction.lowercased().contains("right") || instruction.lowercased().contains("phải") {
            return "arrow.turn.up.right"
        } else if instruction.lowercased().contains("left") || instruction.lowercased().contains("trái") {
            return "arrow.turn.up.left"
        } else if instruction.lowercased().contains("destination") || instruction.lowercased().contains("đến đích") {
            return "mappin.circle.fill"
        } else {
            return "arrow.up"
        }
        
    }
    
    
    var body: some View {
        
        
        VStack {
            Image(systemName: "line.3.horizontal")
                .font(.title2)
                .foregroundColor(Color.theme.primaryTextColor)
                .padding(2)
            
            ScrollView(.vertical) {
                VStack {
                    ForEach(route, id: \.self) { routeStep in
                        
                        
                        HStack(spacing: 16) {
                            Image(systemName: directionsIcon(routeStep))
                                .imageScale(.medium)
                                .font(.title)
                                .foregroundColor(.blue)
                                .opacity(0.77)
                            
                            VStack(alignment: .leading, spacing: 4) {
                                Text(routeStep)
                                    .font(.system(size: 16, weight: .bold))
                                    .foregroundColor(Color.theme.primaryTextColor)
                            }
                            
                            Spacer()
                        }
                        .padding(4)
                        
                        Divider()
                    }
                }
                .padding([.leading, .trailing], 24)
            }
        }
        .padding(.top)
    }
    
    
}

struct DirectionCalloutView_Previews: PreviewProvider {
    static var previews: some View {
        DirectionCalloutView(route: ["turn left", "turn right", "turn left", "continue", "destination"])
            .environmentObject(HomeViewModel())
    }
}
