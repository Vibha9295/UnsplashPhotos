//
//  TabBarAppearanceModifier.swift
//  UnsplashPhotos
//
//  Created by Mac on 02/08/24.
//

import Foundation
import SwiftUI

struct TabBarAppearanceModifier: ViewModifier {
    let backgroundColor: UIColor
    
    func body(content: Content) -> some View {
        content
            .onAppear {
                let appearance = UITabBarAppearance()
                appearance.backgroundColor = backgroundColor
                UITabBar.appearance().scrollEdgeAppearance = appearance
            }
    }
}
