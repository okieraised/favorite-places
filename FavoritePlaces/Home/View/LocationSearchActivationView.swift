//
//  LocationSearchActivationView.swift
//  FavoritePlaces
//
//  Created by Tri Pham on 3/6/23.
//

import SwiftUI

struct LocationSearchActivationView: View {
    var body: some View {
        HStack {
            
            Rectangle()
                .fill(Color.black)
                .frame(width: 8, height: 8)
                .padding(.horizontal)
            
            Text("Where to?")
                .foregroundColor(Color(.darkGray))
            
            Spacer()
        }
        
        .frame(width: UIScreen.main.bounds.width - 40, height: 50)
        .background(
            Rectangle()
                .fill(Color.white)
                .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                .shadow(color: .black, radius: 6)
        )
        
        
    }
}

struct LocationSearchActivationView_Previews: PreviewProvider {
    static var previews: some View {
        LocationSearchActivationView()
    }
}
