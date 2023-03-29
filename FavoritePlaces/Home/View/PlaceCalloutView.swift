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
            
            HStack {
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
                
                Spacer()
                
                Button {
                    var googleSearch = annotation.title ?? ""
                    googleSearch = googleSearch.folding(locale: NSLocale.current)
                    let baseGoogleSearch = "https://www.google.com/search?q="
                    var formattedString = baseGoogleSearch + googleSearch
                    
                    formattedString = formattedString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
                    
                    guard let url = URL(string: formattedString) else {
                        return
                    }
                    UIApplication.shared.open(url)
                    
                } label: {
                    Text("Search on Safari")
                        .font(.system(size: 14))
                        .foregroundColor(.gray)
                }
            }
            
            
            

        }
    }
}

struct PlaceCalloutView_Previews: PreviewProvider {
    static var previews: some View {
        PlaceCalloutView(annotation: mockData.mockAnno)}
}
