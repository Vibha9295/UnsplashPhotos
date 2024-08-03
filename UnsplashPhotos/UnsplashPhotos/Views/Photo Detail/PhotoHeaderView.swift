//
//  PhotoHeaderView.swift
//  UnsplashPhotos
//
//  Created by Mac on 03/08/24.
//

import Foundation
import SwiftUI

struct PhotoHeaderView: View {
    let userName: String
    let isLiked: Bool
    let toggleLike: () -> Void
    
    var body: some View {
        HStack {
            Text(userName)
                .font(.caption)
                .padding(10)
                .background(Color.black.opacity(0.7))
                .foregroundColor(.white)
                .cornerRadius(8)
            
            Spacer()
            
            Button(action: toggleLike) {
                HStack {
                    Image(systemName: isLiked ? "heart.fill" : "heart")
                        .foregroundColor(.red)
                        .padding(10)
                        .background(Color.black.opacity(0.7))
                        .clipShape(Circle())
                }
            }
            .accessibilityIdentifier("LikeButton")
        }
        .padding(15)
    }
}
