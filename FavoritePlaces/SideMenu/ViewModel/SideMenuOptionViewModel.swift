//
//  SideMenuOptionViewModel.swift
//  FavoritePlaces
//
//  Created by Tri Pham on 3/7/23.
//

import Foundation

enum SideMenuOptionViewModel: Int, CaseIterable, Identifiable {
    case mapSetting
    case wallet
    case settings
    case messages
    
    var title: String {
        switch self {
        case .mapSetting: return "Map Settings"
        case .wallet: return "Wallet"
        case .settings: return "Settings"
        case .messages: return "Messages"
        }
    }
    
    var imageName: String {
        switch self {
        case .mapSetting: return "map"
        case .wallet: return "creditcard"
        case .settings: return "gear"
        case .messages: return "bubble.left"
        }
    }
    
    var id: Int {
        return self.rawValue
    }
}
