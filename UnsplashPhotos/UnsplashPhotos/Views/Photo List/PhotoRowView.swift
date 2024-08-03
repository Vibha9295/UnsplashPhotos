//
//  PhotoRowView.swift
//  UnsplashPhotos
//
//  Created by Mac on 02/08/24.
//

import Foundation
import SwiftUI

struct PhotoRowView: View {
    let photo: Photo
    @Binding var likedPhotos: Set<String>
    var isInLikedList: Bool
    
    var isLiked: Bool {
        likedPhotos.contains(photo.id)
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            ZStack(alignment: .bottomLeading) {
                AsyncImage(url: URL(string: photo.urls.thumb)) { image in
                    image
                        .resizable()
                        .scaledToFill()
                } placeholder: {
                    ProgressView()
                }
                .frame(maxWidth: .infinity, maxHeight: 200)
                .cornerRadius(5)
                .padding(5)
                
                HStack {
                    Text(photo.user.name)
                        .font(.caption)
                        .padding(6)
                        .background(Color.black.opacity(0.7))
                        .foregroundColor(.white)
                        .cornerRadius(8)
                    
                    Spacer()
                    Button(action: {
                        toggleLike(photo: photo)
                    }) {
                        HStack {
                            Image(systemName: isLiked ? "heart.fill" : "heart")
                                .foregroundColor(isLiked ? .red : .red)
                                .padding(8)
                                .background(Color.black.opacity(0.7))
                                .clipShape(Circle())
                        }
                    }.accessibilityIdentifier("LikeButton")

                }
                .padding(15)
            }
        }
        .padding(.horizontal, 5)
    }
    private func toggleLike(photo: Photo) {
        likedPhotos.update(with: photo.id)
    }
}
