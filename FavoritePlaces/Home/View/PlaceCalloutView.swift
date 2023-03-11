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
        VStack(alignment: .leading, spacing: 4) {
            Text(annotation.subtitle ?? "")
                .font(.system(size: 15))
                .foregroundColor(Color.theme.primaryTextColor)
            
            Button {
                var phoneNumber = annotation.phoneNumber ?? ""
                phoneNumber = phoneNumber.replacingOccurrences(of: " ", with: "")
                phoneNumber = phoneNumber.replacingOccurrences(of: "(", with: "")
                phoneNumber = phoneNumber.replacingOccurrences(of: ")", with: "")
                phoneNumber = phoneNumber.replacingOccurrences(of: "-", with: "")

                let tel = "tel://"
                let formattedString = tel + phoneNumber
                guard let url = URL(string: formattedString) else {
                    return
                }
                UIApplication.shared.open(url)
            } label: {
                Text(annotation.phoneNumber ?? "")
                    .font(.system(size: 14))
                    .foregroundColor(.gray)
            }
        }
        
    }
}

struct PlaceCalloutView_Previews: PreviewProvider {
    var anno: CustomAnnotation = CustomAnnotation(coordinate: CLLocationCoordinate2D(latitude: 0, longitude: 0))

    init(anno: CustomAnnotation) {
        self.anno = anno
        anno.phoneNumber = "123"
    }
//    anno.title = "haha"
//    anno.subtitle = "123 main st"
//    anno.name = "haha"
//    anno.phoneNumber = "123456789"

    static var previews: some View {


        PlaceCalloutView(
            annotation: CustomAnnotation(coordinate: CLLocationCoordinate2D(latitude: 0, longitude: 0)))
    }
}
