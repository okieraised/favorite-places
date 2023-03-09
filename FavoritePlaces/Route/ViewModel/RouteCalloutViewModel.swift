////
////  RouteCalloutViewModel.swift
////  FavoritePlaces
////
////  Created by Tri Pham on 3/6/23.
////
//
//import Foundation
//import MapKit
//import SwiftUI
//import UIKit
//
//class RouteCalloutView: NSViewRepresentable {
//    
//    private var route: MKRoute
//    
//    init(route: MKRoute, frame: NSRect = NSRect(x: 0, y: 0, width: 300, height: 400)) {
//        self.route = route
//        super.init(frame: frame)
//        configure()
//    }
//    
//    private func directionsIcon(_ instruction: String) -> String {
//        
//        if instruction.contains("right") {
//            return "arrow.turn.up.right"
//        } else if instruction.contains("left") {
//            return "arrow.turn.up.left"
//        } else if instruction.contains("destination") {
//            return "mappin.circle.fill"
//        } else {
//            return "arrow.up"
//        }
//        
//    }
//    
//    private func configure() {
//        
//        let documentView = NSView(frame: .zero)
//        
//        var offsetY: CGFloat = 0
//        
//        for step in route.steps.reversed() {
//            
//            if step.instructions.isEmpty {
//                continue
//            }
//            
//            let hStackView = NSStackView(frame: CGRect(x: 0.0, y: offsetY, width: frame.width, height: 60))
//            hStackView.edgeInsets = .init(top: 20, left: 20, bottom: 0, right: 20)
//            hStackView.alignment = .left
//            hStackView.orientation = .horizontal
//            
//            let img = NSImage(systemSymbolName: directionsIcon(step.instructions), accessibilityDescription: nil)
//            let imgView = NSImageView(image: img!)
//            
//            let instructionsTextField = NSTextField(frame: CGRect(x: 0, y: 0, width: 100, height: 60))
//            instructionsTextField.stringValue = step.instructions
//            instructionsTextField.isEditable = false
//            instructionsTextField.isBezeled = false
//            
//            let vStackView = NSStackView()
//            vStackView.alignment = .left
//            vStackView.orientation = .vertical
//            
//            vStackView.addArrangedSubview(instructionsTextField)
//            
//            hStackView.addArrangedSubview(imgView)
//            hStackView.addArrangedSubview(vStackView)
//            
//            documentView.addSubview(hStackView)
//            
//            offsetY += 60
//        }
//        
//        documentView.frame = .init(x: 0, y: 0, width: 400, height: offsetY)
//        
//        let scrollView = NSScrollView(frame: frame)
//        scrollView.hasVerticalScroller = true
//        scrollView.documentView = documentView
//        scrollView.automaticallyAdjustsContentInsets = false
//        scrollView.contentInsets = NSEdgeInsets(top: 10, left: 0, bottom: 10, right: 0)
//        
//        scrollView.documentView?.scroll(NSPoint(x: 0, y: documentView.frame.height))
//        scrollView.verticalScroller?.floatValue = 0
//        
//        self.addSubview(scrollView)
//        
//    }
//    
//    required init?(coder: NSCoder) {
//        fatalError("Not implemented")
//    }
//    
//}
