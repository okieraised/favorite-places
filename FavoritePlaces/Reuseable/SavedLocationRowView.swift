//
//  SavedLocationRowView.swift
//  FavoritePlaces
//
//  Created by Tri Pham on 3/1/23.
//

import SwiftUI

struct SavedLocationRowView: View {
    let viewModel: SavedLocationViewModel
//    let user: User
    
    var body: some View {
//        HStack(spacing: 16) {
//            Image(systemName: viewModel.imageName)
//                .font(.title2)
//                .imageScale(.medium)
//            
//            Text(viewModel.title)
//                .font(.system(size: 16, weight: .semibold))
//            
//            Spacer()
//        }
//        .foregroundColor(Color.theme.primaryTextColor)
        
        
        HStack(spacing: 16) {
            Image(systemName: viewModel.imageName)
                .imageScale(.medium)
                .font(.title)
                .foregroundColor(Color(.systemBlue))
            
            VStack(alignment: .leading, spacing: 4) {
                Text(viewModel.title)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(Color.theme.primaryTextColor)
            }
        }
    }
}
