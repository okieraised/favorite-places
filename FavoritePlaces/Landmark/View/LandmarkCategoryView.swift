//
//  LandmarkCategoryView.swift
//  FavoritePlaces
//
//  Created by Tri Pham on 3/7/23.
//

import SwiftUI

let AIRPORT = "Airport"
//let PROVINCE = "Province"
let HYDROPOWER_PLANT = "Hydropower Plant"
let HARBOR = "Harbor"
let TRANSPORTATION = "Road"
let PROTECTED_AREA = "Protected Area"
let SOIL_TYPE = "Soil Type"
//let RIVER = "River"
                        

struct LandmarkCategoryView: View {
    
    let categories = [AIRPORT, HYDROPOWER_PLANT, HARBOR, TRANSPORTATION, PROTECTED_AREA, SOIL_TYPE]
    let onSelectedCategory: (String) -> ()
    
    @State private var selectedCategory: String = ""
    @Binding var mapState: MapViewState
    @Binding var featureState: FeatureViewState
    
    var body: some View {
        ScrollView(.horizontal) {
            HStack {
                ForEach(categories, id: \.self) { category in
                    Button(
                        action: {
                            selectedCategory = category
                            mapState = .featureSelected
                            onSelectedCategory(category)
                            switch selectedCategory {
//                            case PROVINCE:
//                                featureState = .province
                            case AIRPORT:
                                featureState = .airport
                            case HYDROPOWER_PLANT:
                                featureState = .hydropowerPlant
                            case HARBOR:
                                featureState = .harbor
                            case TRANSPORTATION:
                                featureState = .transportation
                            case PROTECTED_AREA:
                                featureState = .protectedArea
                            case SOIL_TYPE:
                                featureState = .soilType
//                            case RIVER:
//                                featureState = .river
                            default:
                                featureState = .noFeature
                            }
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

struct LandmarkCategoryView_Previews: PreviewProvider {
    static var previews: some View {
        LandmarkCategoryView(onSelectedCategory: { _ in }, mapState: .constant(.categorySelected), featureState: .constant(.noFeature))
    }
}

