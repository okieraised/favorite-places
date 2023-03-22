//
//  SavedLocationViewModel.swift
//  FavoritePlaces
//
//  Created by Tri Pham on 3/1/23.
//

import Foundation
import SwiftUI

enum SavedLocationViewModel: Int, CaseIterable, Identifiable {
    case home
    case work
    case shopping
    case restaurant
    
    var title: String {
        switch self {
        case .home: return "Home"
        case .work: return "Work"
        case .shopping: return "Shopping"
        case .restaurant: return "Restaurant"
        }
    }
    
    var imageName: String {
        switch self {
        case .home: return "house.circle.fill"
        case .work: return "archivebox.circle.fill"
        case .shopping: return "cart.circle.fill"
        case .restaurant: return "fork.knife.circle.fill"
        }
    }
    
    var subtitle: String {
        switch self {
        case .home: return "Add Home"
        case .work: return "Add Work"
        case .shopping: return "Add Shopping"
        case .restaurant: return "Add Restaurant"
        }
    }
    
    var color: Color {
        switch self {
        case .home: return Color.blue
        case .work: return Color.green
        case .shopping: return Color.purple
        case .restaurant: return Color.mint
        }
    }
    
//    var databaseKey: String {
//        switch self {
//        case .home: return "homeLocation"
//        case .work: return "workLocation"
//        case .shopping: return "shoppingLocation"
//        }
//    }
    
//    func subtitle(forUser user: User) -> String {
//        switch self {
//        case .home:
//            if let homeLocation = user.homeLocation {
//                return homeLocation.title
//            } else {
//                return "Add Home"
//            }
//        case .work:
//            if let workLocation = user.workLocation {
//                return workLocation.title
//            } else {
//                return "Add Work"
//            }
//        }
//    }
    
    var id: Int { return self.rawValue }
}
