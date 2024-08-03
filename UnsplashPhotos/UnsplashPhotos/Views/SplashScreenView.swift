//
//  SplashScreenView.swift
//  UnsplashPhotos
//
//  Created by Mac on 03/08/24.
//

import SwiftUI

struct SplashScreenView: View {
    @Binding var isActive: Bool

    var body: some View {
        VStack {
            Spacer()
            Text("Unsplash Photos")
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding()
            Spacer()
        }
        .background(Color.white)
        .onAppear {
            // Simulate a delay before transitioning to the main view
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                withAnimation {
                    isActive = false
                }
            }
        }
    }
}
