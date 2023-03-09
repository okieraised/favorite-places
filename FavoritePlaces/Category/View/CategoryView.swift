//
//  CategoryView.swift
//  FavoritePlaces
//
//  Created by Tri Pham on 3/1/23.
//

import SwiftUI

struct CategoryView: View {
    
    let categories = ["Groceries", "Pharmacies", "Gas", "Restaurants", "Coffee", "Hotel", "Mall"]
    let onSelectedCategory: (String) -> ()
    
    @State private var selectedCategory: String = ""
    
    var body: some View {
        ScrollView(.horizontal) {
            
            HStack {
                ForEach(categories, id: \.self) { category in
                    Button(
                        action: {
                            selectedCategory = category
                            
                            onSelectedCategory(category)
                        },
                        label: {
                            Text(category)
                        }
                    )
                        .padding(10)
                        .foregroundColor(selectedCategory == category ? Color.theme.primaryTextColor: Color.theme.secondaryBackgroundColor)
                        .background(selectedCategory == category ? Color.gray: Color.accentColor)
                        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                }
                
            }
            .padding(.leading,20)
            .padding(.trailing,20)
        }
    }
}

struct CategoryView_Previews: PreviewProvider {
    static var previews: some View {
        CategoryView(onSelectedCategory: { _ in })
    }
}
