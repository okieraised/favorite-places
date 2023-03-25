//
//  LocationSearchResultCell.swift
//  FavoritePlaces
//
//  Created by Tri Pham on 3/6/23.
//

import SwiftUI

struct LocationSearchResultCell: View {
    let title: String
    let subtitle: String
    
    var body: some View {
        VStack {
            HStack {
                Image(systemName: "mappin.circle.fill")
                    .resizable()
                    .foregroundColor(.blue)
                    .accentColor(.white)
                    .frame(width: 40, height: 40)
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(title)
                        .font(.body)
                    
                    Text(subtitle)
                        .font(.system(size: 15))
                        .foregroundColor(.gray)
                }
                .padding(.leading, 8)
                .padding(.vertical, 8)
                
                Spacer()
//
//                Button {
//                    print("add to fav")
//                } label: {
//                    Text("Favorite")
//                        .padding()
//                        .foregroundColor(.white)
//                        .background(.blue)
//                        .clipShape(Capsule())
//                        .frame(width: 120, height: 60)
//                }
//
                

            }
            .padding(.leading)
            
            Divider()
                .padding(.leading)
                .padding(.trailing)
        }
        
    }
}

struct LocationSearchResultCell_Previews: PreviewProvider {
    static var previews: some View {
        LocationSearchResultCell(title: "Starbucks", subtitle: "123 Main St")
    }
}
