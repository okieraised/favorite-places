//
//  DirectionCalloutView.swift
//  FavoritePlaces
//
//  Created by Tri Pham on 3/22/23.
//

import SwiftUI
import MapKit

struct DirectionCalloutView: View {
//    private var route: MKRoute
    @EnvironmentObject var homeViewModel: HomeViewModel
    
    
    private func directionsIcon(_ instruction: String) -> String {
        
        if instruction.lowercased().contains("right") || instruction.lowercased().contains("phải") {
            return "arrow.turn.up.right"
        } else if instruction.lowercased().contains("left") || instruction.lowercased().contains("trái") {
            return "arrow.turn.up.left"
        } else if instruction.lowercased().contains("destination") || instruction.lowercased().contains("điểm đích") {
            return "mappin.circle.fill"
        } else {
            return "arrow.up"
        }
        
    }
    
    
    var body: some View {
        
        
        ScrollView(.vertical) {
            
            
            
            VStack {
                
                HStack(spacing: 16) {
                    Image(systemName: "arrow.turn.up.right")
                        .imageScale(.medium)
                        .font(.title)
                        .foregroundColor(.blue)
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Rẽ phải vào Telegraph Hill Blvd")
                            .font(.system(size: 16, weight: .bold))
                            .foregroundColor(Color.theme.primaryTextColor)
                    }
                    
                    Spacer()
                }
                .padding(4)
                
                Rectangle()
                    .frame(height: 0.75)
                    .opacity(0.7)
                    .foregroundColor(Color(.separator))
                    .shadow(color: .black.opacity(0.7), radius: 4)
            }
            
        }
        
    }
    
    
}

struct DirectionCalloutView_Previews: PreviewProvider {
    static var previews: some View {
        DirectionCalloutView()
            .environmentObject(HomeViewModel())
    }
}
