//
//  MapViewActionButton.swift
//  FavoritePlaces
//
//  Created by Tri Pham on 3/1/23.
//

import SwiftUI

struct MapViewActionButton: View {
//    @Binding var mapState: MapViewState
//    @Binding var showSideMenu: Bool
//    @EnvironmentObject var viewModel: HomeViewModel
    
    var body: some View {
        Button {
//            withAnimation(.spring()) {
//                actionForState(mapState)
//            }
        } label: {
            Image(systemName: "line.3.horizontal") // imageNameForState("")
                .font(.title2)
                .foregroundColor(.black)
                .padding()
                .background(.white)
                .clipShape(Circle())
                .shadow(color: .black, radius: 6)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
    
//    func actionForState(_ state: MapViewState) {
//        switch state {
//        case .noInput:
//            showSideMenu.toggle()
//        case .searchingForLocation:
//            mapState = .noInput
//        case .locationSelected,
//                .polylineAdded,
//                .tripRejected,
//                .tripAccepted,
//                .tripRequested,
//                .tripCancelledByDriver,
//                .tripCancelledByPassenger:
//            mapState = .noInput
//            viewModel.selectedUberLocation = nil
//        }
//    }
    
//    func imageNameForState(_ state: MapViewState) -> String {
//        switch state {
//        case .noInput:
//            return "line.3.horizontal"
//        case .searchingForLocation,
//                .locationSelected,
//                .polylineAdded,
//                .tripRejected,
//                .tripAccepted,
//                .tripRequested,
//                .tripCancelledByDriver,
//                .tripCancelledByPassenger:
//            return "arrow.left"
//        }
//    }
}

struct MapViewActionButton_Previews: PreviewProvider {
    static var previews: some View {
        MapViewActionButton()
//        MapViewActionButton(mapState: .constant(.noInput), showSideMenu: .constant(false))
    }
}
