//
//  UnsplashPhotosApp.swift
//  UnsplashPhotos
//
//  Created by Mac on 02/08/24.
//

import SwiftUI

@main
struct UnsplashPhotosApp: App {
    @State private var isActive = true
    
    var body: some Scene {
        WindowGroup {
            if isActive {
                SplashScreenView(isActive: $isActive)
            } else {
                PhotoListView()
            }
        }
    }
}
