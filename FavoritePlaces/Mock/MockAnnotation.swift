//
//  MockAnnotation.swift
//  FavoritePlaces
//
//  Created by Tri Pham on 3/13/23.
//

import SwiftUI
import CoreLocation

extension PreviewProvider {
    static var mockData: AnnotationPreview {
        return AnnotationPreview.shared
    }
}

class AnnotationPreview {
    static let shared = AnnotationPreview()
    
    let mockAnno: CustomAnnotation
    
    init() {
        self.mockAnno = CustomAnnotation(coordinate: CLLocationCoordinate2D(latitude: 0, longitude: 0))
        self.mockAnno.title = "haha"
        self.mockAnno.phoneNumber = "123456689"
        self.mockAnno.url = URL(string: "https://google.com")
        self.mockAnno.subtitle = "1234 main st"
        
    }
    
}
