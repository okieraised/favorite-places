//
//  PlaceCalloutView.swift
//  FavoritePlaces
//
//  Created by Tri Pham on 3/10/23.
//

import SwiftUI
import MapKit

struct PlaceCalloutView: View {
    var annotation: CustomAnnotation
    
    
    var body: some View {
//        Text(annotation.title ?? "")
        Text(annotation.subtitle ?? "")
        Text(annotation.phoneNumber ?? "")
    }
}

//struct PlaceCalloutView_Previews: PreviewProvider {
//    static var previews: some View {
//        PlaceCalloutView()
//    }
//}
